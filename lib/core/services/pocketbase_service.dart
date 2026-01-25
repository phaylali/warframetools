import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/relic_item.dart';
import 'local_db_service.dart';

class PocketBaseService {
  static PocketBase? _pb;
  static const String _relicsInfoCollection = 'relics_info';
  static const String _countersCollection = 'user_counters';
  static const String _usersCollection = 'users';
  static const String _authStoreKey = 'pb_auth';
  static const String _redirectUrlScheme = 'warframetools';

  static PocketBase? get instance => _pb;

  static Future<void> initialize({String? url}) async {
    final pbUrl =
        url ?? dotenv.env['POCKETBASE_URL'] ?? 'http://localhost:8090';

    final prefs = await SharedPreferences.getInstance();

    _pb = PocketBase(
      pbUrl,
      authStore: AsyncAuthStore(
        save: (String data) async => prefs.setString(_authStoreKey, data),
        initial: prefs.getString(_authStoreKey),
      ),
    );

    try {
      await _pb!.health.check();
      if (kDebugMode) print('PocketBase connected successfully to $pbUrl');
    } catch (e) {
      if (kDebugMode) print('PocketBase connection failed: $e');
      _pb = null;
    }
  }

  static bool get isConnected => _pb != null;

  static Future<bool> checkConnection() async {
    if (_pb == null) return false;
    try {
      await _pb!.health.check();
      return true;
    } catch (e) {
      return false;
    }
  }

  static bool get isAuthenticated => _pb?.authStore.isValid ?? false;

  static String? get currentUserId => _pb?.authStore.record?.id;

  static String? get currentUserEmail =>
      _pb?.authStore.record?.getStringValue('email');

  static String? get currentUserName =>
      _pb?.authStore.record?.getStringValue('username');

  static String? get currentUserAvatarUrl =>
      _pb?.authStore.record?.getStringValue('avatarUrl');

  static bool get isVerified =>
      _pb?.authStore.record?.getBoolValue('verified') ?? false;

  static String generateUsername() {
    final random =
        List.generate(9, (index) => (index == 0 ? '1' : '${_randomDigit()}'))
            .join();
    return 'omniversify-$random';
  }

  static int _randomDigit() {
    return DateTime.now().millisecond % 10;
  }

  static Future<void> authenticateWithPassword(
      String email, String password) async {
    if (_pb == null) throw PocketBaseException('Not connected to server');

    await _pb!.collection(_usersCollection).authWithPassword(
          email,
          password,
        );
  }

  static Future<void> signUp({
    required String email,
    required String password,
    String? username,
  }) async {
    if (_pb == null) throw PocketBaseException('Not connected to server');

    final userData = {
      'email': email,
      'password': password,
      'passwordConfirm': password,
      'username': username?.toLowerCase() ?? generateUsername(),
      'verified': false,
    };

    final userRecord =
        await _pb!.collection(_usersCollection).create(body: userData);

    // Authenticate to perform updates if needed
    await authenticateWithPassword(email, password);

    // Assign random avatar
    try {
      final avatars = await fetchAvatarsFromCloud();
      if (avatars.isNotEmpty) {
        final randomAvatar =
            avatars[DateTime.now().microsecond % avatars.length];
        await updateUserProfile(avatarUrl: randomAvatar['imageUrl'] as String);
      }
    } catch (e) {
      if (kDebugMode) print('Failed to assign random avatar: $e');
      // Non-critical error, continue
    }
  }

  static Future<void> authenticateWithGoogle() async {
    if (_pb == null) throw PocketBaseException('Not connected to server');

    final redirectUrl = '$_redirectUrlScheme://oauth-callback';

    await _pb!.collection(_usersCollection).authWithOAuth2(
      'google',
      (url) async {
        final authUrl = Uri.parse(url.toString());
        final redirectUri = Uri.parse(redirectUrl);
        final authUri = authUrl.replace(
          queryParameters: {
            ...authUrl.queryParameters,
            'redirect_uri': redirectUri.toString(),
          },
        );

        if (kDebugMode) print('Opening Google OAuth URL: $authUri');

        await _launchUrl(authUri);
      },
      createData: {
        'username': generateUsername(),
      },
    );
  }

  static Future<void> _launchUrl(Uri url) async {
    try {
      await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
    } catch (e) {
      if (kDebugMode) print('Failed to launch URL: $e');
      throw PocketBaseException('Could not open browser for authentication');
    }
  }

  static Future<void> signOut() async {
    if (_pb != null) {
      _pb!.authStore.clear();
    }
  }

