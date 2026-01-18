import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class LocalDatabaseService {
  static Database? _database;
  static const String _dbName = 'warframetools.db';

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, _dbName);

    return openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  static Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS relic_info (
        id TEXT PRIMARY KEY,
        gid TEXT NOT NULL,
        name TEXT NOT NULL,
        imageUrl TEXT,
        type TEXT NOT NULL,
        updatedAt TEXT DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS relic_counters (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        relicGid TEXT NOT NULL,
        intact INTEGER DEFAULT 0,
        exceptional INTEGER DEFAULT 0,
        flawless INTEGER DEFAULT 0,
        radiant INTEGER DEFAULT 0,
        updatedAt TEXT DEFAULT CURRENT_TIMESTAMP,
        UNIQUE(relicGid)
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS sync_metadata (
        key TEXT PRIMARY KEY,
        value TEXT,
        updatedAt TEXT DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    await db.execute(
        'CREATE INDEX IF NOT EXISTS idx_relic_info_type ON relic_info(type)');
    await db.execute(
        'CREATE INDEX IF NOT EXISTS idx_relic_counters_gid ON relic_counters(relicGid)');
  }

  static Future<void> _onUpgrade(
      Database db, int oldVersion, int newVersion) async {
    // Future migration logic can go here
  }

  static Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }

  // Relic INFO operations
  static Future<void> upsertRelicInfo(Map<String, dynamic> relic) async {
    final db = await database;
    await db.insert(
      'relic_info',
      {
        ...relic,
        'updatedAt': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> upsertRelicInfoBatch(
      List<Map<String, dynamic>> relics) async {
    final db = await database;
    final batch = db.batch();
    final now = DateTime.now().toIso8601String();

    for (final relic in relics) {
      batch.insert(
        'relic_info',
        {...relic, 'updatedAt': now},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit();
  }

  static Future<List<Map<String, dynamic>>> getAllRelicInfo() async {
    final db = await database;
    final maps = await db.query('relic_info', orderBy: 'name ASC');
    return maps.map((m) => Map<String, dynamic>.from(m)).toList();
  }

  static Future<List<Map<String, dynamic>>> getRelicInfoByType(
      String type) async {
    final db = await database;
    final maps = await db.query(
      'relic_info',
      where: 'type = ?',
      whereArgs: [type],
      orderBy: 'name ASC',
    );
    return maps.map((m) => Map<String, dynamic>.from(m)).toList();
  }

  static Future<Map<String, dynamic>?> getRelicInfoByGid(String gid) async {
    final db = await database;
    final maps = await db.query(
      'relic_info',
      where: 'gid = ?',
      whereArgs: [gid],
    );
    return maps.isNotEmpty ? Map<String, dynamic>.from(maps.first) : null;
  }

  static Future<int> getRelicInfoCount() async {
    final db = await database;
    return Sqflite.firstIntValue(
            await db.rawQuery('SELECT COUNT(*) FROM relic_info')) ??
        0;
  }

  static Future<void> loadRelicInfoFromAssets() async {
    final db = await database;
    final count = await getRelicInfoCount();
    if (count > 0) return;

    try {
      final String jsonString =
          await rootBundle.loadString('assets/data/relics.json');
      final List<dynamic> jsonList = jsonDecode(jsonString);

      final batch = db.batch();
      for (final item in jsonList) {
        final relic = item as Map<String, dynamic>;
        batch.insert(
          'relic_info',
          {
            'id': relic['gid'],
            'gid': relic['gid'],
            'name': relic['name'],
            'imageUrl': relic['imageUrl'] ?? '',
            'type': relic['type'],
            'updatedAt': DateTime.now().toIso8601String(),
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }

      await batch.commit();
    } catch (e) {
      // Silently fail - app will show empty state
    }
  }

  // Relic Counter operations
  static Future<Map<String, dynamic>?> getRelicCounters(String relicGid) async {
    final db = await database;
    final maps = await db.query(
      'relic_counters',
      where: 'relicGid = ?',
      whereArgs: [relicGid],
    );
    return maps.isNotEmpty ? Map<String, dynamic>.from(maps.first) : null;
  }

  static Future<void> upsertRelicCounters({
    required String relicGid,
    required int intact,
    required int exceptional,
    required int flawless,
    required int radiant,
  }) async {
    final db = await database;
    await db.insert(
      'relic_counters',
      {
        'relicGid': relicGid,
        'intact': intact,
        'exceptional': exceptional,
        'flawless': flawless,
        'radiant': radiant,
        'updatedAt': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> incrementCondition(
      String relicGid, String condition) async {
    final db = await database;
    final column = condition.toLowerCase();
    await db.rawUpdate(
      '''
      UPDATE relic_counters
      SET $column = $column + 1,
          updatedAt = ?
      WHERE relicGid = ?
      ''',
      [DateTime.now().toIso8601String(), relicGid],
    );
  }

  static Future<void> decrementCondition(
      String relicGid, String condition) async {
    final db = await database;
    final column = condition.toLowerCase();
    await db.rawUpdate(
      '''
      UPDATE relic_counters
      SET $column = CASE WHEN $column > 0 THEN $column - 1 ELSE 0 END,
          updatedAt = ?
      WHERE relicGid = ?
      ''',
      [DateTime.now().toIso8601String(), relicGid],
    );
  }

  static Future<void> resetCondition(String relicGid, String condition) async {
    final db = await database;
    final column = condition.toLowerCase();
    await db.rawUpdate(
      '''
      UPDATE relic_counters
      SET $column = 0,
          updatedAt = ?
      WHERE relicGid = ?
      ''',
      [DateTime.now().toIso8601String(), relicGid],
    );
  }

  static Future<void> resetAllCounters(String relicGid) async {
    final db = await database;
    await db.rawUpdate(
      '''
      UPDATE relic_counters
      SET intact = 0, exceptional = 0, flawless = 0, radiant = 0,
          updatedAt = ?
      WHERE relicGid = ?
      ''',
      [DateTime.now().toIso8601String(), relicGid],
    );
  }

  static Future<void> resetAllCountersGlobal() async {
    final db = await database;
    await db.execute(
        'UPDATE relic_counters SET intact = 0, exceptional = 0, flawless = 0, radiant = 0');
  }

  static Future<List<Map<String, dynamic>>> getAllCounters() async {
    final db = await database;
    final maps = await db.query('relic_counters');
    return maps.map((m) => Map<String, dynamic>.from(m)).toList();
  }

  // Sync metadata
  static Future<void> setSyncMetadata(String key, String value) async {
    final db = await database;
    await db.insert(
      'sync_metadata',
      {
        'key': key,
        'value': value,
        'updatedAt': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<String?> getSyncMetadata(String key) async {
    final db = await database;
    final maps = await db.query(
      'sync_metadata',
      where: 'key = ?',
      whereArgs: [key],
    );
    return maps.isNotEmpty ? maps.first['value'] as String? : null;
  }

  // Utility
  static Future<void> clearAllData() async {
    final db = await database;
    await db.execute('DELETE FROM relic_info');
    await db.execute('DELETE FROM relic_counters');
    await db.execute('DELETE FROM sync_metadata');
  }
}
