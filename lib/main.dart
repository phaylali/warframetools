import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'core/utils/storage_service.dart';
import 'core/services/pocketbase_service.dart';
import 'core/services/image_cache_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');
  await StorageService.init();
  await PocketBaseService.initialize();
  await ImageCacheService.initialize();

  runApp(const ProviderScope(child: WarframeHelperApp()));
}
