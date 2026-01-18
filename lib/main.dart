import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'core/utils/storage_service.dart';
import 'core/services/pocketbase_service.dart';
import 'core/services/local_db_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await StorageService.init();
  await LocalDatabaseService.database;
  await PocketBaseService.initialize();

  runApp(const ProviderScope(child: WarframeHelperApp()));
}