  static Future<void> authRefresh() async {
    if (_pb == null) throw PocketBaseException('Not connected to server');

    await _pb!.collection(_usersCollection).authRefresh();
  }

  static Future<List<String>> getAvailableAuthMethods() async {
    if (_pb == null) throw PocketBaseException('Not connected to server');

    final methods = await _pb!.collection(_usersCollection).listAuthMethods();

    final providers = methods.oauth2.providers;
    final providerNames =
        providers.map((p) => p.name).where((n) => n.isNotEmpty).toList();

    if (methods.password.enabled) {
      providerNames.insert(0, 'password');
    }

    return providerNames;
  }

  static Future<bool> isOAuth2ProviderEnabled(String provider) async {
    if (_pb == null) return false;

    try {
      final methods = await _pb!.collection(_usersCollection).listAuthMethods();
      final providers = methods.oauth2.providers;
      return providers.any((p) => p.name == provider);
    } catch (e) {
      return false;
    }
  }

  static Future<void> updateUserProfile({
    String? username,
    String? email,
    String? avatarUrl,
  }) async {
    if (_pb == null) throw PocketBaseException('Not connected to server');
    if (!isAuthenticated) throw PocketBaseException('Not authenticated');

    final updates = <String, dynamic>{};

    if (username != null) {
      updates['username'] = username;
    }

    if (email != null) {
      updates['email'] = email;
    }

    if (avatarUrl != null) {
      updates['avatarUrl'] = avatarUrl;
    }

    if (updates.isNotEmpty) {
      await _pb!.collection(_usersCollection).update(
            currentUserId!,
            body: updates,
          );
      // Refresh local auth store to reflect changes
      await _pb!.collection(_usersCollection).authRefresh();
    }
  }

  static Future<void> changePassword(
      String currentPassword, String newPassword) async {
    if (_pb == null) throw PocketBaseException('Not connected to server');
    if (!isAuthenticated) throw PocketBaseException('Not authenticated');

    await _pb!.collection(_usersCollection).update(
      currentUserId!,
      body: {
        'oldPassword': currentPassword,
        'password': newPassword,
        'passwordConfirm': newPassword,
      },
    );
  }

  static Future<void> requestPasswordReset(String email) async {
    if (_pb == null) throw PocketBaseException('Not connected to server');

    await _pb!.collection(_usersCollection).requestPasswordReset(email);
  }

  static Future<void> requestEmailChange(String newEmail) async {
    if (_pb == null) throw PocketBaseException('Not connected to server');
    if (!isAuthenticated) throw PocketBaseException('Not authenticated');

    await _pb!.collection(_usersCollection).requestEmailChange(newEmail);
  }

  static Future<void> confirmEmailChange(String token, String password) async {
    if (_pb == null) throw PocketBaseException('Not connected to server');

    await _pb!.collection(_usersCollection).confirmEmailChange(
          token,
          password,
        );
  }

  static Future<void> confirmPasswordReset(
      String token, String newPassword) async {
    if (_pb == null) throw PocketBaseException('Not connected to server');

    await _pb!.collection(_usersCollection).confirmPasswordReset(
          token,
          newPassword,
          newPassword,
        );
  }

  static Future<void> requestVerification(String email) async {
    if (_pb == null) throw PocketBaseException('Not connected to server');

    await _pb!.collection(_usersCollection).requestVerification(email);
  }

  static Future<void> confirmVerification(String token) async {
    if (_pb == null) throw PocketBaseException('Not connected to server');

    await _pb!.collection(_usersCollection).confirmVerification(token);
  }

  static Future<void> deleteAccount(String password) async {
    if (_pb == null) throw PocketBaseException('Not connected to server');
    if (!isAuthenticated) throw PocketBaseException('Not authenticated');

    await _pb!.collection(_usersCollection).delete(
      currentUserId!,
      body: {'password': password},
    );

    signOut();
  }

  static String? get authToken => _pb?.authStore.token;

  static Map<String, dynamic>? get authRecord =>
      _pb?.authStore.record?.toJson();

  static Future<Map<String, dynamic>> getCloudCounters() async {
    if (_pb == null) throw PocketBaseException('Not connected to server');
    if (!isAuthenticated) throw PocketBaseException('Not authenticated');

    final record =
        await _pb!.collection(_usersCollection).getOne(currentUserId!);
    return (record.data['relics_owned'] as Map<String, dynamic>?) ?? {};
  }

