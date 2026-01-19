// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $RelicInfoTable extends RelicInfo
    with TableInfo<$RelicInfoTable, RelicInfoData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RelicInfoTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _gidMeta = const VerificationMeta('gid');
  @override
  late final GeneratedColumn<String> gid = GeneratedColumn<String>(
      'gid', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _imageUrlMeta =
      const VerificationMeta('imageUrl');
  @override
  late final GeneratedColumn<String> imageUrl = GeneratedColumn<String>(
      'image_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _unvaultedMeta =
      const VerificationMeta('unvaulted');
  @override
  late final GeneratedColumn<bool> unvaulted = GeneratedColumn<bool>(
      'unvaulted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("unvaulted" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, gid, name, imageUrl, type, unvaulted, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'relic_info';
  @override
  VerificationContext validateIntegrity(Insertable<RelicInfoData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('gid')) {
      context.handle(
          _gidMeta, gid.isAcceptableOrUnknown(data['gid']!, _gidMeta));
    } else if (isInserting) {
      context.missing(_gidMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('image_url')) {
      context.handle(_imageUrlMeta,
          imageUrl.isAcceptableOrUnknown(data['image_url']!, _imageUrlMeta));
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('unvaulted')) {
      context.handle(_unvaultedMeta,
          unvaulted.isAcceptableOrUnknown(data['unvaulted']!, _unvaultedMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RelicInfoData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RelicInfoData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      gid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}gid'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      imageUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}image_url']),
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      unvaulted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}unvaulted'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}updated_at']),
    );
  }

  @override
  $RelicInfoTable createAlias(String alias) {
    return $RelicInfoTable(attachedDatabase, alias);
  }
}

