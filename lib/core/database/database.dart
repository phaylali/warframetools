import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'database.g.dart';

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbPath = await getApplicationDocumentsDirectory();
    final path = p.join(dbPath.path, 'warframetools.db');
    final file = File(path);
    return NativeDatabase.createInBackground(file);
  });
}

@DriftDatabase(
  tables: [RelicInfo, RelicCounters, SyncMetadata],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 3;
}

@DataClassName('RelicInfoData')
class RelicInfo extends Table {
  TextColumn get id => text()();
  TextColumn get gid => text()();
  TextColumn get name => text()();
  TextColumn get imageUrl => text().nullable()();
  TextColumn get type => text()();
  BoolColumn get unvaulted => boolean().withDefault(const Constant(false))();
  TextColumn get updatedAt => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('RelicCountersData')
class RelicCounters extends Table {
  TextColumn get relicGid => text()();
  IntColumn get intact => integer().withDefault(Constant(0))();
  IntColumn get exceptional => integer().withDefault(Constant(0))();
  IntColumn get flawless => integer().withDefault(Constant(0))();
  IntColumn get radiant => integer().withDefault(Constant(0))();
  TextColumn get updatedAt => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {relicGid};
}

@DataClassName('SyncMetadataData')
class SyncMetadata extends Table {
  TextColumn get key => text()();
  TextColumn get value => text().nullable()();
  TextColumn get updatedAt => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {key};
}
