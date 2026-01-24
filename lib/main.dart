import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:app_links/app_links.dart';
import 'app.dart';
import 'core/utils/storage_service.dart';
import 'core/services/pocketbase_service.dart';
import 'core/services/image_cache_service.dart';
import 'router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');
  await StorageService.init();
  await PocketBaseService.initialize();
  await ImageCacheService.initialize();

  // Set up deep link handling
  final appLinks = AppLinks();
  appLinks.uriLinkStream.listen(_handleDeepLink);
  final initialLink = await appLinks.getInitialLink();
  if (initialLink != null) {
    _handleDeepLink(initialLink);
  }

  runApp(const ProviderScope(child: WarframeHelperApp()));
}

void _handleDeepLink(Uri uri) {
  if (uri.scheme != 'warframetools') return;

  if (uri.path == '/verify') {
    final token = uri.queryParameters['token'];
    if (token != null) {
      PocketBaseService.confirmVerification(token).then((_) {
        if (navigatorKey.currentContext != null) {
          ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
            const SnackBar(content: Text('Email verified successfully!')),
          );
        }
      }).catchError((error) {
        if (navigatorKey.currentContext != null) {
          ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
            SnackBar(content: Text('Verification failed: $error')),
          );
        }
      });
    }
  } else if (uri.path == '/password-reset') {
    final token = uri.queryParameters['token'];
    if (token != null && navigatorKey.currentContext != null) {
      GoRouter.of(navigatorKey.currentContext!)
          .go('/password-reset?token=$token');
    }
  }
}