class RelicInfoData extends DataClass implements Insertable<RelicInfoData> {
  final String id;
  final String gid;
  final String name;
  final String? imageUrl;
  final String type;
  final bool unvaulted;
  final String? updatedAt;
  const RelicInfoData(
      {required this.id,
      required this.gid,
      required this.name,
      this.imageUrl,
      required this.type,
      required this.unvaulted,
      this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['gid'] = Variable<String>(gid);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || imageUrl != null) {
      map['image_url'] = Variable<String>(imageUrl);
    }
    map['type'] = Variable<String>(type);
    map['unvaulted'] = Variable<bool>(unvaulted);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<String>(updatedAt);
    }
    return map;
  }

  RelicInfoCompanion toCompanion(bool nullToAbsent) {
    return RelicInfoCompanion(
      id: Value(id),
      gid: Value(gid),
      name: Value(name),
      imageUrl: imageUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(imageUrl),
      type: Value(type),
      unvaulted: Value(unvaulted),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory RelicInfoData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RelicInfoData(
      id: serializer.fromJson<String>(json['id']),
      gid: serializer.fromJson<String>(json['gid']),
      name: serializer.fromJson<String>(json['name']),
      imageUrl: serializer.fromJson<String?>(json['imageUrl']),
      type: serializer.fromJson<String>(json['type']),
      unvaulted: serializer.fromJson<bool>(json['unvaulted']),
      updatedAt: serializer.fromJson<String?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'gid': serializer.toJson<String>(gid),
      'name': serializer.toJson<String>(name),
      'imageUrl': serializer.toJson<String?>(imageUrl),
      'type': serializer.toJson<String>(type),
      'unvaulted': serializer.toJson<bool>(unvaulted),
      'updatedAt': serializer.toJson<String?>(updatedAt),
    };
  }

  RelicInfoData copyWith(
          {String? id,
          String? gid,
          String? name,
          Value<String?> imageUrl = const Value.absent(),
          String? type,
          bool? unvaulted,
          Value<String?> updatedAt = const Value.absent()}) =>
      RelicInfoData(
        id: id ?? this.id,
        gid: gid ?? this.gid,
        name: name ?? this.name,
        imageUrl: imageUrl.present ? imageUrl.value : this.imageUrl,
        type: type ?? this.type,
        unvaulted: unvaulted ?? this.unvaulted,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
      );
  RelicInfoData copyWithCompanion(RelicInfoCompanion data) {
    return RelicInfoData(
      id: data.id.present ? data.id.value : this.id,
      gid: data.gid.present ? data.gid.value : this.gid,
      name: data.name.present ? data.name.value : this.name,
      imageUrl: data.imageUrl.present ? data.imageUrl.value : this.imageUrl,
      type: data.type.present ? data.type.value : this.type,
      unvaulted: data.unvaulted.present ? data.unvaulted.value : this.unvaulted,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RelicInfoData(')
          ..write('id: $id, ')
          ..write('gid: $gid, ')
          ..write('name: $name, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('type: $type, ')
          ..write('unvaulted: $unvaulted, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, gid, name, imageUrl, type, unvaulted, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RelicInfoData &&
          other.id == this.id &&
          other.gid == this.gid &&
          other.name == this.name &&
          other.imageUrl == this.imageUrl &&
          other.type == this.type &&
          other.unvaulted == this.unvaulted &&
          other.updatedAt == this.updatedAt);
}

class RelicInfoCompanion extends UpdateCompanion<RelicInfoData> {
  final Value<String> id;
  final Value<String> gid;
  final Value<String> name;
  final Value<String?> imageUrl;
  final Value<String> type;
  final Value<bool> unvaulted;
  final Value<String?> updatedAt;
  final Value<int> rowid;
  const RelicInfoCompanion({
    this.id = const Value.absent(),
    this.gid = const Value.absent(),
    this.name = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.type = const Value.absent(),
    this.unvaulted = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RelicInfoCompanion.insert({
    required String id,
    required String gid,
    required String name,
    this.imageUrl = const Value.absent(),
    required String type,
    this.unvaulted = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        gid = Value(gid),
        name = Value(name),
        type = Value(type);
  static Insertable<RelicInfoData> custom({
    Expression<String>? id,
    Expression<String>? gid,
    Expression<String>? name,
    Expression<String>? imageUrl,
    Expression<String>? type,
    Expression<bool>? unvaulted,
    Expression<String>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (gid != null) 'gid': gid,
      if (name != null) 'name': name,
      if (imageUrl != null) 'image_url': imageUrl,
      if (type != null) 'type': type,
      if (unvaulted != null) 'unvaulted': unvaulted,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RelicInfoCompanion copyWith(
      {Value<String>? id,
      Value<String>? gid,
      Value<String>? name,
      Value<String?>? imageUrl,
      Value<String>? type,
      Value<bool>? unvaulted,
      Value<String?>? updatedAt,
      Value<int>? rowid}) {
    return RelicInfoCompanion(
      id: id ?? this.id,
      gid: gid ?? this.gid,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      type: type ?? this.type,
      unvaulted: unvaulted ?? this.unvaulted,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (gid.present) {
      map['gid'] = Variable<String>(gid.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (imageUrl.present) {
      map['image_url'] = Variable<String>(imageUrl.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (unvaulted.present) {
      map['unvaulted'] = Variable<bool>(unvaulted.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RelicInfoCompanion(')
          ..write('id: $id, ')
          ..write('gid: $gid, ')
          ..write('name: $name, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('type: $type, ')
          ..write('unvaulted: $unvaulted, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RelicCountersTable extends RelicCounters
    with TableInfo<$RelicCountersTable, RelicCountersData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RelicCountersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _relicGidMeta =
      const VerificationMeta('relicGid');
  @override
  late final GeneratedColumn<String> relicGid = GeneratedColumn<String>(
      'relic_gid', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _intactMeta = const VerificationMeta('intact');
  @override
  late final GeneratedColumn<int> intact = GeneratedColumn<int>(
      'intact', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: Constant(0));
  static const VerificationMeta _exceptionalMeta =
      const VerificationMeta('exceptional');
  @override
  late final GeneratedColumn<int> exceptional = GeneratedColumn<int>(
      'exceptional', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: Constant(0));
  static const VerificationMeta _flawlessMeta =
      const VerificationMeta('flawless');
  @override
  late final GeneratedColumn<int> flawless = GeneratedColumn<int>(
      'flawless', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: Constant(0));
  static const VerificationMeta _radiantMeta =
      const VerificationMeta('radiant');
  @override
  late final GeneratedColumn<int> radiant = GeneratedColumn<int>(
      'radiant', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: Constant(0));
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [relicGid, intact, exceptional, flawless, radiant, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'relic_counters';
  @override
  VerificationContext validateIntegrity(Insertable<RelicCountersData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('relic_gid')) {
      context.handle(_relicGidMeta,
          relicGid.isAcceptableOrUnknown(data['relic_gid']!, _relicGidMeta));
    } else if (isInserting) {
      context.missing(_relicGidMeta);
    }
    if (data.containsKey('intact')) {
      context.handle(_intactMeta,
          intact.isAcceptableOrUnknown(data['intact']!, _intactMeta));
    }
    if (data.containsKey('exceptional')) {
      context.handle(
          _exceptionalMeta,
          exceptional.isAcceptableOrUnknown(
              data['exceptional']!, _exceptionalMeta));
    }
    if (data.containsKey('flawless')) {
      context.handle(_flawlessMeta,
          flawless.isAcceptableOrUnknown(data['flawless']!, _flawlessMeta));
    }
    if (data.containsKey('radiant')) {
      context.handle(_radiantMeta,
          radiant.isAcceptableOrUnknown(data['radiant']!, _radiantMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {relicGid};
  @override
  RelicCountersData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RelicCountersData(
      relicGid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}relic_gid'])!,
      intact: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}intact'])!,
      exceptional: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}exceptional'])!,
      flawless: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}flawless'])!,
      radiant: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}radiant'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}updated_at']),
    );
  }

  @override
  $RelicCountersTable createAlias(String alias) {
    return $RelicCountersTable(attachedDatabase, alias);
  }
}

class RelicCountersData extends DataClass
    implements Insertable<RelicCountersData> {
  final String relicGid;
  final int intact;
  final int exceptional;
  final int flawless;
  final int radiant;
  final String? updatedAt;
  const RelicCountersData(
      {required this.relicGid,
      required this.intact,
      required this.exceptional,
      required this.flawless,
      required this.radiant,
      this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['relic_gid'] = Variable<String>(relicGid);
    map['intact'] = Variable<int>(intact);
    map['exceptional'] = Variable<int>(exceptional);
    map['flawless'] = Variable<int>(flawless);
    map['radiant'] = Variable<int>(radiant);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<String>(updatedAt);
    }
    return map;
  }

  RelicCountersCompanion toCompanion(bool nullToAbsent) {
    return RelicCountersCompanion(
      relicGid: Value(relicGid),
      intact: Value(intact),
      exceptional: Value(exceptional),
      flawless: Value(flawless),
      radiant: Value(radiant),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory RelicCountersData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RelicCountersData(
      relicGid: serializer.fromJson<String>(json['relicGid']),
      intact: serializer.fromJson<int>(json['intact']),
      exceptional: serializer.fromJson<int>(json['exceptional']),
      flawless: serializer.fromJson<int>(json['flawless']),
      radiant: serializer.fromJson<int>(json['radiant']),
      updatedAt: serializer.fromJson<String?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'relicGid': serializer.toJson<String>(relicGid),
      'intact': serializer.toJson<int>(intact),
      'exceptional': serializer.toJson<int>(exceptional),
      'flawless': serializer.toJson<int>(flawless),
      'radiant': serializer.toJson<int>(radiant),
      'updatedAt': serializer.toJson<String?>(updatedAt),
    };
  }

  RelicCountersData copyWith(
          {String? relicGid,
          int? intact,
          int? exceptional,
          int? flawless,
          int? radiant,
          Value<String?> updatedAt = const Value.absent()}) =>
      RelicCountersData(
        relicGid: relicGid ?? this.relicGid,
        intact: intact ?? this.intact,
        exceptional: exceptional ?? this.exceptional,
        flawless: flawless ?? this.flawless,
        radiant: radiant ?? this.radiant,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
      );
  RelicCountersData copyWithCompanion(RelicCountersCompanion data) {
    return RelicCountersData(
      relicGid: data.relicGid.present ? data.relicGid.value : this.relicGid,
      intact: data.intact.present ? data.intact.value : this.intact,
      exceptional:
          data.exceptional.present ? data.exceptional.value : this.exceptional,
      flawless: data.flawless.present ? data.flawless.value : this.flawless,
      radiant: data.radiant.present ? data.radiant.value : this.radiant,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RelicCountersData(')
          ..write('relicGid: $relicGid, ')
          ..write('intact: $intact, ')
          ..write('exceptional: $exceptional, ')
          ..write('flawless: $flawless, ')
          ..write('radiant: $radiant, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(relicGid, intact, exceptional, flawless, radiant, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RelicCountersData &&
          other.relicGid == this.relicGid &&
          other.intact == this.intact &&
          other.exceptional == this.exceptional &&
          other.flawless == this.flawless &&
          other.radiant == this.radiant &&
          other.updatedAt == this.updatedAt);
}

class RelicCountersCompanion extends UpdateCompanion<RelicCountersData> {
  final Value<String> relicGid;
  final Value<int> intact;
  final Value<int> exceptional;
  final Value<int> flawless;
  final Value<int> radiant;
  final Value<String?> updatedAt;
  final Value<int> rowid;
  const RelicCountersCompanion({
    this.relicGid = const Value.absent(),
    this.intact = const Value.absent(),
    this.exceptional = const Value.absent(),
    this.flawless = const Value.absent(),
    this.radiant = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RelicCountersCompanion.insert({
    required String relicGid,
    this.intact = const Value.absent(),
    this.exceptional = const Value.absent(),
    this.flawless = const Value.absent(),
    this.radiant = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : relicGid = Value(relicGid);
  static Insertable<RelicCountersData> custom({
    Expression<String>? relicGid,
    Expression<int>? intact,
    Expression<int>? exceptional,
    Expression<int>? flawless,
    Expression<int>? radiant,
    Expression<String>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (relicGid != null) 'relic_gid': relicGid,
      if (intact != null) 'intact': intact,
      if (exceptional != null) 'exceptional': exceptional,
      if (flawless != null) 'flawless': flawless,
      if (radiant != null) 'radiant': radiant,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RelicCountersCompanion copyWith(
      {Value<String>? relicGid,
      Value<int>? intact,
      Value<int>? exceptional,
      Value<int>? flawless,
      Value<int>? radiant,
      Value<String?>? updatedAt,
      Value<int>? rowid}) {
    return RelicCountersCompanion(
      relicGid: relicGid ?? this.relicGid,
      intact: intact ?? this.intact,
      exceptional: exceptional ?? this.exceptional,
      flawless: flawless ?? this.flawless,
      radiant: radiant ?? this.radiant,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (relicGid.present) {
      map['relic_gid'] = Variable<String>(relicGid.value);
    }
    if (intact.present) {
      map['intact'] = Variable<int>(intact.value);
    }
    if (exceptional.present) {
      map['exceptional'] = Variable<int>(exceptional.value);
    }
    if (flawless.present) {
      map['flawless'] = Variable<int>(flawless.value);
    }
    if (radiant.present) {
      map['radiant'] = Variable<int>(radiant.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RelicCountersCompanion(')
          ..write('relicGid: $relicGid, ')
          ..write('intact: $intact, ')
          ..write('exceptional: $exceptional, ')
          ..write('flawless: $flawless, ')
          ..write('radiant: $radiant, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncMetadataTable extends SyncMetadata
    with TableInfo<$SyncMetadataTable, SyncMetadataData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncMetadataTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
      'key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
      'value', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [key, value, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_metadata';
  @override
  VerificationContext validateIntegrity(Insertable<SyncMetadataData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
          _keyMeta, key.isAcceptableOrUnknown(data['key']!, _keyMeta));
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
          _valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  SyncMetadataData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncMetadataData(
      key: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}key'])!,
      value: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}value']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}updated_at']),
    );
  }

  @override
  $SyncMetadataTable createAlias(String alias) {
    return $SyncMetadataTable(attachedDatabase, alias);
  }
}

class SyncMetadataData extends DataClass
    implements Insertable<SyncMetadataData> {
  final String key;
  final String? value;
  final String? updatedAt;
  const SyncMetadataData({required this.key, this.value, this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    if (!nullToAbsent || value != null) {
      map['value'] = Variable<String>(value);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<String>(updatedAt);
    }
    return map;
  }

  SyncMetadataCompanion toCompanion(bool nullToAbsent) {
    return SyncMetadataCompanion(
      key: Value(key),
      value:
          value == null && nullToAbsent ? const Value.absent() : Value(value),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory SyncMetadataData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncMetadataData(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String?>(json['value']),
      updatedAt: serializer.fromJson<String?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String?>(value),
      'updatedAt': serializer.toJson<String?>(updatedAt),
    };
  }

  SyncMetadataData copyWith(
          {String? key,
          Value<String?> value = const Value.absent(),
          Value<String?> updatedAt = const Value.absent()}) =>
      SyncMetadataData(
        key: key ?? this.key,
        value: value.present ? value.value : this.value,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
      );
  SyncMetadataData copyWithCompanion(SyncMetadataCompanion data) {
    return SyncMetadataData(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncMetadataData(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncMetadataData &&
          other.key == this.key &&
          other.value == this.value &&
          other.updatedAt == this.updatedAt);
}

class SyncMetadataCompanion extends UpdateCompanion<SyncMetadataData> {
  final Value<String> key;
  final Value<String?> value;
  final Value<String?> updatedAt;
  final Value<int> rowid;
  const SyncMetadataCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncMetadataCompanion.insert({
    required String key,
    this.value = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : key = Value(key);
  static Insertable<SyncMetadataData> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<String>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncMetadataCompanion copyWith(
      {Value<String>? key,
      Value<String?>? value,
      Value<String?>? updatedAt,
      Value<int>? rowid}) {
    return SyncMetadataCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncMetadataCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $RelicInfoTable relicInfo = $RelicInfoTable(this);
  late final $RelicCountersTable relicCounters = $RelicCountersTable(this);
  late final $SyncMetadataTable syncMetadata = $SyncMetadataTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [relicInfo, relicCounters, syncMetadata];
}

typedef $$RelicInfoTableCreateCompanionBuilder = RelicInfoCompanion Function({
  required String id,
  required String gid,
  required String name,
  Value<String?> imageUrl,
  required String type,
  Value<bool> unvaulted,
  Value<String?> updatedAt,
  Value<int> rowid,
});
typedef $$RelicInfoTableUpdateCompanionBuilder = RelicInfoCompanion Function({
  Value<String> id,
  Value<String> gid,
  Value<String> name,
  Value<String?> imageUrl,
  Value<String> type,
  Value<bool> unvaulted,
  Value<String?> updatedAt,
  Value<int> rowid,
});

class $$RelicInfoTableFilterComposer
    extends Composer<_$AppDatabase, $RelicInfoTable> {
  $$RelicInfoTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get gid => $composableBuilder(
      column: $table.gid, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get imageUrl => $composableBuilder(
      column: $table.imageUrl, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get unvaulted => $composableBuilder(
      column: $table.unvaulted, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$RelicInfoTableOrderingComposer
    extends Composer<_$AppDatabase, $RelicInfoTable> {
  $$RelicInfoTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get gid => $composableBuilder(
      column: $table.gid, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get imageUrl => $composableBuilder(
      column: $table.imageUrl, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get unvaulted => $composableBuilder(
      column: $table.unvaulted, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$RelicInfoTableAnnotationComposer
    extends Composer<_$AppDatabase, $RelicInfoTable> {
  $$RelicInfoTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get gid =>
      $composableBuilder(column: $table.gid, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get imageUrl =>
      $composableBuilder(column: $table.imageUrl, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<bool> get unvaulted =>
      $composableBuilder(column: $table.unvaulted, builder: (column) => column);

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$RelicInfoTableTableManager extends RootTableManager<
    _$AppDatabase,
    $RelicInfoTable,
    RelicInfoData,
    $$RelicInfoTableFilterComposer,
    $$RelicInfoTableOrderingComposer,
    $$RelicInfoTableAnnotationComposer,
    $$RelicInfoTableCreateCompanionBuilder,
    $$RelicInfoTableUpdateCompanionBuilder,
    (
      RelicInfoData,
      BaseReferences<_$AppDatabase, $RelicInfoTable, RelicInfoData>
    ),
    RelicInfoData,
    PrefetchHooks Function()> {
  $$RelicInfoTableTableManager(_$AppDatabase db, $RelicInfoTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RelicInfoTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RelicInfoTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RelicInfoTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> gid = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> imageUrl = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<bool> unvaulted = const Value.absent(),
            Value<String?> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RelicInfoCompanion(
            id: id,
            gid: gid,
            name: name,
            imageUrl: imageUrl,
            type: type,
            unvaulted: unvaulted,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String gid,
            required String name,
            Value<String?> imageUrl = const Value.absent(),
            required String type,
            Value<bool> unvaulted = const Value.absent(),
            Value<String?> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RelicInfoCompanion.insert(
            id: id,
            gid: gid,
            name: name,
            imageUrl: imageUrl,
            type: type,
            unvaulted: unvaulted,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$RelicInfoTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $RelicInfoTable,
    RelicInfoData,
    $$RelicInfoTableFilterComposer,
    $$RelicInfoTableOrderingComposer,
    $$RelicInfoTableAnnotationComposer,
    $$RelicInfoTableCreateCompanionBuilder,
    $$RelicInfoTableUpdateCompanionBuilder,
    (
      RelicInfoData,
      BaseReferences<_$AppDatabase, $RelicInfoTable, RelicInfoData>
    ),
    RelicInfoData,
    PrefetchHooks Function()>;
typedef $$RelicCountersTableCreateCompanionBuilder = RelicCountersCompanion
    Function({
  required String relicGid,
  Value<int> intact,
  Value<int> exceptional,
  Value<int> flawless,
  Value<int> radiant,
  Value<String?> updatedAt,
  Value<int> rowid,
});
typedef $$RelicCountersTableUpdateCompanionBuilder = RelicCountersCompanion
    Function({
  Value<String> relicGid,
  Value<int> intact,
  Value<int> exceptional,
  Value<int> flawless,
  Value<int> radiant,
  Value<String?> updatedAt,
  Value<int> rowid,
});

class $$RelicCountersTableFilterComposer
    extends Composer<_$AppDatabase, $RelicCountersTable> {
  $$RelicCountersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get relicGid => $composableBuilder(
      column: $table.relicGid, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get intact => $composableBuilder(
      column: $table.intact, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get exceptional => $composableBuilder(
      column: $table.exceptional, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get flawless => $composableBuilder(
      column: $table.flawless, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get radiant => $composableBuilder(
      column: $table.radiant, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$RelicCountersTableOrderingComposer
    extends Composer<_$AppDatabase, $RelicCountersTable> {
  $$RelicCountersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get relicGid => $composableBuilder(
      column: $table.relicGid, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get intact => $composableBuilder(
      column: $table.intact, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get exceptional => $composableBuilder(
      column: $table.exceptional, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get flawless => $composableBuilder(
      column: $table.flawless, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get radiant => $composableBuilder(
      column: $table.radiant, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$RelicCountersTableAnnotationComposer
    extends Composer<_$AppDatabase, $RelicCountersTable> {
  $$RelicCountersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get relicGid =>
      $composableBuilder(column: $table.relicGid, builder: (column) => column);

  GeneratedColumn<int> get intact =>
      $composableBuilder(column: $table.intact, builder: (column) => column);

  GeneratedColumn<int> get exceptional => $composableBuilder(
      column: $table.exceptional, builder: (column) => column);

  GeneratedColumn<int> get flawless =>
      $composableBuilder(column: $table.flawless, builder: (column) => column);

  GeneratedColumn<int> get radiant =>
      $composableBuilder(column: $table.radiant, builder: (column) => column);

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$RelicCountersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $RelicCountersTable,
    RelicCountersData,
    $$RelicCountersTableFilterComposer,
    $$RelicCountersTableOrderingComposer,
    $$RelicCountersTableAnnotationComposer,
    $$RelicCountersTableCreateCompanionBuilder,
    $$RelicCountersTableUpdateCompanionBuilder,
    (
      RelicCountersData,
      BaseReferences<_$AppDatabase, $RelicCountersTable, RelicCountersData>
    ),
    RelicCountersData,
    PrefetchHooks Function()> {
  $$RelicCountersTableTableManager(_$AppDatabase db, $RelicCountersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RelicCountersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RelicCountersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RelicCountersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> relicGid = const Value.absent(),
            Value<int> intact = const Value.absent(),
            Value<int> exceptional = const Value.absent(),
            Value<int> flawless = const Value.absent(),
            Value<int> radiant = const Value.absent(),
            Value<String?> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RelicCountersCompanion(
            relicGid: relicGid,
            intact: intact,
            exceptional: exceptional,
            flawless: flawless,
            radiant: radiant,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String relicGid,
            Value<int> intact = const Value.absent(),
            Value<int> exceptional = const Value.absent(),
            Value<int> flawless = const Value.absent(),
            Value<int> radiant = const Value.absent(),
            Value<String?> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RelicCountersCompanion.insert(
            relicGid: relicGid,
            intact: intact,
            exceptional: exceptional,
            flawless: flawless,
            radiant: radiant,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$RelicCountersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $RelicCountersTable,
    RelicCountersData,
    $$RelicCountersTableFilterComposer,
    $$RelicCountersTableOrderingComposer,
    $$RelicCountersTableAnnotationComposer,
    $$RelicCountersTableCreateCompanionBuilder,
    $$RelicCountersTableUpdateCompanionBuilder,
    (
      RelicCountersData,
      BaseReferences<_$AppDatabase, $RelicCountersTable, RelicCountersData>
    ),
    RelicCountersData,
    PrefetchHooks Function()>;
typedef $$SyncMetadataTableCreateCompanionBuilder = SyncMetadataCompanion
    Function({
  required String key,
  Value<String?> value,
  Value<String?> updatedAt,
  Value<int> rowid,
});
typedef $$SyncMetadataTableUpdateCompanionBuilder = SyncMetadataCompanion
    Function({
  Value<String> key,
  Value<String?> value,
  Value<String?> updatedAt,
  Value<int> rowid,
});

class $$SyncMetadataTableFilterComposer
    extends Composer<_$AppDatabase, $SyncMetadataTable> {
  $$SyncMetadataTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$SyncMetadataTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncMetadataTable> {
  $$SyncMetadataTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$SyncMetadataTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncMetadataTable> {
  $$SyncMetadataTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$SyncMetadataTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SyncMetadataTable,
    SyncMetadataData,
    $$SyncMetadataTableFilterComposer,
    $$SyncMetadataTableOrderingComposer,
    $$SyncMetadataTableAnnotationComposer,
    $$SyncMetadataTableCreateCompanionBuilder,
    $$SyncMetadataTableUpdateCompanionBuilder,
    (
      SyncMetadataData,
      BaseReferences<_$AppDatabase, $SyncMetadataTable, SyncMetadataData>
    ),
    SyncMetadataData,
    PrefetchHooks Function()> {
  $$SyncMetadataTableTableManager(_$AppDatabase db, $SyncMetadataTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncMetadataTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncMetadataTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncMetadataTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String?> value = const Value.absent(),
            Value<String?> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SyncMetadataCompanion(
            key: key,
            value: value,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String key,
            Value<String?> value = const Value.absent(),
            Value<String?> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SyncMetadataCompanion.insert(
            key: key,
            value: value,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SyncMetadataTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SyncMetadataTable,
    SyncMetadataData,
    $$SyncMetadataTableFilterComposer,
    $$SyncMetadataTableOrderingComposer,
    $$SyncMetadataTableAnnotationComposer,
    $$SyncMetadataTableCreateCompanionBuilder,
    $$SyncMetadataTableUpdateCompanionBuilder,
    (
      SyncMetadataData,
      BaseReferences<_$AppDatabase, $SyncMetadataTable, SyncMetadataData>
    ),
    SyncMetadataData,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$RelicInfoTableTableManager get relicInfo =>
      $$RelicInfoTableTableManager(_db, _db.relicInfo);
  $$RelicCountersTableTableManager get relicCounters =>
      $$RelicCountersTableTableManager(_db, _db.relicCounters);
  $$SyncMetadataTableTableManager get syncMetadata =>
      $$SyncMetadataTableTableManager(_db, _db.syncMetadata);
}
