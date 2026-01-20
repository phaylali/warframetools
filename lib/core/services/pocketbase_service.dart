import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pocketbase/pocketbase.dart';
import '../../models/relic_item.dart';
import 'local_db_service.dart';

class PocketBaseService {
  static PocketBase? _pb;
  static const String _relicsInfoCollection = 'relics_info';
  static const String _countersCollection = 'user_counters';

  static PocketBase? get instance => _pb;

  static Future<void> initialize({String? url}) async {
    final pbUrl =
        url ?? dotenv.env['POCKETBASE_URL'] ?? 'http://localhost:8090';
    _pb = PocketBase(pbUrl);

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

  static Future<void> authenticate(String email, String password) async {
    if (_pb == null) throw PocketBaseException('Not connected to server');
    await _pb!.collection('users').authWithPassword(email, password);
  }

  static Future<void> signOut() async {
    if (_pb != null) {
      _pb!.authStore.clear();
    }
  }

  static bool get isAuthenticated => _pb?.authStore.isValid ?? false;

  // Relic INFO operations
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

  // Counter sync operations
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
