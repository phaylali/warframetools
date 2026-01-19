import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:drift/drift.dart';
import 'package:warframetools/core/database/database.dart';

final AppDatabase database = AppDatabase();

class LocalDatabaseService {
  static Future<void> close() async {
    await database.close();
  }

  static Future<void> upsertRelicInfo(Map<String, dynamic> relic) async {
    await database.into(database.relicInfo).insert(
          RelicInfoData(
            id: relic['gid'],
            gid: relic['gid'],
            name: relic['name'],
            imageUrl: relic['imageUrl'] ?? '',
            type: relic['type'],
            unvaulted: (relic['unvaulted'] as bool?) ?? false,
          ),
          mode: InsertMode.insertOrReplace,
        );
  }

  static Future<void> upsertRelicInfoBatch(
      List<Map<String, dynamic>> relics) async {
    await database.batch((batch) {
      batch.insertAll(
        database.relicInfo,
        relics.map((relic) => RelicInfoData(
              id: relic['gid'],
              gid: relic['gid'],
              name: relic['name'],
              imageUrl: relic['imageUrl'] ?? '',
              type: relic['type'],
              unvaulted: (relic['unvaulted'] as bool?) ?? false,
            )),
        mode: InsertMode.insertOrReplace,
      );
    });
  }

  static Future<List<Map<String, dynamic>>> getAllRelicInfo() async {
    final query = await (database.select(database.relicInfo)
          ..orderBy([(t) => OrderingTerm.asc(t.name)]))
        .get();
    return query.map((row) => row.toMap()).toList();
  }

  static Future<List<Map<String, dynamic>>> getRelicInfoByType(
      String type) async {
    final query = await (database.select(database.relicInfo)
          ..where((t) => t.type.equals(type))
          ..orderBy([(t) => OrderingTerm.asc(t.name)]))
        .get();
    return query.map((row) => row.toMap()).toList();
  }

  static Future<Map<String, dynamic>?> getRelicInfoByGid(String gid) async {
    final query = await (database.select(database.relicInfo)
          ..where((t) => t.gid.equals(gid)))
        .getSingleOrNull();
    return query?.toMap();
  }

  static Future<int> getRelicInfoCount() async {
    final count =
        await database.select(database.relicInfo).get().then((r) => r.length);
    return count;
  }

  static Future<void> loadRelicInfoFromAssets() async {
    final count = await getRelicInfoCount();
    if (count > 0) return;

    try {
      final String jsonString =
          await rootBundle.loadString('assets/data/relics.json');
      final List<dynamic> jsonList = jsonDecode(jsonString);

      await database.batch((batch) {
        batch.insertAll(
          database.relicInfo,
          jsonList.map((item) {
            final relic = item as Map<String, dynamic>;
            return RelicInfoData(
              id: relic['gid'],
              gid: relic['gid'],
              name: relic['name'],
              imageUrl: relic['imageUrl'] ?? '',
              type: relic['type'],
              unvaulted: (relic['unvaulted'] as bool?) ?? false,
            );
          }),
          mode: InsertMode.insertOrReplace,
        );
      });
    } catch (e) {}
  }

  static Future<Map<String, dynamic>?> getRelicCounters(String relicGid) async {
    final query = await (database.select(database.relicCounters)
          ..where((t) => t.relicGid.equals(relicGid)))
        .getSingleOrNull();
    return query?.toMap();
  }

  static Future<void> upsertRelicCounters({
    required String relicGid,
    required int intact,
    required int exceptional,
    required int flawless,
    required int radiant,
  }) async {
    await database.into(database.relicCounters).insert(
          RelicCountersData(
            relicGid: relicGid,
            intact: intact,
            exceptional: exceptional,
            flawless: flawless,
            radiant: radiant,
          ),
          mode: InsertMode.insertOrReplace,
        );
  }

  static Future<void> incrementCondition(
      String relicGid, String condition) async {
    final current = await getRelicCounters(relicGid);
    switch (condition.toLowerCase()) {
      case 'intact':
        final newValue = (current?['intact'] as int? ?? 0) + 1;
        await (database.update(database.relicCounters)
              ..where((t) => t.relicGid.equals(relicGid)))
            .write(RelicCountersCompanion(
          intact: Value(newValue),
        ));
        break;
      case 'exceptional':
        final newValue = (current?['exceptional'] as int? ?? 0) + 1;
        await (database.update(database.relicCounters)
              ..where((t) => t.relicGid.equals(relicGid)))
            .write(RelicCountersCompanion(
          exceptional: Value(newValue),
        ));
        break;
      case 'flawless':
        final newValue = (current?['flawless'] as int? ?? 0) + 1;
        await (database.update(database.relicCounters)
              ..where((t) => t.relicGid.equals(relicGid)))
            .write(RelicCountersCompanion(
          flawless: Value(newValue),
        ));
        break;
      case 'radiant':
        final newValue = (current?['radiant'] as int? ?? 0) + 1;
        await (database.update(database.relicCounters)
              ..where((t) => t.relicGid.equals(relicGid)))
            .write(RelicCountersCompanion(
          radiant: Value(newValue),
        ));
        break;
    }
  }