  static Future<void> updateCloudCounters(Map<String, dynamic> data) async {
    if (_pb == null) throw PocketBaseException('Not connected to server');
    if (!isAuthenticated) throw PocketBaseException('Not authenticated');

    await _pb!.collection(_usersCollection).update(
      currentUserId!,
      body: {'relics_owned': data},
    );
  }

  static Future<List<Map<String, dynamic>>> fetchAvatarsFromCloud() async {
    if (_pb == null) throw PocketBaseException('Not connected to server');

    final records = await _pb!.collection('avatars').getFullList();

    return records.map((record) {
      final data = record.toJson();
      return {
        'id': record.id,
        'name': data['name'] as String? ?? '',
        'imageUrl': data['imageUrl'] as String? ?? '',
      };
    }).toList();
  }

  static Future<List<Map<String, dynamic>>> fetchRelicInfoFromCloud() async {
    if (kDebugMode) print('fetchRelicInfoFromCloud called');
    if (_pb == null) {
      if (kDebugMode) print('_pb is null, throwing exception');
      throw PocketBaseException('Not connected to server');
    }

    if (kDebugMode) print('Fetching from collection: $_relicsInfoCollection');
    final records = await _pb!.collection(_relicsInfoCollection).getFullList();
    if (kDebugMode) print('Fetched ${records.length} records');

    return records.map((record) {
      final data = record.toJson();
      return {
        'id': record.id,
        'gid': data['gid'] as String? ?? '',
        'name': data['name'] as String? ?? '',
        'imageUrl': data['imageUrl'] as String? ?? '',
        'type': data['type'] as String? ?? '',
        'unvaulted': (data['unvaulted'] as bool?) ?? false,
      };
    }).toList();
  }

  static Future<void> syncRelicInfoFromCloud() async {
    if (kDebugMode) print('syncRelicInfoFromCloud called');
    final cloudData = await fetchRelicInfoFromCloud();
    if (kDebugMode) print('Fetched ${cloudData.length} relics from cloud');
    await LocalDatabaseService.upsertRelicInfoBatch(cloudData);
    if (kDebugMode) print('Upserted ${cloudData.length} relics to local DB');
  }

  static Future<List<Map<String, dynamic>>> fetchCountersFromCloud() async {
    if (_pb == null) throw PocketBaseException('Not connected to server');
    if (!isAuthenticated) throw PocketBaseException('Not authenticated');

    final records = await _pb!.collection(_countersCollection).getFullList();

    return records.map((record) {
      final data = record.toJson();
      return {
        'id': record.id,
        'relicGid': data['relicGid'] as String? ?? '',
        'intact': (data['intact'] as num?)?.toInt() ?? 0,
        'exceptional': (data['exceptional'] as num?)?.toInt() ?? 0,
        'flawless': (data['flawless'] as num?)?.toInt() ?? 0,
        'radiant': (data['radiant'] as num?)?.toInt() ?? 0,
      };
    }).toList();
  }

  static Future<void> pushCounterToCloud(
      String relicGid, Map<String, dynamic> counters) async {
    if (_pb == null) throw PocketBaseException('Not connected to server');
    if (!isAuthenticated) throw PocketBaseException('Not authenticated');

    final existingRecords = await _pb!.collection(_countersCollection).getList(
          filter: 'relicGid = "$relicGid"',
        );

    final data = {
      'relicGid': relicGid,
      'intact': counters['intact'],
      'exceptional': counters['exceptional'],
      'flawless': counters['flawless'],
      'radiant': counters['radiant'],
    };

    if (existingRecords.items.isNotEmpty) {
      await _pb!.collection(_countersCollection).update(
            existingRecords.items.first.id,
            body: data,
          );
    } else {
      await _pb!.collection(_countersCollection).create(body: data);
    }
  }

  static Future<void> pushAllCountersToCloud(
      List<Map<String, dynamic>> counters) async {
    if (_pb == null) throw PocketBaseException('Not connected to server');
    if (!isAuthenticated) throw PocketBaseException('Not authenticated');

    for (final counter in counters) {
      await pushCounterToCloud(counter['relicGid'], counter);
    }
  }

  static String exportRelicsAsJson(List<RelicItem> items) {
    final jsonList = items.map((item) => item.toJson()).toList();
    return jsonEncode(jsonList);
  }

  static List<RelicItem> importRelicsFromJson(String jsonString) {
    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList
        .map((json) => RelicItem.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}

class PocketBaseException implements Exception {
  final String message;
  PocketBaseException(this.message);

  @override
  String toString() => 'PocketBaseException: $message';
}