  static Future<void> decrementCondition(
      String relicGid, String condition) async {
    final current = await getRelicCounters(relicGid);
    switch (condition.toLowerCase()) {
      case 'intact':
        final currentValue = current?['intact'] as int? ?? 0;
        if (currentValue <= 0) return;
        await (database.update(database.relicCounters)
              ..where((t) => t.relicGid.equals(relicGid)))
            .write(RelicCountersCompanion(
          intact: Value(currentValue - 1),
        ));
        break;
      case 'exceptional':
        final currentValue = current?['exceptional'] as int? ?? 0;
        if (currentValue <= 0) return;
        await (database.update(database.relicCounters)
              ..where((t) => t.relicGid.equals(relicGid)))
            .write(RelicCountersCompanion(
          exceptional: Value(currentValue - 1),
        ));
        break;
      case 'flawless':
        final currentValue = current?['flawless'] as int? ?? 0;
        if (currentValue <= 0) return;
        await (database.update(database.relicCounters)
              ..where((t) => t.relicGid.equals(relicGid)))
            .write(RelicCountersCompanion(
          flawless: Value(currentValue - 1),
        ));
        break;
      case 'radiant':
        final currentValue = current?['radiant'] as int? ?? 0;
        if (currentValue <= 0) return;
        await (database.update(database.relicCounters)
              ..where((t) => t.relicGid.equals(relicGid)))
            .write(RelicCountersCompanion(
          radiant: Value(currentValue - 1),
        ));
        break;
    }
  }

  static Future<void> resetCondition(String relicGid, String condition) async {
    switch (condition.toLowerCase()) {
      case 'intact':
        await (database.update(database.relicCounters)
              ..where((t) => t.relicGid.equals(relicGid)))
            .write(const RelicCountersCompanion(intact: Value(0)));
        break;
      case 'exceptional':
        await (database.update(database.relicCounters)
              ..where((t) => t.relicGid.equals(relicGid)))
            .write(const RelicCountersCompanion(exceptional: Value(0)));
        break;
      case 'flawless':
        await (database.update(database.relicCounters)
              ..where((t) => t.relicGid.equals(relicGid)))
            .write(const RelicCountersCompanion(flawless: Value(0)));
        break;
      case 'radiant':
        await (database.update(database.relicCounters)
              ..where((t) => t.relicGid.equals(relicGid)))
            .write(const RelicCountersCompanion(radiant: Value(0)));
        break;
    }
  }

  static Future<void> resetAllCounters(String relicGid) async {
    await (database.update(database.relicCounters)
          ..where((t) => t.relicGid.equals(relicGid)))
        .write(const RelicCountersCompanion(
      intact: Value(0),
      exceptional: Value(0),
      flawless: Value(0),
      radiant: Value(0),
    ));
  }

  static Future<void> resetAllCountersGlobal() async {
    await (database.update(database.relicCounters))
        .write(const RelicCountersCompanion(
      intact: Value(0),
      exceptional: Value(0),
      flawless: Value(0),
      radiant: Value(0),
    ));
  }

  static Future<List<Map<String, dynamic>>> getAllCounters() async {
    final query = await database.select(database.relicCounters).get();
    return query.map((row) => row.toMap()).toList();
  }

  static Future<void> setSyncMetadata(String key, String value) async {
    await database.into(database.syncMetadata).insert(
          SyncMetadataData(key: key, value: value),
          mode: InsertMode.insertOrReplace,
        );
  }

  static Future<String?> getSyncMetadata(String key) async {
    final query = await (database.select(database.syncMetadata)
          ..where((t) => t.key.equals(key)))
        .getSingleOrNull();
    return query?.value;
  }

  static Future<void> clearAllData() async {
    await (database.delete(database.relicInfo)).go();
    await (database.delete(database.relicCounters)).go();
    await (database.delete(database.syncMetadata)).go();
  }
}

extension on RelicInfoData {
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'gid': gid,
      'name': name,
      'imageUrl': imageUrl,
      'type': type,
      'updatedAt': updatedAt,
    };
  }
}

extension on RelicCountersData {
  Map<String, dynamic> toMap() {
    return {
      'relicGid': relicGid,
      'intact': intact,
      'exceptional': exceptional,
      'flawless': flawless,
      'radiant': radiant,
      'updatedAt': updatedAt,
    };
  }
}

extension on SyncMetadataData {
  Map<String, dynamic> toMap() {
    return {
      'key': key,
      'value': value,
      'updatedAt': updatedAt,
    };
  }
}
