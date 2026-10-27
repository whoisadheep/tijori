// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $DailyRatesTable extends DailyRates
    with TableInfo<$DailyRatesTable, DailyRate> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DailyRatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _gold16kMeta = const VerificationMeta(
    'gold16k',
  );
  @override
  late final GeneratedColumn<double> gold16k = GeneratedColumn<double>(
    'gold16k',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _gold18kMeta = const VerificationMeta(
    'gold18k',
  );
  @override
  late final GeneratedColumn<double> gold18k = GeneratedColumn<double>(
    'gold18k',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _gold22kMeta = const VerificationMeta(
    'gold22k',
  );
  @override
  late final GeneratedColumn<double> gold22k = GeneratedColumn<double>(
    'gold22k',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _gold24kMeta = const VerificationMeta(
    'gold24k',
  );
  @override
  late final GeneratedColumn<double> gold24k = GeneratedColumn<double>(
    'gold24k',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _silverRateMeta = const VerificationMeta(
    'silverRate',
  );
  @override
  late final GeneratedColumn<double> silverRate = GeneratedColumn<double>(
    'silver_rate',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    date,
    gold16k,
    gold18k,
    gold22k,
    gold24k,
    silverRate,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'daily_rates';
  @override
  VerificationContext validateIntegrity(
    Insertable<DailyRate> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('gold16k')) {
      context.handle(
        _gold16kMeta,
        gold16k.isAcceptableOrUnknown(data['gold16k']!, _gold16kMeta),
      );
    }
    if (data.containsKey('gold18k')) {
      context.handle(
        _gold18kMeta,
        gold18k.isAcceptableOrUnknown(data['gold18k']!, _gold18kMeta),
      );
    }
    if (data.containsKey('gold22k')) {
      context.handle(
        _gold22kMeta,
        gold22k.isAcceptableOrUnknown(data['gold22k']!, _gold22kMeta),
      );
    }
    if (data.containsKey('gold24k')) {
      context.handle(
        _gold24kMeta,
        gold24k.isAcceptableOrUnknown(data['gold24k']!, _gold24kMeta),
      );
    }
    if (data.containsKey('silver_rate')) {
      context.handle(
        _silverRateMeta,
        silverRate.isAcceptableOrUnknown(data['silver_rate']!, _silverRateMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DailyRate map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DailyRate(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      date:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}date'],
          )!,
      gold16k: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}gold16k'],
      ),
      gold18k: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}gold18k'],
      ),
      gold22k: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}gold22k'],
      ),
      gold24k: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}gold24k'],
      ),
      silverRate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}silver_rate'],
      ),
    );
  }

  @override
  $DailyRatesTable createAlias(String alias) {
    return $DailyRatesTable(attachedDatabase, alias);
  }
}

class DailyRate extends DataClass implements Insertable<DailyRate> {
  final int id;
  final DateTime date;
  final double? gold16k;
  final double? gold18k;
  final double? gold22k;
  final double? gold24k;
  final double? silverRate;
  const DailyRate({
    required this.id,
    required this.date,
    this.gold16k,
    this.gold18k,
    this.gold22k,
    this.gold24k,
    this.silverRate,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<DateTime>(date);
    if (!nullToAbsent || gold16k != null) {
      map['gold16k'] = Variable<double>(gold16k);
    }
    if (!nullToAbsent || gold18k != null) {
      map['gold18k'] = Variable<double>(gold18k);
    }
    if (!nullToAbsent || gold22k != null) {
      map['gold22k'] = Variable<double>(gold22k);
    }
    if (!nullToAbsent || gold24k != null) {
      map['gold24k'] = Variable<double>(gold24k);
    }
    if (!nullToAbsent || silverRate != null) {
      map['silver_rate'] = Variable<double>(silverRate);
    }
    return map;
  }

  DailyRatesCompanion toCompanion(bool nullToAbsent) {
    return DailyRatesCompanion(
      id: Value(id),
      date: Value(date),
      gold16k:
          gold16k == null && nullToAbsent
              ? const Value.absent()
              : Value(gold16k),
      gold18k:
          gold18k == null && nullToAbsent
              ? const Value.absent()
              : Value(gold18k),
      gold22k:
          gold22k == null && nullToAbsent
              ? const Value.absent()
              : Value(gold22k),
      gold24k:
          gold24k == null && nullToAbsent
              ? const Value.absent()
              : Value(gold24k),
      silverRate:
          silverRate == null && nullToAbsent
              ? const Value.absent()
              : Value(silverRate),
    );
  }

  factory DailyRate.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DailyRate(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      gold16k: serializer.fromJson<double?>(json['gold16k']),
      gold18k: serializer.fromJson<double?>(json['gold18k']),
      gold22k: serializer.fromJson<double?>(json['gold22k']),
      gold24k: serializer.fromJson<double?>(json['gold24k']),
      silverRate: serializer.fromJson<double?>(json['silverRate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<DateTime>(date),
      'gold16k': serializer.toJson<double?>(gold16k),
      'gold18k': serializer.toJson<double?>(gold18k),
      'gold22k': serializer.toJson<double?>(gold22k),
      'gold24k': serializer.toJson<double?>(gold24k),
      'silverRate': serializer.toJson<double?>(silverRate),
    };
  }

  DailyRate copyWith({
    int? id,
    DateTime? date,
    Value<double?> gold16k = const Value.absent(),
    Value<double?> gold18k = const Value.absent(),
    Value<double?> gold22k = const Value.absent(),
    Value<double?> gold24k = const Value.absent(),
    Value<double?> silverRate = const Value.absent(),
  }) => DailyRate(
    id: id ?? this.id,
    date: date ?? this.date,
    gold16k: gold16k.present ? gold16k.value : this.gold16k,
    gold18k: gold18k.present ? gold18k.value : this.gold18k,
    gold22k: gold22k.present ? gold22k.value : this.gold22k,
    gold24k: gold24k.present ? gold24k.value : this.gold24k,
    silverRate: silverRate.present ? silverRate.value : this.silverRate,
  );
  DailyRate copyWithCompanion(DailyRatesCompanion data) {
    return DailyRate(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      gold16k: data.gold16k.present ? data.gold16k.value : this.gold16k,
      gold18k: data.gold18k.present ? data.gold18k.value : this.gold18k,
      gold22k: data.gold22k.present ? data.gold22k.value : this.gold22k,
      gold24k: data.gold24k.present ? data.gold24k.value : this.gold24k,
      silverRate:
          data.silverRate.present ? data.silverRate.value : this.silverRate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DailyRate(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('gold16k: $gold16k, ')
          ..write('gold18k: $gold18k, ')
          ..write('gold22k: $gold22k, ')
          ..write('gold24k: $gold24k, ')
          ..write('silverRate: $silverRate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, date, gold16k, gold18k, gold22k, gold24k, silverRate);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DailyRate &&
          other.id == this.id &&
          other.date == this.date &&
          other.gold16k == this.gold16k &&
          other.gold18k == this.gold18k &&
          other.gold22k == this.gold22k &&
          other.gold24k == this.gold24k &&
          other.silverRate == this.silverRate);
}

class DailyRatesCompanion extends UpdateCompanion<DailyRate> {
  final Value<int> id;
  final Value<DateTime> date;
  final Value<double?> gold16k;
  final Value<double?> gold18k;
  final Value<double?> gold22k;
  final Value<double?> gold24k;
  final Value<double?> silverRate;
  const DailyRatesCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.gold16k = const Value.absent(),
    this.gold18k = const Value.absent(),
    this.gold22k = const Value.absent(),
    this.gold24k = const Value.absent(),
    this.silverRate = const Value.absent(),
  });
  DailyRatesCompanion.insert({
    this.id = const Value.absent(),
    required DateTime date,
    this.gold16k = const Value.absent(),
    this.gold18k = const Value.absent(),
    this.gold22k = const Value.absent(),
    this.gold24k = const Value.absent(),
    this.silverRate = const Value.absent(),
  }) : date = Value(date);
  static Insertable<DailyRate> custom({
    Expression<int>? id,
    Expression<DateTime>? date,
    Expression<double>? gold16k,
    Expression<double>? gold18k,
    Expression<double>? gold22k,
    Expression<double>? gold24k,
    Expression<double>? silverRate,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (gold16k != null) 'gold16k': gold16k,
      if (gold18k != null) 'gold18k': gold18k,
      if (gold22k != null) 'gold22k': gold22k,
      if (gold24k != null) 'gold24k': gold24k,
      if (silverRate != null) 'silver_rate': silverRate,
    });
  }

  DailyRatesCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? date,
    Value<double?>? gold16k,
    Value<double?>? gold18k,
    Value<double?>? gold22k,
    Value<double?>? gold24k,
    Value<double?>? silverRate,
  }) {
    return DailyRatesCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      gold16k: gold16k ?? this.gold16k,
      gold18k: gold18k ?? this.gold18k,
      gold22k: gold22k ?? this.gold22k,
      gold24k: gold24k ?? this.gold24k,
      silverRate: silverRate ?? this.silverRate,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (gold16k.present) {
      map['gold16k'] = Variable<double>(gold16k.value);
    }
    if (gold18k.present) {
      map['gold18k'] = Variable<double>(gold18k.value);
    }
    if (gold22k.present) {
      map['gold22k'] = Variable<double>(gold22k.value);
    }
    if (gold24k.present) {
      map['gold24k'] = Variable<double>(gold24k.value);
    }
    if (silverRate.present) {
      map['silver_rate'] = Variable<double>(silverRate.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DailyRatesCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('gold16k: $gold16k, ')
          ..write('gold18k: $gold18k, ')
          ..write('gold22k: $gold22k, ')
          ..write('gold24k: $gold24k, ')
          ..write('silverRate: $silverRate')
          ..write(')'))
        .toString();
  }
}

class $PartiesTable extends Parties with TableInfo<$PartiesTable, Party> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PartiesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(minTextLength: 1),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<PartyGroupType, String>
  groupType = GeneratedColumn<String>(
    'group_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<PartyGroupType>($PartiesTable.$convertergroupType);
  static const VerificationMeta _mobileMeta = const VerificationMeta('mobile');
  @override
  late final GeneratedColumn<String> mobile = GeneratedColumn<String>(
    'mobile',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _stateMeta = const VerificationMeta('state');
  @override
  late final GeneratedColumn<String> state = GeneratedColumn<String>(
    'state',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _kycDocTypeMeta = const VerificationMeta(
    'kycDocType',
  );
  @override
  late final GeneratedColumn<String> kycDocType = GeneratedColumn<String>(
    'kyc_doc_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _kycDocNumberMeta = const VerificationMeta(
    'kycDocNumber',
  );
  @override
  late final GeneratedColumn<String> kycDocNumber = GeneratedColumn<String>(
    'kyc_doc_number',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    groupType,
    mobile,
    state,
    address,
    kycDocType,
    kycDocNumber,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'parties';
  @override
  VerificationContext validateIntegrity(
    Insertable<Party> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('mobile')) {
      context.handle(
        _mobileMeta,
        mobile.isAcceptableOrUnknown(data['mobile']!, _mobileMeta),
      );
    }
    if (data.containsKey('state')) {
      context.handle(
        _stateMeta,
        state.isAcceptableOrUnknown(data['state']!, _stateMeta),
      );
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    }
    if (data.containsKey('kyc_doc_type')) {
      context.handle(
        _kycDocTypeMeta,
        kycDocType.isAcceptableOrUnknown(
          data['kyc_doc_type']!,
          _kycDocTypeMeta,
        ),
      );
    }
    if (data.containsKey('kyc_doc_number')) {
      context.handle(
        _kycDocNumberMeta,
        kycDocNumber.isAcceptableOrUnknown(
          data['kyc_doc_number']!,
          _kycDocNumberMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Party map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Party(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      name:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}name'],
          )!,
      groupType: $PartiesTable.$convertergroupType.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}group_type'],
        )!,
      ),
      mobile: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mobile'],
      ),
      state: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}state'],
      ),
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      ),
      kycDocType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kyc_doc_type'],
      ),
      kycDocNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kyc_doc_number'],
      ),
      createdAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}created_at'],
          )!,
    );
  }

  @override
  $PartiesTable createAlias(String alias) {
    return $PartiesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<PartyGroupType, String, String>
  $convertergroupType = const EnumNameConverter<PartyGroupType>(
    PartyGroupType.values,
  );
}

class Party extends DataClass implements Insertable<Party> {
  final int id;
  final String name;
  final PartyGroupType groupType;
  final String? mobile;
  final String? state;
  final String? address;
  final String? kycDocType;
  final String? kycDocNumber;
  final DateTime createdAt;
  const Party({
    required this.id,
    required this.name,
    required this.groupType,
    this.mobile,
    this.state,
    this.address,
    this.kycDocType,
    this.kycDocNumber,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    {
      map['group_type'] = Variable<String>(
        $PartiesTable.$convertergroupType.toSql(groupType),
      );
    }
    if (!nullToAbsent || mobile != null) {
      map['mobile'] = Variable<String>(mobile);
    }
    if (!nullToAbsent || state != null) {
      map['state'] = Variable<String>(state);
    }
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    if (!nullToAbsent || kycDocType != null) {
      map['kyc_doc_type'] = Variable<String>(kycDocType);
    }
    if (!nullToAbsent || kycDocNumber != null) {
      map['kyc_doc_number'] = Variable<String>(kycDocNumber);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  PartiesCompanion toCompanion(bool nullToAbsent) {
    return PartiesCompanion(
      id: Value(id),
      name: Value(name),
      groupType: Value(groupType),
      mobile:
          mobile == null && nullToAbsent ? const Value.absent() : Value(mobile),
      state:
          state == null && nullToAbsent ? const Value.absent() : Value(state),
      address:
          address == null && nullToAbsent
              ? const Value.absent()
              : Value(address),
      kycDocType:
          kycDocType == null && nullToAbsent
              ? const Value.absent()
              : Value(kycDocType),
      kycDocNumber:
          kycDocNumber == null && nullToAbsent
              ? const Value.absent()
              : Value(kycDocNumber),
      createdAt: Value(createdAt),
    );
  }

  factory Party.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Party(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      groupType: $PartiesTable.$convertergroupType.fromJson(
        serializer.fromJson<String>(json['groupType']),
      ),
      mobile: serializer.fromJson<String?>(json['mobile']),
      state: serializer.fromJson<String?>(json['state']),
      address: serializer.fromJson<String?>(json['address']),
      kycDocType: serializer.fromJson<String?>(json['kycDocType']),
      kycDocNumber: serializer.fromJson<String?>(json['kycDocNumber']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'groupType': serializer.toJson<String>(
        $PartiesTable.$convertergroupType.toJson(groupType),
      ),
      'mobile': serializer.toJson<String?>(mobile),
      'state': serializer.toJson<String?>(state),
      'address': serializer.toJson<String?>(address),
      'kycDocType': serializer.toJson<String?>(kycDocType),
      'kycDocNumber': serializer.toJson<String?>(kycDocNumber),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Party copyWith({
    int? id,
    String? name,
    PartyGroupType? groupType,
    Value<String?> mobile = const Value.absent(),
    Value<String?> state = const Value.absent(),
    Value<String?> address = const Value.absent(),
    Value<String?> kycDocType = const Value.absent(),
    Value<String?> kycDocNumber = const Value.absent(),
    DateTime? createdAt,
  }) => Party(
    id: id ?? this.id,
    name: name ?? this.name,
    groupType: groupType ?? this.groupType,
    mobile: mobile.present ? mobile.value : this.mobile,
    state: state.present ? state.value : this.state,
    address: address.present ? address.value : this.address,
    kycDocType: kycDocType.present ? kycDocType.value : this.kycDocType,
    kycDocNumber: kycDocNumber.present ? kycDocNumber.value : this.kycDocNumber,
    createdAt: createdAt ?? this.createdAt,
  );
  Party copyWithCompanion(PartiesCompanion data) {
    return Party(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      groupType: data.groupType.present ? data.groupType.value : this.groupType,
      mobile: data.mobile.present ? data.mobile.value : this.mobile,
      state: data.state.present ? data.state.value : this.state,
      address: data.address.present ? data.address.value : this.address,
      kycDocType:
          data.kycDocType.present ? data.kycDocType.value : this.kycDocType,
      kycDocNumber:
          data.kycDocNumber.present
              ? data.kycDocNumber.value
              : this.kycDocNumber,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Party(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('groupType: $groupType, ')
          ..write('mobile: $mobile, ')
          ..write('state: $state, ')
          ..write('address: $address, ')
          ..write('kycDocType: $kycDocType, ')
          ..write('kycDocNumber: $kycDocNumber, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    groupType,
    mobile,
    state,
    address,
    kycDocType,
    kycDocNumber,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Party &&
          other.id == this.id &&
          other.name == this.name &&
          other.groupType == this.groupType &&
          other.mobile == this.mobile &&
          other.state == this.state &&
          other.address == this.address &&
          other.kycDocType == this.kycDocType &&
          other.kycDocNumber == this.kycDocNumber &&
          other.createdAt == this.createdAt);
}

class PartiesCompanion extends UpdateCompanion<Party> {
  final Value<int> id;
  final Value<String> name;
  final Value<PartyGroupType> groupType;
  final Value<String?> mobile;
  final Value<String?> state;
  final Value<String?> address;
  final Value<String?> kycDocType;
  final Value<String?> kycDocNumber;
  final Value<DateTime> createdAt;
  const PartiesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.groupType = const Value.absent(),
    this.mobile = const Value.absent(),
    this.state = const Value.absent(),
    this.address = const Value.absent(),
    this.kycDocType = const Value.absent(),
    this.kycDocNumber = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  PartiesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required PartyGroupType groupType,
    this.mobile = const Value.absent(),
    this.state = const Value.absent(),
    this.address = const Value.absent(),
    this.kycDocType = const Value.absent(),
    this.kycDocNumber = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : name = Value(name),
       groupType = Value(groupType);
  static Insertable<Party> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? groupType,
    Expression<String>? mobile,
    Expression<String>? state,
    Expression<String>? address,
    Expression<String>? kycDocType,
    Expression<String>? kycDocNumber,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (groupType != null) 'group_type': groupType,
      if (mobile != null) 'mobile': mobile,
      if (state != null) 'state': state,
      if (address != null) 'address': address,
      if (kycDocType != null) 'kyc_doc_type': kycDocType,
      if (kycDocNumber != null) 'kyc_doc_number': kycDocNumber,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  PartiesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<PartyGroupType>? groupType,
    Value<String?>? mobile,
    Value<String?>? state,
    Value<String?>? address,
    Value<String?>? kycDocType,
    Value<String?>? kycDocNumber,
    Value<DateTime>? createdAt,
  }) {
    return PartiesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      groupType: groupType ?? this.groupType,
      mobile: mobile ?? this.mobile,
      state: state ?? this.state,
      address: address ?? this.address,
      kycDocType: kycDocType ?? this.kycDocType,
      kycDocNumber: kycDocNumber ?? this.kycDocNumber,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (groupType.present) {
      map['group_type'] = Variable<String>(
        $PartiesTable.$convertergroupType.toSql(groupType.value),
      );
    }
    if (mobile.present) {
      map['mobile'] = Variable<String>(mobile.value);
    }
    if (state.present) {
      map['state'] = Variable<String>(state.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (kycDocType.present) {
      map['kyc_doc_type'] = Variable<String>(kycDocType.value);
    }
    if (kycDocNumber.present) {
      map['kyc_doc_number'] = Variable<String>(kycDocNumber.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PartiesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('groupType: $groupType, ')
          ..write('mobile: $mobile, ')
          ..write('state: $state, ')
          ..write('address: $address, ')
          ..write('kycDocType: $kycDocType, ')
          ..write('kycDocNumber: $kycDocNumber, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $GirviLoansTable extends GirviLoans
    with TableInfo<$GirviLoansTable, GirviLoan> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GirviLoansTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _slipNumberMeta = const VerificationMeta(
    'slipNumber',
  );
  @override
  late final GeneratedColumn<String> slipNumber = GeneratedColumn<String>(
    'slip_number',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _partyIdMeta = const VerificationMeta(
    'partyId',
  );
  @override
  late final GeneratedColumn<int> partyId = GeneratedColumn<int>(
    'party_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES parties (id)',
    ),
  );
  static const VerificationMeta _transactionDateMeta = const VerificationMeta(
    'transactionDate',
  );
  @override
  late final GeneratedColumn<DateTime> transactionDate =
      GeneratedColumn<DateTime>(
        'transaction_date',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _interestStartDateMeta = const VerificationMeta(
    'interestStartDate',
  );
  @override
  late final GeneratedColumn<DateTime> interestStartDate =
      GeneratedColumn<DateTime>(
        'interest_start_date',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _roiMeta = const VerificationMeta('roi');
  @override
  late final GeneratedColumn<double> roi = GeneratedColumn<double>(
    'roi',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<InterestType, String>
  interestType = GeneratedColumn<String>(
    'interest_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<InterestType>($GirviLoansTable.$converterinterestType);
  @override
  late final GeneratedColumnWithTypeConverter<MetalType, String> metalType =
      GeneratedColumn<String>(
        'metal_type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<MetalType>($GirviLoansTable.$convertermetalType);
  static const VerificationMeta _grossWeightMeta = const VerificationMeta(
    'grossWeight',
  );
  @override
  late final GeneratedColumn<double> grossWeight = GeneratedColumn<double>(
    'gross_weight',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _purityPercentMeta = const VerificationMeta(
    'purityPercent',
  );
  @override
  late final GeneratedColumn<double> purityPercent = GeneratedColumn<double>(
    'purity_percent',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _netWeightMeta = const VerificationMeta(
    'netWeight',
  );
  @override
  late final GeneratedColumn<double> netWeight = GeneratedColumn<double>(
    'net_weight',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _estimatedValueMeta = const VerificationMeta(
    'estimatedValue',
  );
  @override
  late final GeneratedColumn<double> estimatedValue = GeneratedColumn<double>(
    'estimated_value',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _principalAmountMeta = const VerificationMeta(
    'principalAmount',
  );
  @override
  late final GeneratedColumn<double> principalAmount = GeneratedColumn<double>(
    'principal_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<PaymentMode, String> paymentMode =
      GeneratedColumn<String>(
        'payment_mode',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<PaymentMode>($GirviLoansTable.$converterpaymentMode);
  static const VerificationMeta _itemDescriptionMeta = const VerificationMeta(
    'itemDescription',
  );
  @override
  late final GeneratedColumn<String> itemDescription = GeneratedColumn<String>(
    'item_description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _localPhotoPathMeta = const VerificationMeta(
    'localPhotoPath',
  );
  @override
  late final GeneratedColumn<String> localPhotoPath = GeneratedColumn<String>(
    'local_photo_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _guarantorNameMeta = const VerificationMeta(
    'guarantorName',
  );
  @override
  late final GeneratedColumn<String> guarantorName = GeneratedColumn<String>(
    'guarantor_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _guarantorPhoneMeta = const VerificationMeta(
    'guarantorPhone',
  );
  @override
  late final GeneratedColumn<String> guarantorPhone = GeneratedColumn<String>(
    'guarantor_phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _guarantorAddressMeta = const VerificationMeta(
    'guarantorAddress',
  );
  @override
  late final GeneratedColumn<String> guarantorAddress = GeneratedColumn<String>(
    'guarantor_address',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _rackLocationMeta = const VerificationMeta(
    'rackLocation',
  );
  @override
  late final GeneratedColumn<String> rackLocation = GeneratedColumn<String>(
    'rack_location',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _remarksMeta = const VerificationMeta(
    'remarks',
  );
  @override
  late final GeneratedColumn<String> remarks = GeneratedColumn<String>(
    'remarks',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<LoanStatus, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: Constant(LoanStatus.active.name),
      ).withConverter<LoanStatus>($GirviLoansTable.$converterstatus);
  @override
  List<GeneratedColumn> get $columns => [
    id,
    slipNumber,
    partyId,
    transactionDate,
    interestStartDate,
    roi,
    interestType,
    metalType,
    grossWeight,
    purityPercent,
    netWeight,
    estimatedValue,
    principalAmount,
    paymentMode,
    itemDescription,
    localPhotoPath,
    guarantorName,
    guarantorPhone,
    guarantorAddress,
    rackLocation,
    remarks,
    status,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'girvi_loans';
  @override
  VerificationContext validateIntegrity(
    Insertable<GirviLoan> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('slip_number')) {
      context.handle(
        _slipNumberMeta,
        slipNumber.isAcceptableOrUnknown(data['slip_number']!, _slipNumberMeta),
      );
    } else if (isInserting) {
      context.missing(_slipNumberMeta);
    }
    if (data.containsKey('party_id')) {
      context.handle(
        _partyIdMeta,
        partyId.isAcceptableOrUnknown(data['party_id']!, _partyIdMeta),
      );
    } else if (isInserting) {
      context.missing(_partyIdMeta);
    }
    if (data.containsKey('transaction_date')) {
      context.handle(
        _transactionDateMeta,
        transactionDate.isAcceptableOrUnknown(
          data['transaction_date']!,
          _transactionDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_transactionDateMeta);
    }
    if (data.containsKey('interest_start_date')) {
      context.handle(
        _interestStartDateMeta,
        interestStartDate.isAcceptableOrUnknown(
          data['interest_start_date']!,
          _interestStartDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_interestStartDateMeta);
    }
    if (data.containsKey('roi')) {
      context.handle(
        _roiMeta,
        roi.isAcceptableOrUnknown(data['roi']!, _roiMeta),
      );
    } else if (isInserting) {
      context.missing(_roiMeta);
    }
    if (data.containsKey('gross_weight')) {
      context.handle(
        _grossWeightMeta,
        grossWeight.isAcceptableOrUnknown(
          data['gross_weight']!,
          _grossWeightMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_grossWeightMeta);
    }
    if (data.containsKey('purity_percent')) {
      context.handle(
        _purityPercentMeta,
        purityPercent.isAcceptableOrUnknown(
          data['purity_percent']!,
          _purityPercentMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_purityPercentMeta);
    }
    if (data.containsKey('net_weight')) {
      context.handle(
        _netWeightMeta,
        netWeight.isAcceptableOrUnknown(data['net_weight']!, _netWeightMeta),
      );
    } else if (isInserting) {
      context.missing(_netWeightMeta);
    }
    if (data.containsKey('estimated_value')) {
      context.handle(
        _estimatedValueMeta,
        estimatedValue.isAcceptableOrUnknown(
          data['estimated_value']!,
          _estimatedValueMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_estimatedValueMeta);
    }
    if (data.containsKey('principal_amount')) {
      context.handle(
        _principalAmountMeta,
        principalAmount.isAcceptableOrUnknown(
          data['principal_amount']!,
          _principalAmountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_principalAmountMeta);
    }
    if (data.containsKey('item_description')) {
      context.handle(
        _itemDescriptionMeta,
        itemDescription.isAcceptableOrUnknown(
          data['item_description']!,
          _itemDescriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_itemDescriptionMeta);
    }
    if (data.containsKey('local_photo_path')) {
      context.handle(
        _localPhotoPathMeta,
        localPhotoPath.isAcceptableOrUnknown(
          data['local_photo_path']!,
          _localPhotoPathMeta,
        ),
      );
    }
    if (data.containsKey('guarantor_name')) {
      context.handle(
        _guarantorNameMeta,
        guarantorName.isAcceptableOrUnknown(
          data['guarantor_name']!,
          _guarantorNameMeta,
        ),
      );
    }
    if (data.containsKey('guarantor_phone')) {
      context.handle(
        _guarantorPhoneMeta,
        guarantorPhone.isAcceptableOrUnknown(
          data['guarantor_phone']!,
          _guarantorPhoneMeta,
        ),
      );
    }
    if (data.containsKey('guarantor_address')) {
      context.handle(
        _guarantorAddressMeta,
        guarantorAddress.isAcceptableOrUnknown(
          data['guarantor_address']!,
          _guarantorAddressMeta,
        ),
      );
    }
    if (data.containsKey('rack_location')) {
      context.handle(
        _rackLocationMeta,
        rackLocation.isAcceptableOrUnknown(
          data['rack_location']!,
          _rackLocationMeta,
        ),
      );
    }
    if (data.containsKey('remarks')) {
      context.handle(
        _remarksMeta,
        remarks.isAcceptableOrUnknown(data['remarks']!, _remarksMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GirviLoan map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GirviLoan(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      slipNumber:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}slip_number'],
          )!,
      partyId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}party_id'],
          )!,
      transactionDate:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}transaction_date'],
          )!,
      interestStartDate:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}interest_start_date'],
          )!,
      roi:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}roi'],
          )!,
      interestType: $GirviLoansTable.$converterinterestType.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}interest_type'],
        )!,
      ),
      metalType: $GirviLoansTable.$convertermetalType.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}metal_type'],
        )!,
      ),
      grossWeight:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}gross_weight'],
          )!,
      purityPercent:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}purity_percent'],
          )!,
      netWeight:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}net_weight'],
          )!,
      estimatedValue:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}estimated_value'],
          )!,
      principalAmount:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}principal_amount'],
          )!,
      paymentMode: $GirviLoansTable.$converterpaymentMode.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}payment_mode'],
        )!,
      ),
      itemDescription:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}item_description'],
          )!,
      localPhotoPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_photo_path'],
      ),
      guarantorName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}guarantor_name'],
      ),
      guarantorPhone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}guarantor_phone'],
      ),
      guarantorAddress: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}guarantor_address'],
      ),
      rackLocation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rack_location'],
      ),
      remarks: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}remarks'],
      ),
      status: $GirviLoansTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
    );
  }

  @override
  $GirviLoansTable createAlias(String alias) {
    return $GirviLoansTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<InterestType, String, String>
  $converterinterestType = const EnumNameConverter<InterestType>(
    InterestType.values,
  );
  static JsonTypeConverter2<MetalType, String, String> $convertermetalType =
      const EnumNameConverter<MetalType>(MetalType.values);
  static JsonTypeConverter2<PaymentMode, String, String> $converterpaymentMode =
      const EnumNameConverter<PaymentMode>(PaymentMode.values);
  static JsonTypeConverter2<LoanStatus, String, String> $converterstatus =
      const EnumNameConverter<LoanStatus>(LoanStatus.values);
}

class GirviLoan extends DataClass implements Insertable<GirviLoan> {
  final int id;
  final String slipNumber;
  final int partyId;
  final DateTime transactionDate;
  final DateTime interestStartDate;
  final double roi;
  final InterestType interestType;
  final MetalType metalType;
  final double grossWeight;
  final double purityPercent;
  final double netWeight;
  final double estimatedValue;
  final double principalAmount;
  final PaymentMode paymentMode;
  final String itemDescription;
  final String? localPhotoPath;
  final String? guarantorName;
  final String? guarantorPhone;
  final String? guarantorAddress;
  final String? rackLocation;
  final String? remarks;
  final LoanStatus status;
  const GirviLoan({
    required this.id,
    required this.slipNumber,
    required this.partyId,
    required this.transactionDate,
    required this.interestStartDate,
    required this.roi,
    required this.interestType,
    required this.metalType,
    required this.grossWeight,
    required this.purityPercent,
    required this.netWeight,
    required this.estimatedValue,
    required this.principalAmount,
    required this.paymentMode,
    required this.itemDescription,
    this.localPhotoPath,
    this.guarantorName,
    this.guarantorPhone,
    this.guarantorAddress,
    this.rackLocation,
    this.remarks,
    required this.status,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['slip_number'] = Variable<String>(slipNumber);
    map['party_id'] = Variable<int>(partyId);
    map['transaction_date'] = Variable<DateTime>(transactionDate);
    map['interest_start_date'] = Variable<DateTime>(interestStartDate);
    map['roi'] = Variable<double>(roi);
    {
      map['interest_type'] = Variable<String>(
        $GirviLoansTable.$converterinterestType.toSql(interestType),
      );
    }
    {
      map['metal_type'] = Variable<String>(
        $GirviLoansTable.$convertermetalType.toSql(metalType),
      );
    }
    map['gross_weight'] = Variable<double>(grossWeight);
    map['purity_percent'] = Variable<double>(purityPercent);
    map['net_weight'] = Variable<double>(netWeight);
    map['estimated_value'] = Variable<double>(estimatedValue);
    map['principal_amount'] = Variable<double>(principalAmount);
    {
      map['payment_mode'] = Variable<String>(
        $GirviLoansTable.$converterpaymentMode.toSql(paymentMode),
      );
    }
    map['item_description'] = Variable<String>(itemDescription);
    if (!nullToAbsent || localPhotoPath != null) {
      map['local_photo_path'] = Variable<String>(localPhotoPath);
    }
    if (!nullToAbsent || guarantorName != null) {
      map['guarantor_name'] = Variable<String>(guarantorName);
    }
    if (!nullToAbsent || guarantorPhone != null) {
      map['guarantor_phone'] = Variable<String>(guarantorPhone);
    }
    if (!nullToAbsent || guarantorAddress != null) {
      map['guarantor_address'] = Variable<String>(guarantorAddress);
    }
    if (!nullToAbsent || rackLocation != null) {
      map['rack_location'] = Variable<String>(rackLocation);
    }
    if (!nullToAbsent || remarks != null) {
      map['remarks'] = Variable<String>(remarks);
    }
    {
      map['status'] = Variable<String>(
        $GirviLoansTable.$converterstatus.toSql(status),
      );
    }
    return map;
  }

  GirviLoansCompanion toCompanion(bool nullToAbsent) {
    return GirviLoansCompanion(
      id: Value(id),
      slipNumber: Value(slipNumber),
      partyId: Value(partyId),
      transactionDate: Value(transactionDate),
      interestStartDate: Value(interestStartDate),
      roi: Value(roi),
      interestType: Value(interestType),
      metalType: Value(metalType),
      grossWeight: Value(grossWeight),
      purityPercent: Value(purityPercent),
      netWeight: Value(netWeight),
      estimatedValue: Value(estimatedValue),
      principalAmount: Value(principalAmount),
      paymentMode: Value(paymentMode),
      itemDescription: Value(itemDescription),
      localPhotoPath:
          localPhotoPath == null && nullToAbsent
              ? const Value.absent()
              : Value(localPhotoPath),
      guarantorName:
          guarantorName == null && nullToAbsent
              ? const Value.absent()
              : Value(guarantorName),
      guarantorPhone:
          guarantorPhone == null && nullToAbsent
              ? const Value.absent()
              : Value(guarantorPhone),
      guarantorAddress:
          guarantorAddress == null && nullToAbsent
              ? const Value.absent()
              : Value(guarantorAddress),
      rackLocation:
          rackLocation == null && nullToAbsent
              ? const Value.absent()
              : Value(rackLocation),
      remarks:
          remarks == null && nullToAbsent
              ? const Value.absent()
              : Value(remarks),
      status: Value(status),
    );
  }

  factory GirviLoan.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GirviLoan(
      id: serializer.fromJson<int>(json['id']),
      slipNumber: serializer.fromJson<String>(json['slipNumber']),
      partyId: serializer.fromJson<int>(json['partyId']),
      transactionDate: serializer.fromJson<DateTime>(json['transactionDate']),
      interestStartDate: serializer.fromJson<DateTime>(
        json['interestStartDate'],
      ),
      roi: serializer.fromJson<double>(json['roi']),
      interestType: $GirviLoansTable.$converterinterestType.fromJson(
        serializer.fromJson<String>(json['interestType']),
      ),
      metalType: $GirviLoansTable.$convertermetalType.fromJson(
        serializer.fromJson<String>(json['metalType']),
      ),
      grossWeight: serializer.fromJson<double>(json['grossWeight']),
      purityPercent: serializer.fromJson<double>(json['purityPercent']),
      netWeight: serializer.fromJson<double>(json['netWeight']),
      estimatedValue: serializer.fromJson<double>(json['estimatedValue']),
      principalAmount: serializer.fromJson<double>(json['principalAmount']),
      paymentMode: $GirviLoansTable.$converterpaymentMode.fromJson(
        serializer.fromJson<String>(json['paymentMode']),
      ),
      itemDescription: serializer.fromJson<String>(json['itemDescription']),
      localPhotoPath: serializer.fromJson<String?>(json['localPhotoPath']),
      guarantorName: serializer.fromJson<String?>(json['guarantorName']),
      guarantorPhone: serializer.fromJson<String?>(json['guarantorPhone']),
      guarantorAddress: serializer.fromJson<String?>(json['guarantorAddress']),
      rackLocation: serializer.fromJson<String?>(json['rackLocation']),
      remarks: serializer.fromJson<String?>(json['remarks']),
      status: $GirviLoansTable.$converterstatus.fromJson(
        serializer.fromJson<String>(json['status']),
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'slipNumber': serializer.toJson<String>(slipNumber),
      'partyId': serializer.toJson<int>(partyId),
      'transactionDate': serializer.toJson<DateTime>(transactionDate),
      'interestStartDate': serializer.toJson<DateTime>(interestStartDate),
      'roi': serializer.toJson<double>(roi),
      'interestType': serializer.toJson<String>(
        $GirviLoansTable.$converterinterestType.toJson(interestType),
      ),
      'metalType': serializer.toJson<String>(
        $GirviLoansTable.$convertermetalType.toJson(metalType),
      ),
      'grossWeight': serializer.toJson<double>(grossWeight),
      'purityPercent': serializer.toJson<double>(purityPercent),
      'netWeight': serializer.toJson<double>(netWeight),
      'estimatedValue': serializer.toJson<double>(estimatedValue),
      'principalAmount': serializer.toJson<double>(principalAmount),
      'paymentMode': serializer.toJson<String>(
        $GirviLoansTable.$converterpaymentMode.toJson(paymentMode),
      ),
      'itemDescription': serializer.toJson<String>(itemDescription),
      'localPhotoPath': serializer.toJson<String?>(localPhotoPath),
      'guarantorName': serializer.toJson<String?>(guarantorName),
      'guarantorPhone': serializer.toJson<String?>(guarantorPhone),
      'guarantorAddress': serializer.toJson<String?>(guarantorAddress),
      'rackLocation': serializer.toJson<String?>(rackLocation),
      'remarks': serializer.toJson<String?>(remarks),
      'status': serializer.toJson<String>(
        $GirviLoansTable.$converterstatus.toJson(status),
      ),
    };
  }

  GirviLoan copyWith({
    int? id,
    String? slipNumber,
    int? partyId,
    DateTime? transactionDate,
    DateTime? interestStartDate,
    double? roi,
    InterestType? interestType,
    MetalType? metalType,
    double? grossWeight,
    double? purityPercent,
    double? netWeight,
    double? estimatedValue,
    double? principalAmount,
    PaymentMode? paymentMode,
    String? itemDescription,
    Value<String?> localPhotoPath = const Value.absent(),
    Value<String?> guarantorName = const Value.absent(),
    Value<String?> guarantorPhone = const Value.absent(),
    Value<String?> guarantorAddress = const Value.absent(),
    Value<String?> rackLocation = const Value.absent(),
    Value<String?> remarks = const Value.absent(),
    LoanStatus? status,
  }) => GirviLoan(
    id: id ?? this.id,
    slipNumber: slipNumber ?? this.slipNumber,
    partyId: partyId ?? this.partyId,
    transactionDate: transactionDate ?? this.transactionDate,
    interestStartDate: interestStartDate ?? this.interestStartDate,
    roi: roi ?? this.roi,
    interestType: interestType ?? this.interestType,
    metalType: metalType ?? this.metalType,
    grossWeight: grossWeight ?? this.grossWeight,
    purityPercent: purityPercent ?? this.purityPercent,
    netWeight: netWeight ?? this.netWeight,
    estimatedValue: estimatedValue ?? this.estimatedValue,
    principalAmount: principalAmount ?? this.principalAmount,
    paymentMode: paymentMode ?? this.paymentMode,
    itemDescription: itemDescription ?? this.itemDescription,
    localPhotoPath:
        localPhotoPath.present ? localPhotoPath.value : this.localPhotoPath,
    guarantorName:
        guarantorName.present ? guarantorName.value : this.guarantorName,
    guarantorPhone:
        guarantorPhone.present ? guarantorPhone.value : this.guarantorPhone,
    guarantorAddress:
        guarantorAddress.present
            ? guarantorAddress.value
            : this.guarantorAddress,
    rackLocation: rackLocation.present ? rackLocation.value : this.rackLocation,
    remarks: remarks.present ? remarks.value : this.remarks,
    status: status ?? this.status,
  );
  GirviLoan copyWithCompanion(GirviLoansCompanion data) {
    return GirviLoan(
      id: data.id.present ? data.id.value : this.id,
      slipNumber:
          data.slipNumber.present ? data.slipNumber.value : this.slipNumber,
      partyId: data.partyId.present ? data.partyId.value : this.partyId,
      transactionDate:
          data.transactionDate.present
              ? data.transactionDate.value
              : this.transactionDate,
      interestStartDate:
          data.interestStartDate.present
              ? data.interestStartDate.value
              : this.interestStartDate,
      roi: data.roi.present ? data.roi.value : this.roi,
      interestType:
          data.interestType.present
              ? data.interestType.value
              : this.interestType,
      metalType: data.metalType.present ? data.metalType.value : this.metalType,
      grossWeight:
          data.grossWeight.present ? data.grossWeight.value : this.grossWeight,
      purityPercent:
          data.purityPercent.present
              ? data.purityPercent.value
              : this.purityPercent,
      netWeight: data.netWeight.present ? data.netWeight.value : this.netWeight,
      estimatedValue:
          data.estimatedValue.present
              ? data.estimatedValue.value
              : this.estimatedValue,
      principalAmount:
          data.principalAmount.present
              ? data.principalAmount.value
              : this.principalAmount,
      paymentMode:
          data.paymentMode.present ? data.paymentMode.value : this.paymentMode,
      itemDescription:
          data.itemDescription.present
              ? data.itemDescription.value
              : this.itemDescription,
      localPhotoPath:
          data.localPhotoPath.present
              ? data.localPhotoPath.value
              : this.localPhotoPath,
      guarantorName:
          data.guarantorName.present
              ? data.guarantorName.value
              : this.guarantorName,
      guarantorPhone:
          data.guarantorPhone.present
              ? data.guarantorPhone.value
              : this.guarantorPhone,
      guarantorAddress:
          data.guarantorAddress.present
              ? data.guarantorAddress.value
              : this.guarantorAddress,
      rackLocation:
          data.rackLocation.present
              ? data.rackLocation.value
              : this.rackLocation,
      remarks: data.remarks.present ? data.remarks.value : this.remarks,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GirviLoan(')
          ..write('id: $id, ')
          ..write('slipNumber: $slipNumber, ')
          ..write('partyId: $partyId, ')
          ..write('transactionDate: $transactionDate, ')
          ..write('interestStartDate: $interestStartDate, ')
          ..write('roi: $roi, ')
          ..write('interestType: $interestType, ')
          ..write('metalType: $metalType, ')
          ..write('grossWeight: $grossWeight, ')
          ..write('purityPercent: $purityPercent, ')
          ..write('netWeight: $netWeight, ')
          ..write('estimatedValue: $estimatedValue, ')
          ..write('principalAmount: $principalAmount, ')
          ..write('paymentMode: $paymentMode, ')
          ..write('itemDescription: $itemDescription, ')
          ..write('localPhotoPath: $localPhotoPath, ')
          ..write('guarantorName: $guarantorName, ')
          ..write('guarantorPhone: $guarantorPhone, ')
          ..write('guarantorAddress: $guarantorAddress, ')
          ..write('rackLocation: $rackLocation, ')
          ..write('remarks: $remarks, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    slipNumber,
    partyId,
    transactionDate,
    interestStartDate,
    roi,
    interestType,
    metalType,
    grossWeight,
    purityPercent,
    netWeight,
    estimatedValue,
    principalAmount,
    paymentMode,
    itemDescription,
    localPhotoPath,
    guarantorName,
    guarantorPhone,
    guarantorAddress,
    rackLocation,
    remarks,
    status,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GirviLoan &&
          other.id == this.id &&
          other.slipNumber == this.slipNumber &&
          other.partyId == this.partyId &&
          other.transactionDate == this.transactionDate &&
          other.interestStartDate == this.interestStartDate &&
          other.roi == this.roi &&
          other.interestType == this.interestType &&
          other.metalType == this.metalType &&
          other.grossWeight == this.grossWeight &&
          other.purityPercent == this.purityPercent &&
          other.netWeight == this.netWeight &&
          other.estimatedValue == this.estimatedValue &&
          other.principalAmount == this.principalAmount &&
          other.paymentMode == this.paymentMode &&
          other.itemDescription == this.itemDescription &&
          other.localPhotoPath == this.localPhotoPath &&
          other.guarantorName == this.guarantorName &&
          other.guarantorPhone == this.guarantorPhone &&
          other.guarantorAddress == this.guarantorAddress &&
          other.rackLocation == this.rackLocation &&
          other.remarks == this.remarks &&
          other.status == this.status);
}

class GirviLoansCompanion extends UpdateCompanion<GirviLoan> {
  final Value<int> id;
  final Value<String> slipNumber;
  final Value<int> partyId;
  final Value<DateTime> transactionDate;
  final Value<DateTime> interestStartDate;
  final Value<double> roi;
  final Value<InterestType> interestType;
  final Value<MetalType> metalType;
  final Value<double> grossWeight;
  final Value<double> purityPercent;
  final Value<double> netWeight;
  final Value<double> estimatedValue;
  final Value<double> principalAmount;
  final Value<PaymentMode> paymentMode;
  final Value<String> itemDescription;
  final Value<String?> localPhotoPath;
  final Value<String?> guarantorName;
  final Value<String?> guarantorPhone;
  final Value<String?> guarantorAddress;
  final Value<String?> rackLocation;
  final Value<String?> remarks;
  final Value<LoanStatus> status;
  const GirviLoansCompanion({
    this.id = const Value.absent(),
    this.slipNumber = const Value.absent(),
    this.partyId = const Value.absent(),
    this.transactionDate = const Value.absent(),
    this.interestStartDate = const Value.absent(),
    this.roi = const Value.absent(),
    this.interestType = const Value.absent(),
    this.metalType = const Value.absent(),
    this.grossWeight = const Value.absent(),
    this.purityPercent = const Value.absent(),
    this.netWeight = const Value.absent(),
    this.estimatedValue = const Value.absent(),
    this.principalAmount = const Value.absent(),
    this.paymentMode = const Value.absent(),
    this.itemDescription = const Value.absent(),
    this.localPhotoPath = const Value.absent(),
    this.guarantorName = const Value.absent(),
    this.guarantorPhone = const Value.absent(),
    this.guarantorAddress = const Value.absent(),
    this.rackLocation = const Value.absent(),
    this.remarks = const Value.absent(),
    this.status = const Value.absent(),
  });
  GirviLoansCompanion.insert({
    this.id = const Value.absent(),
    required String slipNumber,
    required int partyId,
    required DateTime transactionDate,
    required DateTime interestStartDate,
    required double roi,
    required InterestType interestType,
    required MetalType metalType,
    required double grossWeight,
    required double purityPercent,
    required double netWeight,
    required double estimatedValue,
    required double principalAmount,
    required PaymentMode paymentMode,
    required String itemDescription,
    this.localPhotoPath = const Value.absent(),
    this.guarantorName = const Value.absent(),
    this.guarantorPhone = const Value.absent(),
    this.guarantorAddress = const Value.absent(),
    this.rackLocation = const Value.absent(),
    this.remarks = const Value.absent(),
    this.status = const Value.absent(),
  }) : slipNumber = Value(slipNumber),
       partyId = Value(partyId),
       transactionDate = Value(transactionDate),
       interestStartDate = Value(interestStartDate),
       roi = Value(roi),
       interestType = Value(interestType),
       metalType = Value(metalType),
       grossWeight = Value(grossWeight),
       purityPercent = Value(purityPercent),
       netWeight = Value(netWeight),
       estimatedValue = Value(estimatedValue),
       principalAmount = Value(principalAmount),
       paymentMode = Value(paymentMode),
       itemDescription = Value(itemDescription);
  static Insertable<GirviLoan> custom({
    Expression<int>? id,
    Expression<String>? slipNumber,
    Expression<int>? partyId,
    Expression<DateTime>? transactionDate,
    Expression<DateTime>? interestStartDate,
    Expression<double>? roi,
    Expression<String>? interestType,
    Expression<String>? metalType,
    Expression<double>? grossWeight,
    Expression<double>? purityPercent,
    Expression<double>? netWeight,
    Expression<double>? estimatedValue,
    Expression<double>? principalAmount,
    Expression<String>? paymentMode,
    Expression<String>? itemDescription,
    Expression<String>? localPhotoPath,
    Expression<String>? guarantorName,
    Expression<String>? guarantorPhone,
    Expression<String>? guarantorAddress,
    Expression<String>? rackLocation,
    Expression<String>? remarks,
    Expression<String>? status,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (slipNumber != null) 'slip_number': slipNumber,
      if (partyId != null) 'party_id': partyId,
      if (transactionDate != null) 'transaction_date': transactionDate,
      if (interestStartDate != null) 'interest_start_date': interestStartDate,
      if (roi != null) 'roi': roi,
      if (interestType != null) 'interest_type': interestType,
      if (metalType != null) 'metal_type': metalType,
      if (grossWeight != null) 'gross_weight': grossWeight,
      if (purityPercent != null) 'purity_percent': purityPercent,
      if (netWeight != null) 'net_weight': netWeight,
      if (estimatedValue != null) 'estimated_value': estimatedValue,
      if (principalAmount != null) 'principal_amount': principalAmount,
      if (paymentMode != null) 'payment_mode': paymentMode,
      if (itemDescription != null) 'item_description': itemDescription,
      if (localPhotoPath != null) 'local_photo_path': localPhotoPath,
      if (guarantorName != null) 'guarantor_name': guarantorName,
      if (guarantorPhone != null) 'guarantor_phone': guarantorPhone,
      if (guarantorAddress != null) 'guarantor_address': guarantorAddress,
      if (rackLocation != null) 'rack_location': rackLocation,
      if (remarks != null) 'remarks': remarks,
      if (status != null) 'status': status,
    });
  }

  GirviLoansCompanion copyWith({
    Value<int>? id,
    Value<String>? slipNumber,
    Value<int>? partyId,
    Value<DateTime>? transactionDate,
    Value<DateTime>? interestStartDate,
    Value<double>? roi,
    Value<InterestType>? interestType,
    Value<MetalType>? metalType,
    Value<double>? grossWeight,
    Value<double>? purityPercent,
    Value<double>? netWeight,
    Value<double>? estimatedValue,
    Value<double>? principalAmount,
    Value<PaymentMode>? paymentMode,
    Value<String>? itemDescription,
    Value<String?>? localPhotoPath,
    Value<String?>? guarantorName,
    Value<String?>? guarantorPhone,
    Value<String?>? guarantorAddress,
    Value<String?>? rackLocation,
    Value<String?>? remarks,
    Value<LoanStatus>? status,
  }) {
    return GirviLoansCompanion(
      id: id ?? this.id,
      slipNumber: slipNumber ?? this.slipNumber,
      partyId: partyId ?? this.partyId,
      transactionDate: transactionDate ?? this.transactionDate,
      interestStartDate: interestStartDate ?? this.interestStartDate,
      roi: roi ?? this.roi,
      interestType: interestType ?? this.interestType,
      metalType: metalType ?? this.metalType,
      grossWeight: grossWeight ?? this.grossWeight,
      purityPercent: purityPercent ?? this.purityPercent,
      netWeight: netWeight ?? this.netWeight,
      estimatedValue: estimatedValue ?? this.estimatedValue,
      principalAmount: principalAmount ?? this.principalAmount,
      paymentMode: paymentMode ?? this.paymentMode,
      itemDescription: itemDescription ?? this.itemDescription,
      localPhotoPath: localPhotoPath ?? this.localPhotoPath,
      guarantorName: guarantorName ?? this.guarantorName,
      guarantorPhone: guarantorPhone ?? this.guarantorPhone,
      guarantorAddress: guarantorAddress ?? this.guarantorAddress,
      rackLocation: rackLocation ?? this.rackLocation,
      remarks: remarks ?? this.remarks,
      status: status ?? this.status,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (slipNumber.present) {
      map['slip_number'] = Variable<String>(slipNumber.value);
    }
    if (partyId.present) {
      map['party_id'] = Variable<int>(partyId.value);
    }
    if (transactionDate.present) {
      map['transaction_date'] = Variable<DateTime>(transactionDate.value);
    }
    if (interestStartDate.present) {
      map['interest_start_date'] = Variable<DateTime>(interestStartDate.value);
    }
    if (roi.present) {
      map['roi'] = Variable<double>(roi.value);
    }
    if (interestType.present) {
      map['interest_type'] = Variable<String>(
        $GirviLoansTable.$converterinterestType.toSql(interestType.value),
      );
    }
    if (metalType.present) {
      map['metal_type'] = Variable<String>(
        $GirviLoansTable.$convertermetalType.toSql(metalType.value),
      );
    }
    if (grossWeight.present) {
      map['gross_weight'] = Variable<double>(grossWeight.value);
    }
    if (purityPercent.present) {
      map['purity_percent'] = Variable<double>(purityPercent.value);
    }
    if (netWeight.present) {
      map['net_weight'] = Variable<double>(netWeight.value);
    }
    if (estimatedValue.present) {
      map['estimated_value'] = Variable<double>(estimatedValue.value);
    }
    if (principalAmount.present) {
      map['principal_amount'] = Variable<double>(principalAmount.value);
    }
    if (paymentMode.present) {
      map['payment_mode'] = Variable<String>(
        $GirviLoansTable.$converterpaymentMode.toSql(paymentMode.value),
      );
    }
    if (itemDescription.present) {
      map['item_description'] = Variable<String>(itemDescription.value);
    }
    if (localPhotoPath.present) {
      map['local_photo_path'] = Variable<String>(localPhotoPath.value);
    }
    if (guarantorName.present) {
      map['guarantor_name'] = Variable<String>(guarantorName.value);
    }
    if (guarantorPhone.present) {
      map['guarantor_phone'] = Variable<String>(guarantorPhone.value);
    }
    if (guarantorAddress.present) {
      map['guarantor_address'] = Variable<String>(guarantorAddress.value);
    }
    if (rackLocation.present) {
      map['rack_location'] = Variable<String>(rackLocation.value);
    }
    if (remarks.present) {
      map['remarks'] = Variable<String>(remarks.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $GirviLoansTable.$converterstatus.toSql(status.value),
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GirviLoansCompanion(')
          ..write('id: $id, ')
          ..write('slipNumber: $slipNumber, ')
          ..write('partyId: $partyId, ')
          ..write('transactionDate: $transactionDate, ')
          ..write('interestStartDate: $interestStartDate, ')
          ..write('roi: $roi, ')
          ..write('interestType: $interestType, ')
          ..write('metalType: $metalType, ')
          ..write('grossWeight: $grossWeight, ')
          ..write('purityPercent: $purityPercent, ')
          ..write('netWeight: $netWeight, ')
          ..write('estimatedValue: $estimatedValue, ')
          ..write('principalAmount: $principalAmount, ')
          ..write('paymentMode: $paymentMode, ')
          ..write('itemDescription: $itemDescription, ')
          ..write('localPhotoPath: $localPhotoPath, ')
          ..write('guarantorName: $guarantorName, ')
          ..write('guarantorPhone: $guarantorPhone, ')
          ..write('guarantorAddress: $guarantorAddress, ')
          ..write('rackLocation: $rackLocation, ')
          ..write('remarks: $remarks, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }
}

class $LoanReceiptsTable extends LoanReceipts
    with TableInfo<$LoanReceiptsTable, LoanReceipt> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LoanReceiptsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _receiptNumberMeta = const VerificationMeta(
    'receiptNumber',
  );
  @override
  late final GeneratedColumn<String> receiptNumber = GeneratedColumn<String>(
    'receipt_number',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _loanIdMeta = const VerificationMeta('loanId');
  @override
  late final GeneratedColumn<int> loanId = GeneratedColumn<int>(
    'loan_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES girvi_loans (id)',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<PaymentMode, String> paymentMode =
      GeneratedColumn<String>(
        'payment_mode',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<PaymentMode>($LoanReceiptsTable.$converterpaymentMode);
  @override
  late final GeneratedColumnWithTypeConverter<ReceiptType, String> receiptType =
      GeneratedColumn<String>(
        'receipt_type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<ReceiptType>($LoanReceiptsTable.$converterreceiptType);
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _remarksMeta = const VerificationMeta(
    'remarks',
  );
  @override
  late final GeneratedColumn<String> remarks = GeneratedColumn<String>(
    'remarks',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    receiptNumber,
    loanId,
    date,
    paymentMode,
    receiptType,
    amount,
    remarks,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'loan_receipts';
  @override
  VerificationContext validateIntegrity(
    Insertable<LoanReceipt> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('receipt_number')) {
      context.handle(
        _receiptNumberMeta,
        receiptNumber.isAcceptableOrUnknown(
          data['receipt_number']!,
          _receiptNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_receiptNumberMeta);
    }
    if (data.containsKey('loan_id')) {
      context.handle(
        _loanIdMeta,
        loanId.isAcceptableOrUnknown(data['loan_id']!, _loanIdMeta),
      );
    } else if (isInserting) {
      context.missing(_loanIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('remarks')) {
      context.handle(
        _remarksMeta,
        remarks.isAcceptableOrUnknown(data['remarks']!, _remarksMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LoanReceipt map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LoanReceipt(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      receiptNumber:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}receipt_number'],
          )!,
      loanId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}loan_id'],
          )!,
      date:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}date'],
          )!,
      paymentMode: $LoanReceiptsTable.$converterpaymentMode.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}payment_mode'],
        )!,
      ),
      receiptType: $LoanReceiptsTable.$converterreceiptType.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}receipt_type'],
        )!,
      ),
      amount:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}amount'],
          )!,
      remarks: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}remarks'],
      ),
    );
  }

  @override
  $LoanReceiptsTable createAlias(String alias) {
    return $LoanReceiptsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<PaymentMode, String, String> $converterpaymentMode =
      const EnumNameConverter<PaymentMode>(PaymentMode.values);
  static JsonTypeConverter2<ReceiptType, String, String> $converterreceiptType =
      const EnumNameConverter<ReceiptType>(ReceiptType.values);
}

class LoanReceipt extends DataClass implements Insertable<LoanReceipt> {
  final int id;
  final String receiptNumber;
  final int loanId;
  final DateTime date;
  final PaymentMode paymentMode;
  final ReceiptType receiptType;
  final double amount;
  final String? remarks;
  const LoanReceipt({
    required this.id,
    required this.receiptNumber,
    required this.loanId,
    required this.date,
    required this.paymentMode,
    required this.receiptType,
    required this.amount,
    this.remarks,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['receipt_number'] = Variable<String>(receiptNumber);
    map['loan_id'] = Variable<int>(loanId);
    map['date'] = Variable<DateTime>(date);
    {
      map['payment_mode'] = Variable<String>(
        $LoanReceiptsTable.$converterpaymentMode.toSql(paymentMode),
      );
    }
    {
      map['receipt_type'] = Variable<String>(
        $LoanReceiptsTable.$converterreceiptType.toSql(receiptType),
      );
    }
    map['amount'] = Variable<double>(amount);
    if (!nullToAbsent || remarks != null) {
      map['remarks'] = Variable<String>(remarks);
    }
    return map;
  }

  LoanReceiptsCompanion toCompanion(bool nullToAbsent) {
    return LoanReceiptsCompanion(
      id: Value(id),
      receiptNumber: Value(receiptNumber),
      loanId: Value(loanId),
      date: Value(date),
      paymentMode: Value(paymentMode),
      receiptType: Value(receiptType),
      amount: Value(amount),
      remarks:
          remarks == null && nullToAbsent
              ? const Value.absent()
              : Value(remarks),
    );
  }

  factory LoanReceipt.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LoanReceipt(
      id: serializer.fromJson<int>(json['id']),
      receiptNumber: serializer.fromJson<String>(json['receiptNumber']),
      loanId: serializer.fromJson<int>(json['loanId']),
      date: serializer.fromJson<DateTime>(json['date']),
      paymentMode: $LoanReceiptsTable.$converterpaymentMode.fromJson(
        serializer.fromJson<String>(json['paymentMode']),
      ),
      receiptType: $LoanReceiptsTable.$converterreceiptType.fromJson(
        serializer.fromJson<String>(json['receiptType']),
      ),
      amount: serializer.fromJson<double>(json['amount']),
      remarks: serializer.fromJson<String?>(json['remarks']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'receiptNumber': serializer.toJson<String>(receiptNumber),
      'loanId': serializer.toJson<int>(loanId),
      'date': serializer.toJson<DateTime>(date),
      'paymentMode': serializer.toJson<String>(
        $LoanReceiptsTable.$converterpaymentMode.toJson(paymentMode),
      ),
      'receiptType': serializer.toJson<String>(
        $LoanReceiptsTable.$converterreceiptType.toJson(receiptType),
      ),
      'amount': serializer.toJson<double>(amount),
      'remarks': serializer.toJson<String?>(remarks),
    };
  }

  LoanReceipt copyWith({
    int? id,
    String? receiptNumber,
    int? loanId,
    DateTime? date,
    PaymentMode? paymentMode,
    ReceiptType? receiptType,
    double? amount,
    Value<String?> remarks = const Value.absent(),
  }) => LoanReceipt(
    id: id ?? this.id,
    receiptNumber: receiptNumber ?? this.receiptNumber,
    loanId: loanId ?? this.loanId,
    date: date ?? this.date,
    paymentMode: paymentMode ?? this.paymentMode,
    receiptType: receiptType ?? this.receiptType,
    amount: amount ?? this.amount,
    remarks: remarks.present ? remarks.value : this.remarks,
  );
  LoanReceipt copyWithCompanion(LoanReceiptsCompanion data) {
    return LoanReceipt(
      id: data.id.present ? data.id.value : this.id,
      receiptNumber:
          data.receiptNumber.present
              ? data.receiptNumber.value
              : this.receiptNumber,
      loanId: data.loanId.present ? data.loanId.value : this.loanId,
      date: data.date.present ? data.date.value : this.date,
      paymentMode:
          data.paymentMode.present ? data.paymentMode.value : this.paymentMode,
      receiptType:
          data.receiptType.present ? data.receiptType.value : this.receiptType,
      amount: data.amount.present ? data.amount.value : this.amount,
      remarks: data.remarks.present ? data.remarks.value : this.remarks,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LoanReceipt(')
          ..write('id: $id, ')
          ..write('receiptNumber: $receiptNumber, ')
          ..write('loanId: $loanId, ')
          ..write('date: $date, ')
          ..write('paymentMode: $paymentMode, ')
          ..write('receiptType: $receiptType, ')
          ..write('amount: $amount, ')
          ..write('remarks: $remarks')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    receiptNumber,
    loanId,
    date,
    paymentMode,
    receiptType,
    amount,
    remarks,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LoanReceipt &&
          other.id == this.id &&
          other.receiptNumber == this.receiptNumber &&
          other.loanId == this.loanId &&
          other.date == this.date &&
          other.paymentMode == this.paymentMode &&
          other.receiptType == this.receiptType &&
          other.amount == this.amount &&
          other.remarks == this.remarks);
}

class LoanReceiptsCompanion extends UpdateCompanion<LoanReceipt> {
  final Value<int> id;
  final Value<String> receiptNumber;
  final Value<int> loanId;
  final Value<DateTime> date;
  final Value<PaymentMode> paymentMode;
  final Value<ReceiptType> receiptType;
  final Value<double> amount;
  final Value<String?> remarks;
  const LoanReceiptsCompanion({
    this.id = const Value.absent(),
    this.receiptNumber = const Value.absent(),
    this.loanId = const Value.absent(),
    this.date = const Value.absent(),
    this.paymentMode = const Value.absent(),
    this.receiptType = const Value.absent(),
    this.amount = const Value.absent(),
    this.remarks = const Value.absent(),
  });
  LoanReceiptsCompanion.insert({
    this.id = const Value.absent(),
    required String receiptNumber,
    required int loanId,
    required DateTime date,
    required PaymentMode paymentMode,
    required ReceiptType receiptType,
    required double amount,
    this.remarks = const Value.absent(),
  }) : receiptNumber = Value(receiptNumber),
       loanId = Value(loanId),
       date = Value(date),
       paymentMode = Value(paymentMode),
       receiptType = Value(receiptType),
       amount = Value(amount);
  static Insertable<LoanReceipt> custom({
    Expression<int>? id,
    Expression<String>? receiptNumber,
    Expression<int>? loanId,
    Expression<DateTime>? date,
    Expression<String>? paymentMode,
    Expression<String>? receiptType,
    Expression<double>? amount,
    Expression<String>? remarks,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (receiptNumber != null) 'receipt_number': receiptNumber,
      if (loanId != null) 'loan_id': loanId,
      if (date != null) 'date': date,
      if (paymentMode != null) 'payment_mode': paymentMode,
      if (receiptType != null) 'receipt_type': receiptType,
      if (amount != null) 'amount': amount,
      if (remarks != null) 'remarks': remarks,
    });
  }

  LoanReceiptsCompanion copyWith({
    Value<int>? id,
    Value<String>? receiptNumber,
    Value<int>? loanId,
    Value<DateTime>? date,
    Value<PaymentMode>? paymentMode,
    Value<ReceiptType>? receiptType,
    Value<double>? amount,
    Value<String?>? remarks,
  }) {
    return LoanReceiptsCompanion(
      id: id ?? this.id,
      receiptNumber: receiptNumber ?? this.receiptNumber,
      loanId: loanId ?? this.loanId,
      date: date ?? this.date,
      paymentMode: paymentMode ?? this.paymentMode,
      receiptType: receiptType ?? this.receiptType,
      amount: amount ?? this.amount,
      remarks: remarks ?? this.remarks,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (receiptNumber.present) {
      map['receipt_number'] = Variable<String>(receiptNumber.value);
    }
    if (loanId.present) {
      map['loan_id'] = Variable<int>(loanId.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (paymentMode.present) {
      map['payment_mode'] = Variable<String>(
        $LoanReceiptsTable.$converterpaymentMode.toSql(paymentMode.value),
      );
    }
    if (receiptType.present) {
      map['receipt_type'] = Variable<String>(
        $LoanReceiptsTable.$converterreceiptType.toSql(receiptType.value),
      );
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (remarks.present) {
      map['remarks'] = Variable<String>(remarks.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LoanReceiptsCompanion(')
          ..write('id: $id, ')
          ..write('receiptNumber: $receiptNumber, ')
          ..write('loanId: $loanId, ')
          ..write('date: $date, ')
          ..write('paymentMode: $paymentMode, ')
          ..write('receiptType: $receiptType, ')
          ..write('amount: $amount, ')
          ..write('remarks: $remarks')
          ..write(')'))
        .toString();
  }
}

class $KarigarTransactionsTable extends KarigarTransactions
    with TableInfo<$KarigarTransactionsTable, KarigarTransaction> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $KarigarTransactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _voucherNumberMeta = const VerificationMeta(
    'voucherNumber',
  );
  @override
  late final GeneratedColumn<String> voucherNumber = GeneratedColumn<String>(
    'voucher_number',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _karigarIdMeta = const VerificationMeta(
    'karigarId',
  );
  @override
  late final GeneratedColumn<int> karigarId = GeneratedColumn<int>(
    'karigar_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES parties (id)',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<KarigarTxnType, String> type =
      GeneratedColumn<String>(
        'type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<KarigarTxnType>($KarigarTransactionsTable.$convertertype);
  static const VerificationMeta _itemDescriptionMeta = const VerificationMeta(
    'itemDescription',
  );
  @override
  late final GeneratedColumn<String> itemDescription = GeneratedColumn<String>(
    'item_description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _grossWeightMeta = const VerificationMeta(
    'grossWeight',
  );
  @override
  late final GeneratedColumn<double> grossWeight = GeneratedColumn<double>(
    'gross_weight',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _purityPercentMeta = const VerificationMeta(
    'purityPercent',
  );
  @override
  late final GeneratedColumn<double> purityPercent = GeneratedColumn<double>(
    'purity_percent',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _netWeightMeta = const VerificationMeta(
    'netWeight',
  );
  @override
  late final GeneratedColumn<double> netWeight = GeneratedColumn<double>(
    'net_weight',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _estimatedValueMeta = const VerificationMeta(
    'estimatedValue',
  );
  @override
  late final GeneratedColumn<double> estimatedValue = GeneratedColumn<double>(
    'estimated_value',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _remarksMeta = const VerificationMeta(
    'remarks',
  );
  @override
  late final GeneratedColumn<String> remarks = GeneratedColumn<String>(
    'remarks',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    voucherNumber,
    karigarId,
    date,
    type,
    itemDescription,
    quantity,
    grossWeight,
    purityPercent,
    netWeight,
    estimatedValue,
    remarks,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'karigar_transactions';
  @override
  VerificationContext validateIntegrity(
    Insertable<KarigarTransaction> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('voucher_number')) {
      context.handle(
        _voucherNumberMeta,
        voucherNumber.isAcceptableOrUnknown(
          data['voucher_number']!,
          _voucherNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_voucherNumberMeta);
    }
    if (data.containsKey('karigar_id')) {
      context.handle(
        _karigarIdMeta,
        karigarId.isAcceptableOrUnknown(data['karigar_id']!, _karigarIdMeta),
      );
    } else if (isInserting) {
      context.missing(_karigarIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('item_description')) {
      context.handle(
        _itemDescriptionMeta,
        itemDescription.isAcceptableOrUnknown(
          data['item_description']!,
          _itemDescriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_itemDescriptionMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    }
    if (data.containsKey('gross_weight')) {
      context.handle(
        _grossWeightMeta,
        grossWeight.isAcceptableOrUnknown(
          data['gross_weight']!,
          _grossWeightMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_grossWeightMeta);
    }
    if (data.containsKey('purity_percent')) {
      context.handle(
        _purityPercentMeta,
        purityPercent.isAcceptableOrUnknown(
          data['purity_percent']!,
          _purityPercentMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_purityPercentMeta);
    }
    if (data.containsKey('net_weight')) {
      context.handle(
        _netWeightMeta,
        netWeight.isAcceptableOrUnknown(data['net_weight']!, _netWeightMeta),
      );
    } else if (isInserting) {
      context.missing(_netWeightMeta);
    }
    if (data.containsKey('estimated_value')) {
      context.handle(
        _estimatedValueMeta,
        estimatedValue.isAcceptableOrUnknown(
          data['estimated_value']!,
          _estimatedValueMeta,
        ),
      );
    }
    if (data.containsKey('remarks')) {
      context.handle(
        _remarksMeta,
        remarks.isAcceptableOrUnknown(data['remarks']!, _remarksMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  KarigarTransaction map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return KarigarTransaction(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      voucherNumber:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}voucher_number'],
          )!,
      karigarId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}karigar_id'],
          )!,
      date:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}date'],
          )!,
      type: $KarigarTransactionsTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}type'],
        )!,
      ),
      itemDescription:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}item_description'],
          )!,
      quantity:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}quantity'],
          )!,
      grossWeight:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}gross_weight'],
          )!,
      purityPercent:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}purity_percent'],
          )!,
      netWeight:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}net_weight'],
          )!,
      estimatedValue: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}estimated_value'],
      ),
      remarks: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}remarks'],
      ),
    );
  }

  @override
  $KarigarTransactionsTable createAlias(String alias) {
    return $KarigarTransactionsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<KarigarTxnType, String, String> $convertertype =
      const EnumNameConverter<KarigarTxnType>(KarigarTxnType.values);
}

class KarigarTransaction extends DataClass
    implements Insertable<KarigarTransaction> {
  final int id;
  final String voucherNumber;
  final int karigarId;
  final DateTime date;
  final KarigarTxnType type;
  final String itemDescription;
  final int quantity;
  final double grossWeight;
  final double purityPercent;
  final double netWeight;
  final double? estimatedValue;
  final String? remarks;
  const KarigarTransaction({
    required this.id,
    required this.voucherNumber,
    required this.karigarId,
    required this.date,
    required this.type,
    required this.itemDescription,
    required this.quantity,
    required this.grossWeight,
    required this.purityPercent,
    required this.netWeight,
    this.estimatedValue,
    this.remarks,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['voucher_number'] = Variable<String>(voucherNumber);
    map['karigar_id'] = Variable<int>(karigarId);
    map['date'] = Variable<DateTime>(date);
    {
      map['type'] = Variable<String>(
        $KarigarTransactionsTable.$convertertype.toSql(type),
      );
    }
    map['item_description'] = Variable<String>(itemDescription);
    map['quantity'] = Variable<int>(quantity);
    map['gross_weight'] = Variable<double>(grossWeight);
    map['purity_percent'] = Variable<double>(purityPercent);
    map['net_weight'] = Variable<double>(netWeight);
    if (!nullToAbsent || estimatedValue != null) {
      map['estimated_value'] = Variable<double>(estimatedValue);
    }
    if (!nullToAbsent || remarks != null) {
      map['remarks'] = Variable<String>(remarks);
    }
    return map;
  }

  KarigarTransactionsCompanion toCompanion(bool nullToAbsent) {
    return KarigarTransactionsCompanion(
      id: Value(id),
      voucherNumber: Value(voucherNumber),
      karigarId: Value(karigarId),
      date: Value(date),
      type: Value(type),
      itemDescription: Value(itemDescription),
      quantity: Value(quantity),
      grossWeight: Value(grossWeight),
      purityPercent: Value(purityPercent),
      netWeight: Value(netWeight),
      estimatedValue:
          estimatedValue == null && nullToAbsent
              ? const Value.absent()
              : Value(estimatedValue),
      remarks:
          remarks == null && nullToAbsent
              ? const Value.absent()
              : Value(remarks),
    );
  }

  factory KarigarTransaction.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return KarigarTransaction(
      id: serializer.fromJson<int>(json['id']),
      voucherNumber: serializer.fromJson<String>(json['voucherNumber']),
      karigarId: serializer.fromJson<int>(json['karigarId']),
      date: serializer.fromJson<DateTime>(json['date']),
      type: $KarigarTransactionsTable.$convertertype.fromJson(
        serializer.fromJson<String>(json['type']),
      ),
      itemDescription: serializer.fromJson<String>(json['itemDescription']),
      quantity: serializer.fromJson<int>(json['quantity']),
      grossWeight: serializer.fromJson<double>(json['grossWeight']),
      purityPercent: serializer.fromJson<double>(json['purityPercent']),
      netWeight: serializer.fromJson<double>(json['netWeight']),
      estimatedValue: serializer.fromJson<double?>(json['estimatedValue']),
      remarks: serializer.fromJson<String?>(json['remarks']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'voucherNumber': serializer.toJson<String>(voucherNumber),
      'karigarId': serializer.toJson<int>(karigarId),
      'date': serializer.toJson<DateTime>(date),
      'type': serializer.toJson<String>(
        $KarigarTransactionsTable.$convertertype.toJson(type),
      ),
      'itemDescription': serializer.toJson<String>(itemDescription),
      'quantity': serializer.toJson<int>(quantity),
      'grossWeight': serializer.toJson<double>(grossWeight),
      'purityPercent': serializer.toJson<double>(purityPercent),
      'netWeight': serializer.toJson<double>(netWeight),
      'estimatedValue': serializer.toJson<double?>(estimatedValue),
      'remarks': serializer.toJson<String?>(remarks),
    };
  }

  KarigarTransaction copyWith({
    int? id,
    String? voucherNumber,
    int? karigarId,
    DateTime? date,
    KarigarTxnType? type,
    String? itemDescription,
    int? quantity,
    double? grossWeight,
    double? purityPercent,
    double? netWeight,
    Value<double?> estimatedValue = const Value.absent(),
    Value<String?> remarks = const Value.absent(),
  }) => KarigarTransaction(
    id: id ?? this.id,
    voucherNumber: voucherNumber ?? this.voucherNumber,
    karigarId: karigarId ?? this.karigarId,
    date: date ?? this.date,
    type: type ?? this.type,
    itemDescription: itemDescription ?? this.itemDescription,
    quantity: quantity ?? this.quantity,
    grossWeight: grossWeight ?? this.grossWeight,
    purityPercent: purityPercent ?? this.purityPercent,
    netWeight: netWeight ?? this.netWeight,
    estimatedValue:
        estimatedValue.present ? estimatedValue.value : this.estimatedValue,
    remarks: remarks.present ? remarks.value : this.remarks,
  );
  KarigarTransaction copyWithCompanion(KarigarTransactionsCompanion data) {
    return KarigarTransaction(
      id: data.id.present ? data.id.value : this.id,
      voucherNumber:
          data.voucherNumber.present
              ? data.voucherNumber.value
              : this.voucherNumber,
      karigarId: data.karigarId.present ? data.karigarId.value : this.karigarId,
      date: data.date.present ? data.date.value : this.date,
      type: data.type.present ? data.type.value : this.type,
      itemDescription:
          data.itemDescription.present
              ? data.itemDescription.value
              : this.itemDescription,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      grossWeight:
          data.grossWeight.present ? data.grossWeight.value : this.grossWeight,
      purityPercent:
          data.purityPercent.present
              ? data.purityPercent.value
              : this.purityPercent,
      netWeight: data.netWeight.present ? data.netWeight.value : this.netWeight,
      estimatedValue:
          data.estimatedValue.present
              ? data.estimatedValue.value
              : this.estimatedValue,
      remarks: data.remarks.present ? data.remarks.value : this.remarks,
    );
  }

  @override
  String toString() {
    return (StringBuffer('KarigarTransaction(')
          ..write('id: $id, ')
          ..write('voucherNumber: $voucherNumber, ')
          ..write('karigarId: $karigarId, ')
          ..write('date: $date, ')
          ..write('type: $type, ')
          ..write('itemDescription: $itemDescription, ')
          ..write('quantity: $quantity, ')
          ..write('grossWeight: $grossWeight, ')
          ..write('purityPercent: $purityPercent, ')
          ..write('netWeight: $netWeight, ')
          ..write('estimatedValue: $estimatedValue, ')
          ..write('remarks: $remarks')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    voucherNumber,
    karigarId,
    date,
    type,
    itemDescription,
    quantity,
    grossWeight,
    purityPercent,
    netWeight,
    estimatedValue,
    remarks,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is KarigarTransaction &&
          other.id == this.id &&
          other.voucherNumber == this.voucherNumber &&
          other.karigarId == this.karigarId &&
          other.date == this.date &&
          other.type == this.type &&
          other.itemDescription == this.itemDescription &&
          other.quantity == this.quantity &&
          other.grossWeight == this.grossWeight &&
          other.purityPercent == this.purityPercent &&
          other.netWeight == this.netWeight &&
          other.estimatedValue == this.estimatedValue &&
          other.remarks == this.remarks);
}

class KarigarTransactionsCompanion extends UpdateCompanion<KarigarTransaction> {
  final Value<int> id;
  final Value<String> voucherNumber;
  final Value<int> karigarId;
  final Value<DateTime> date;
  final Value<KarigarTxnType> type;
  final Value<String> itemDescription;
  final Value<int> quantity;
  final Value<double> grossWeight;
  final Value<double> purityPercent;
  final Value<double> netWeight;
  final Value<double?> estimatedValue;
  final Value<String?> remarks;
  const KarigarTransactionsCompanion({
    this.id = const Value.absent(),
    this.voucherNumber = const Value.absent(),
    this.karigarId = const Value.absent(),
    this.date = const Value.absent(),
    this.type = const Value.absent(),
    this.itemDescription = const Value.absent(),
    this.quantity = const Value.absent(),
    this.grossWeight = const Value.absent(),
    this.purityPercent = const Value.absent(),
    this.netWeight = const Value.absent(),
    this.estimatedValue = const Value.absent(),
    this.remarks = const Value.absent(),
  });
  KarigarTransactionsCompanion.insert({
    this.id = const Value.absent(),
    required String voucherNumber,
    required int karigarId,
    required DateTime date,
    required KarigarTxnType type,
    required String itemDescription,
    this.quantity = const Value.absent(),
    required double grossWeight,
    required double purityPercent,
    required double netWeight,
    this.estimatedValue = const Value.absent(),
    this.remarks = const Value.absent(),
  }) : voucherNumber = Value(voucherNumber),
       karigarId = Value(karigarId),
       date = Value(date),
       type = Value(type),
       itemDescription = Value(itemDescription),
       grossWeight = Value(grossWeight),
       purityPercent = Value(purityPercent),
       netWeight = Value(netWeight);
  static Insertable<KarigarTransaction> custom({
    Expression<int>? id,
    Expression<String>? voucherNumber,
    Expression<int>? karigarId,
    Expression<DateTime>? date,
    Expression<String>? type,
    Expression<String>? itemDescription,
    Expression<int>? quantity,
    Expression<double>? grossWeight,
    Expression<double>? purityPercent,
    Expression<double>? netWeight,
    Expression<double>? estimatedValue,
    Expression<String>? remarks,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (voucherNumber != null) 'voucher_number': voucherNumber,
      if (karigarId != null) 'karigar_id': karigarId,
      if (date != null) 'date': date,
      if (type != null) 'type': type,
      if (itemDescription != null) 'item_description': itemDescription,
      if (quantity != null) 'quantity': quantity,
      if (grossWeight != null) 'gross_weight': grossWeight,
      if (purityPercent != null) 'purity_percent': purityPercent,
      if (netWeight != null) 'net_weight': netWeight,
      if (estimatedValue != null) 'estimated_value': estimatedValue,
      if (remarks != null) 'remarks': remarks,
    });
  }

  KarigarTransactionsCompanion copyWith({
    Value<int>? id,
    Value<String>? voucherNumber,
    Value<int>? karigarId,
    Value<DateTime>? date,
    Value<KarigarTxnType>? type,
    Value<String>? itemDescription,
    Value<int>? quantity,
    Value<double>? grossWeight,
    Value<double>? purityPercent,
    Value<double>? netWeight,
    Value<double?>? estimatedValue,
    Value<String?>? remarks,
  }) {
    return KarigarTransactionsCompanion(
      id: id ?? this.id,
      voucherNumber: voucherNumber ?? this.voucherNumber,
      karigarId: karigarId ?? this.karigarId,
      date: date ?? this.date,
      type: type ?? this.type,
      itemDescription: itemDescription ?? this.itemDescription,
      quantity: quantity ?? this.quantity,
      grossWeight: grossWeight ?? this.grossWeight,
      purityPercent: purityPercent ?? this.purityPercent,
      netWeight: netWeight ?? this.netWeight,
      estimatedValue: estimatedValue ?? this.estimatedValue,
      remarks: remarks ?? this.remarks,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (voucherNumber.present) {
      map['voucher_number'] = Variable<String>(voucherNumber.value);
    }
    if (karigarId.present) {
      map['karigar_id'] = Variable<int>(karigarId.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(
        $KarigarTransactionsTable.$convertertype.toSql(type.value),
      );
    }
    if (itemDescription.present) {
      map['item_description'] = Variable<String>(itemDescription.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (grossWeight.present) {
      map['gross_weight'] = Variable<double>(grossWeight.value);
    }
    if (purityPercent.present) {
      map['purity_percent'] = Variable<double>(purityPercent.value);
    }
    if (netWeight.present) {
      map['net_weight'] = Variable<double>(netWeight.value);
    }
    if (estimatedValue.present) {
      map['estimated_value'] = Variable<double>(estimatedValue.value);
    }
    if (remarks.present) {
      map['remarks'] = Variable<String>(remarks.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('KarigarTransactionsCompanion(')
          ..write('id: $id, ')
          ..write('voucherNumber: $voucherNumber, ')
          ..write('karigarId: $karigarId, ')
          ..write('date: $date, ')
          ..write('type: $type, ')
          ..write('itemDescription: $itemDescription, ')
          ..write('quantity: $quantity, ')
          ..write('grossWeight: $grossWeight, ')
          ..write('purityPercent: $purityPercent, ')
          ..write('netWeight: $netWeight, ')
          ..write('estimatedValue: $estimatedValue, ')
          ..write('remarks: $remarks')
          ..write(')'))
        .toString();
  }
}

class $GstVouchersTable extends GstVouchers
    with TableInfo<$GstVouchersTable, GstVoucher> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GstVouchersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<GstVoucherType, String>
  voucherType = GeneratedColumn<String>(
    'voucher_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<GstVoucherType>($GstVouchersTable.$convertervoucherType);
  @override
  late final GeneratedColumnWithTypeConverter<PaymentTerm, String> paymentTerm =
      GeneratedColumn<String>(
        'payment_term',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<PaymentTerm>($GstVouchersTable.$converterpaymentTerm);
  static const VerificationMeta _partyIdMeta = const VerificationMeta(
    'partyId',
  );
  @override
  late final GeneratedColumn<int> partyId = GeneratedColumn<int>(
    'party_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES parties (id)',
    ),
  );
  static const VerificationMeta _bookSeriesMeta = const VerificationMeta(
    'bookSeries',
  );
  @override
  late final GeneratedColumn<String> bookSeries = GeneratedColumn<String>(
    'book_series',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _billNumberMeta = const VerificationMeta(
    'billNumber',
  );
  @override
  late final GeneratedColumn<String> billNumber = GeneratedColumn<String>(
    'bill_number',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hsnCodeMeta = const VerificationMeta(
    'hsnCode',
  );
  @override
  late final GeneratedColumn<String> hsnCode = GeneratedColumn<String>(
    'hsn_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _taxSlabPercentMeta = const VerificationMeta(
    'taxSlabPercent',
  );
  @override
  late final GeneratedColumn<double> taxSlabPercent = GeneratedColumn<double>(
    'tax_slab_percent',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _taxableAmountMeta = const VerificationMeta(
    'taxableAmount',
  );
  @override
  late final GeneratedColumn<double> taxableAmount = GeneratedColumn<double>(
    'taxable_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cgstAmountMeta = const VerificationMeta(
    'cgstAmount',
  );
  @override
  late final GeneratedColumn<double> cgstAmount = GeneratedColumn<double>(
    'cgst_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sgstAmountMeta = const VerificationMeta(
    'sgstAmount',
  );
  @override
  late final GeneratedColumn<double> sgstAmount = GeneratedColumn<double>(
    'sgst_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalAmountMeta = const VerificationMeta(
    'totalAmount',
  );
  @override
  late final GeneratedColumn<double> totalAmount = GeneratedColumn<double>(
    'total_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    voucherType,
    paymentTerm,
    partyId,
    bookSeries,
    billNumber,
    date,
    hsnCode,
    description,
    taxSlabPercent,
    taxableAmount,
    cgstAmount,
    sgstAmount,
    totalAmount,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'gst_vouchers';
  @override
  VerificationContext validateIntegrity(
    Insertable<GstVoucher> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('party_id')) {
      context.handle(
        _partyIdMeta,
        partyId.isAcceptableOrUnknown(data['party_id']!, _partyIdMeta),
      );
    } else if (isInserting) {
      context.missing(_partyIdMeta);
    }
    if (data.containsKey('book_series')) {
      context.handle(
        _bookSeriesMeta,
        bookSeries.isAcceptableOrUnknown(data['book_series']!, _bookSeriesMeta),
      );
    }
    if (data.containsKey('bill_number')) {
      context.handle(
        _billNumberMeta,
        billNumber.isAcceptableOrUnknown(data['bill_number']!, _billNumberMeta),
      );
    } else if (isInserting) {
      context.missing(_billNumberMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('hsn_code')) {
      context.handle(
        _hsnCodeMeta,
        hsnCode.isAcceptableOrUnknown(data['hsn_code']!, _hsnCodeMeta),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('tax_slab_percent')) {
      context.handle(
        _taxSlabPercentMeta,
        taxSlabPercent.isAcceptableOrUnknown(
          data['tax_slab_percent']!,
          _taxSlabPercentMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_taxSlabPercentMeta);
    }
    if (data.containsKey('taxable_amount')) {
      context.handle(
        _taxableAmountMeta,
        taxableAmount.isAcceptableOrUnknown(
          data['taxable_amount']!,
          _taxableAmountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_taxableAmountMeta);
    }
    if (data.containsKey('cgst_amount')) {
      context.handle(
        _cgstAmountMeta,
        cgstAmount.isAcceptableOrUnknown(data['cgst_amount']!, _cgstAmountMeta),
      );
    } else if (isInserting) {
      context.missing(_cgstAmountMeta);
    }
    if (data.containsKey('sgst_amount')) {
      context.handle(
        _sgstAmountMeta,
        sgstAmount.isAcceptableOrUnknown(data['sgst_amount']!, _sgstAmountMeta),
      );
    } else if (isInserting) {
      context.missing(_sgstAmountMeta);
    }
    if (data.containsKey('total_amount')) {
      context.handle(
        _totalAmountMeta,
        totalAmount.isAcceptableOrUnknown(
          data['total_amount']!,
          _totalAmountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalAmountMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GstVoucher map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GstVoucher(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      voucherType: $GstVouchersTable.$convertervoucherType.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}voucher_type'],
        )!,
      ),
      paymentTerm: $GstVouchersTable.$converterpaymentTerm.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}payment_term'],
        )!,
      ),
      partyId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}party_id'],
          )!,
      bookSeries: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}book_series'],
      ),
      billNumber:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}bill_number'],
          )!,
      date:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}date'],
          )!,
      hsnCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hsn_code'],
      ),
      description:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}description'],
          )!,
      taxSlabPercent:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}tax_slab_percent'],
          )!,
      taxableAmount:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}taxable_amount'],
          )!,
      cgstAmount:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}cgst_amount'],
          )!,
      sgstAmount:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}sgst_amount'],
          )!,
      totalAmount:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}total_amount'],
          )!,
    );
  }

  @override
  $GstVouchersTable createAlias(String alias) {
    return $GstVouchersTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<GstVoucherType, String, String>
  $convertervoucherType = const EnumNameConverter<GstVoucherType>(
    GstVoucherType.values,
  );
  static JsonTypeConverter2<PaymentTerm, String, String> $converterpaymentTerm =
      const EnumNameConverter<PaymentTerm>(PaymentTerm.values);
}

class GstVoucher extends DataClass implements Insertable<GstVoucher> {
  final int id;
  final GstVoucherType voucherType;
  final PaymentTerm paymentTerm;
  final int partyId;
  final String? bookSeries;
  final String billNumber;
  final DateTime date;
  final String? hsnCode;
  final String description;
  final double taxSlabPercent;
  final double taxableAmount;
  final double cgstAmount;
  final double sgstAmount;
  final double totalAmount;
  const GstVoucher({
    required this.id,
    required this.voucherType,
    required this.paymentTerm,
    required this.partyId,
    this.bookSeries,
    required this.billNumber,
    required this.date,
    this.hsnCode,
    required this.description,
    required this.taxSlabPercent,
    required this.taxableAmount,
    required this.cgstAmount,
    required this.sgstAmount,
    required this.totalAmount,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    {
      map['voucher_type'] = Variable<String>(
        $GstVouchersTable.$convertervoucherType.toSql(voucherType),
      );
    }
    {
      map['payment_term'] = Variable<String>(
        $GstVouchersTable.$converterpaymentTerm.toSql(paymentTerm),
      );
    }
    map['party_id'] = Variable<int>(partyId);
    if (!nullToAbsent || bookSeries != null) {
      map['book_series'] = Variable<String>(bookSeries);
    }
    map['bill_number'] = Variable<String>(billNumber);
    map['date'] = Variable<DateTime>(date);
    if (!nullToAbsent || hsnCode != null) {
      map['hsn_code'] = Variable<String>(hsnCode);
    }
    map['description'] = Variable<String>(description);
    map['tax_slab_percent'] = Variable<double>(taxSlabPercent);
    map['taxable_amount'] = Variable<double>(taxableAmount);
    map['cgst_amount'] = Variable<double>(cgstAmount);
    map['sgst_amount'] = Variable<double>(sgstAmount);
    map['total_amount'] = Variable<double>(totalAmount);
    return map;
  }

  GstVouchersCompanion toCompanion(bool nullToAbsent) {
    return GstVouchersCompanion(
      id: Value(id),
      voucherType: Value(voucherType),
      paymentTerm: Value(paymentTerm),
      partyId: Value(partyId),
      bookSeries:
          bookSeries == null && nullToAbsent
              ? const Value.absent()
              : Value(bookSeries),
      billNumber: Value(billNumber),
      date: Value(date),
      hsnCode:
          hsnCode == null && nullToAbsent
              ? const Value.absent()
              : Value(hsnCode),
      description: Value(description),
      taxSlabPercent: Value(taxSlabPercent),
      taxableAmount: Value(taxableAmount),
      cgstAmount: Value(cgstAmount),
      sgstAmount: Value(sgstAmount),
      totalAmount: Value(totalAmount),
    );
  }

  factory GstVoucher.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GstVoucher(
      id: serializer.fromJson<int>(json['id']),
      voucherType: $GstVouchersTable.$convertervoucherType.fromJson(
        serializer.fromJson<String>(json['voucherType']),
      ),
      paymentTerm: $GstVouchersTable.$converterpaymentTerm.fromJson(
        serializer.fromJson<String>(json['paymentTerm']),
      ),
      partyId: serializer.fromJson<int>(json['partyId']),
      bookSeries: serializer.fromJson<String?>(json['bookSeries']),
      billNumber: serializer.fromJson<String>(json['billNumber']),
      date: serializer.fromJson<DateTime>(json['date']),
      hsnCode: serializer.fromJson<String?>(json['hsnCode']),
      description: serializer.fromJson<String>(json['description']),
      taxSlabPercent: serializer.fromJson<double>(json['taxSlabPercent']),
      taxableAmount: serializer.fromJson<double>(json['taxableAmount']),
      cgstAmount: serializer.fromJson<double>(json['cgstAmount']),
      sgstAmount: serializer.fromJson<double>(json['sgstAmount']),
      totalAmount: serializer.fromJson<double>(json['totalAmount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'voucherType': serializer.toJson<String>(
        $GstVouchersTable.$convertervoucherType.toJson(voucherType),
      ),
      'paymentTerm': serializer.toJson<String>(
        $GstVouchersTable.$converterpaymentTerm.toJson(paymentTerm),
      ),
      'partyId': serializer.toJson<int>(partyId),
      'bookSeries': serializer.toJson<String?>(bookSeries),
      'billNumber': serializer.toJson<String>(billNumber),
      'date': serializer.toJson<DateTime>(date),
      'hsnCode': serializer.toJson<String?>(hsnCode),
      'description': serializer.toJson<String>(description),
      'taxSlabPercent': serializer.toJson<double>(taxSlabPercent),
      'taxableAmount': serializer.toJson<double>(taxableAmount),
      'cgstAmount': serializer.toJson<double>(cgstAmount),
      'sgstAmount': serializer.toJson<double>(sgstAmount),
      'totalAmount': serializer.toJson<double>(totalAmount),
    };
  }

  GstVoucher copyWith({
    int? id,
    GstVoucherType? voucherType,
    PaymentTerm? paymentTerm,
    int? partyId,
    Value<String?> bookSeries = const Value.absent(),
    String? billNumber,
    DateTime? date,
    Value<String?> hsnCode = const Value.absent(),
    String? description,
    double? taxSlabPercent,
    double? taxableAmount,
    double? cgstAmount,
    double? sgstAmount,
    double? totalAmount,
  }) => GstVoucher(
    id: id ?? this.id,
    voucherType: voucherType ?? this.voucherType,
    paymentTerm: paymentTerm ?? this.paymentTerm,
    partyId: partyId ?? this.partyId,
    bookSeries: bookSeries.present ? bookSeries.value : this.bookSeries,
    billNumber: billNumber ?? this.billNumber,
    date: date ?? this.date,
    hsnCode: hsnCode.present ? hsnCode.value : this.hsnCode,
    description: description ?? this.description,
    taxSlabPercent: taxSlabPercent ?? this.taxSlabPercent,
    taxableAmount: taxableAmount ?? this.taxableAmount,
    cgstAmount: cgstAmount ?? this.cgstAmount,
    sgstAmount: sgstAmount ?? this.sgstAmount,
    totalAmount: totalAmount ?? this.totalAmount,
  );
  GstVoucher copyWithCompanion(GstVouchersCompanion data) {
    return GstVoucher(
      id: data.id.present ? data.id.value : this.id,
      voucherType:
          data.voucherType.present ? data.voucherType.value : this.voucherType,
      paymentTerm:
          data.paymentTerm.present ? data.paymentTerm.value : this.paymentTerm,
      partyId: data.partyId.present ? data.partyId.value : this.partyId,
      bookSeries:
          data.bookSeries.present ? data.bookSeries.value : this.bookSeries,
      billNumber:
          data.billNumber.present ? data.billNumber.value : this.billNumber,
      date: data.date.present ? data.date.value : this.date,
      hsnCode: data.hsnCode.present ? data.hsnCode.value : this.hsnCode,
      description:
          data.description.present ? data.description.value : this.description,
      taxSlabPercent:
          data.taxSlabPercent.present
              ? data.taxSlabPercent.value
              : this.taxSlabPercent,
      taxableAmount:
          data.taxableAmount.present
              ? data.taxableAmount.value
              : this.taxableAmount,
      cgstAmount:
          data.cgstAmount.present ? data.cgstAmount.value : this.cgstAmount,
      sgstAmount:
          data.sgstAmount.present ? data.sgstAmount.value : this.sgstAmount,
      totalAmount:
          data.totalAmount.present ? data.totalAmount.value : this.totalAmount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GstVoucher(')
          ..write('id: $id, ')
          ..write('voucherType: $voucherType, ')
          ..write('paymentTerm: $paymentTerm, ')
          ..write('partyId: $partyId, ')
          ..write('bookSeries: $bookSeries, ')
          ..write('billNumber: $billNumber, ')
          ..write('date: $date, ')
          ..write('hsnCode: $hsnCode, ')
          ..write('description: $description, ')
          ..write('taxSlabPercent: $taxSlabPercent, ')
          ..write('taxableAmount: $taxableAmount, ')
          ..write('cgstAmount: $cgstAmount, ')
          ..write('sgstAmount: $sgstAmount, ')
          ..write('totalAmount: $totalAmount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    voucherType,
    paymentTerm,
    partyId,
    bookSeries,
    billNumber,
    date,
    hsnCode,
    description,
    taxSlabPercent,
    taxableAmount,
    cgstAmount,
    sgstAmount,
    totalAmount,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GstVoucher &&
          other.id == this.id &&
          other.voucherType == this.voucherType &&
          other.paymentTerm == this.paymentTerm &&
          other.partyId == this.partyId &&
          other.bookSeries == this.bookSeries &&
          other.billNumber == this.billNumber &&
          other.date == this.date &&
          other.hsnCode == this.hsnCode &&
          other.description == this.description &&
          other.taxSlabPercent == this.taxSlabPercent &&
          other.taxableAmount == this.taxableAmount &&
          other.cgstAmount == this.cgstAmount &&
          other.sgstAmount == this.sgstAmount &&
          other.totalAmount == this.totalAmount);
}

class GstVouchersCompanion extends UpdateCompanion<GstVoucher> {
  final Value<int> id;
  final Value<GstVoucherType> voucherType;
  final Value<PaymentTerm> paymentTerm;
  final Value<int> partyId;
  final Value<String?> bookSeries;
  final Value<String> billNumber;
  final Value<DateTime> date;
  final Value<String?> hsnCode;
  final Value<String> description;
  final Value<double> taxSlabPercent;
  final Value<double> taxableAmount;
  final Value<double> cgstAmount;
  final Value<double> sgstAmount;
  final Value<double> totalAmount;
  const GstVouchersCompanion({
    this.id = const Value.absent(),
    this.voucherType = const Value.absent(),
    this.paymentTerm = const Value.absent(),
    this.partyId = const Value.absent(),
    this.bookSeries = const Value.absent(),
    this.billNumber = const Value.absent(),
    this.date = const Value.absent(),
    this.hsnCode = const Value.absent(),
    this.description = const Value.absent(),
    this.taxSlabPercent = const Value.absent(),
    this.taxableAmount = const Value.absent(),
    this.cgstAmount = const Value.absent(),
    this.sgstAmount = const Value.absent(),
    this.totalAmount = const Value.absent(),
  });
  GstVouchersCompanion.insert({
    this.id = const Value.absent(),
    required GstVoucherType voucherType,
    required PaymentTerm paymentTerm,
    required int partyId,
    this.bookSeries = const Value.absent(),
    required String billNumber,
    required DateTime date,
    this.hsnCode = const Value.absent(),
    required String description,
    required double taxSlabPercent,
    required double taxableAmount,
    required double cgstAmount,
    required double sgstAmount,
    required double totalAmount,
  }) : voucherType = Value(voucherType),
       paymentTerm = Value(paymentTerm),
       partyId = Value(partyId),
       billNumber = Value(billNumber),
       date = Value(date),
       description = Value(description),
       taxSlabPercent = Value(taxSlabPercent),
       taxableAmount = Value(taxableAmount),
       cgstAmount = Value(cgstAmount),
       sgstAmount = Value(sgstAmount),
       totalAmount = Value(totalAmount);
  static Insertable<GstVoucher> custom({
    Expression<int>? id,
    Expression<String>? voucherType,
    Expression<String>? paymentTerm,
    Expression<int>? partyId,
    Expression<String>? bookSeries,
    Expression<String>? billNumber,
    Expression<DateTime>? date,
    Expression<String>? hsnCode,
    Expression<String>? description,
    Expression<double>? taxSlabPercent,
    Expression<double>? taxableAmount,
    Expression<double>? cgstAmount,
    Expression<double>? sgstAmount,
    Expression<double>? totalAmount,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (voucherType != null) 'voucher_type': voucherType,
      if (paymentTerm != null) 'payment_term': paymentTerm,
      if (partyId != null) 'party_id': partyId,
      if (bookSeries != null) 'book_series': bookSeries,
      if (billNumber != null) 'bill_number': billNumber,
      if (date != null) 'date': date,
      if (hsnCode != null) 'hsn_code': hsnCode,
      if (description != null) 'description': description,
      if (taxSlabPercent != null) 'tax_slab_percent': taxSlabPercent,
      if (taxableAmount != null) 'taxable_amount': taxableAmount,
      if (cgstAmount != null) 'cgst_amount': cgstAmount,
      if (sgstAmount != null) 'sgst_amount': sgstAmount,
      if (totalAmount != null) 'total_amount': totalAmount,
    });
  }

  GstVouchersCompanion copyWith({
    Value<int>? id,
    Value<GstVoucherType>? voucherType,
    Value<PaymentTerm>? paymentTerm,
    Value<int>? partyId,
    Value<String?>? bookSeries,
    Value<String>? billNumber,
    Value<DateTime>? date,
    Value<String?>? hsnCode,
    Value<String>? description,
    Value<double>? taxSlabPercent,
    Value<double>? taxableAmount,
    Value<double>? cgstAmount,
    Value<double>? sgstAmount,
    Value<double>? totalAmount,
  }) {
    return GstVouchersCompanion(
      id: id ?? this.id,
      voucherType: voucherType ?? this.voucherType,
      paymentTerm: paymentTerm ?? this.paymentTerm,
      partyId: partyId ?? this.partyId,
      bookSeries: bookSeries ?? this.bookSeries,
      billNumber: billNumber ?? this.billNumber,
      date: date ?? this.date,
      hsnCode: hsnCode ?? this.hsnCode,
      description: description ?? this.description,
      taxSlabPercent: taxSlabPercent ?? this.taxSlabPercent,
      taxableAmount: taxableAmount ?? this.taxableAmount,
      cgstAmount: cgstAmount ?? this.cgstAmount,
      sgstAmount: sgstAmount ?? this.sgstAmount,
      totalAmount: totalAmount ?? this.totalAmount,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (voucherType.present) {
      map['voucher_type'] = Variable<String>(
        $GstVouchersTable.$convertervoucherType.toSql(voucherType.value),
      );
    }
    if (paymentTerm.present) {
      map['payment_term'] = Variable<String>(
        $GstVouchersTable.$converterpaymentTerm.toSql(paymentTerm.value),
      );
    }
    if (partyId.present) {
      map['party_id'] = Variable<int>(partyId.value);
    }
    if (bookSeries.present) {
      map['book_series'] = Variable<String>(bookSeries.value);
    }
    if (billNumber.present) {
      map['bill_number'] = Variable<String>(billNumber.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (hsnCode.present) {
      map['hsn_code'] = Variable<String>(hsnCode.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (taxSlabPercent.present) {
      map['tax_slab_percent'] = Variable<double>(taxSlabPercent.value);
    }
    if (taxableAmount.present) {
      map['taxable_amount'] = Variable<double>(taxableAmount.value);
    }
    if (cgstAmount.present) {
      map['cgst_amount'] = Variable<double>(cgstAmount.value);
    }
    if (sgstAmount.present) {
      map['sgst_amount'] = Variable<double>(sgstAmount.value);
    }
    if (totalAmount.present) {
      map['total_amount'] = Variable<double>(totalAmount.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GstVouchersCompanion(')
          ..write('id: $id, ')
          ..write('voucherType: $voucherType, ')
          ..write('paymentTerm: $paymentTerm, ')
          ..write('partyId: $partyId, ')
          ..write('bookSeries: $bookSeries, ')
          ..write('billNumber: $billNumber, ')
          ..write('date: $date, ')
          ..write('hsnCode: $hsnCode, ')
          ..write('description: $description, ')
          ..write('taxSlabPercent: $taxSlabPercent, ')
          ..write('taxableAmount: $taxableAmount, ')
          ..write('cgstAmount: $cgstAmount, ')
          ..write('sgstAmount: $sgstAmount, ')
          ..write('totalAmount: $totalAmount')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $DailyRatesTable dailyRates = $DailyRatesTable(this);
  late final $PartiesTable parties = $PartiesTable(this);
  late final $GirviLoansTable girviLoans = $GirviLoansTable(this);
  late final $LoanReceiptsTable loanReceipts = $LoanReceiptsTable(this);
  late final $KarigarTransactionsTable karigarTransactions =
      $KarigarTransactionsTable(this);
  late final $GstVouchersTable gstVouchers = $GstVouchersTable(this);
  late final DailyRatesDao dailyRatesDao = DailyRatesDao(this as AppDatabase);
  late final PartiesDao partiesDao = PartiesDao(this as AppDatabase);
  late final GirviLoansDao girviLoansDao = GirviLoansDao(this as AppDatabase);
  late final LoanReceiptsDao loanReceiptsDao = LoanReceiptsDao(
    this as AppDatabase,
  );
  late final KarigarTransactionsDao karigarTransactionsDao =
      KarigarTransactionsDao(this as AppDatabase);
  late final GstVouchersDao gstVouchersDao = GstVouchersDao(
    this as AppDatabase,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    dailyRates,
    parties,
    girviLoans,
    loanReceipts,
    karigarTransactions,
    gstVouchers,
  ];
}

typedef $$DailyRatesTableCreateCompanionBuilder =
    DailyRatesCompanion Function({
      Value<int> id,
      required DateTime date,
      Value<double?> gold16k,
      Value<double?> gold18k,
      Value<double?> gold22k,
      Value<double?> gold24k,
      Value<double?> silverRate,
    });
typedef $$DailyRatesTableUpdateCompanionBuilder =
    DailyRatesCompanion Function({
      Value<int> id,
      Value<DateTime> date,
      Value<double?> gold16k,
      Value<double?> gold18k,
      Value<double?> gold22k,
      Value<double?> gold24k,
      Value<double?> silverRate,
    });

class $$DailyRatesTableFilterComposer
    extends Composer<_$AppDatabase, $DailyRatesTable> {
  $$DailyRatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get gold16k => $composableBuilder(
    column: $table.gold16k,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get gold18k => $composableBuilder(
    column: $table.gold18k,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get gold22k => $composableBuilder(
    column: $table.gold22k,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get gold24k => $composableBuilder(
    column: $table.gold24k,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get silverRate => $composableBuilder(
    column: $table.silverRate,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DailyRatesTableOrderingComposer
    extends Composer<_$AppDatabase, $DailyRatesTable> {
  $$DailyRatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get gold16k => $composableBuilder(
    column: $table.gold16k,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get gold18k => $composableBuilder(
    column: $table.gold18k,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get gold22k => $composableBuilder(
    column: $table.gold22k,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get gold24k => $composableBuilder(
    column: $table.gold24k,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get silverRate => $composableBuilder(
    column: $table.silverRate,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DailyRatesTableAnnotationComposer
    extends Composer<_$AppDatabase, $DailyRatesTable> {
  $$DailyRatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<double> get gold16k =>
      $composableBuilder(column: $table.gold16k, builder: (column) => column);

  GeneratedColumn<double> get gold18k =>
      $composableBuilder(column: $table.gold18k, builder: (column) => column);

  GeneratedColumn<double> get gold22k =>
      $composableBuilder(column: $table.gold22k, builder: (column) => column);

  GeneratedColumn<double> get gold24k =>
      $composableBuilder(column: $table.gold24k, builder: (column) => column);

  GeneratedColumn<double> get silverRate => $composableBuilder(
    column: $table.silverRate,
    builder: (column) => column,
  );
}

class $$DailyRatesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DailyRatesTable,
          DailyRate,
          $$DailyRatesTableFilterComposer,
          $$DailyRatesTableOrderingComposer,
          $$DailyRatesTableAnnotationComposer,
          $$DailyRatesTableCreateCompanionBuilder,
          $$DailyRatesTableUpdateCompanionBuilder,
          (
            DailyRate,
            BaseReferences<_$AppDatabase, $DailyRatesTable, DailyRate>,
          ),
          DailyRate,
          PrefetchHooks Function()
        > {
  $$DailyRatesTableTableManager(_$AppDatabase db, $DailyRatesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$DailyRatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$DailyRatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$DailyRatesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<double?> gold16k = const Value.absent(),
                Value<double?> gold18k = const Value.absent(),
                Value<double?> gold22k = const Value.absent(),
                Value<double?> gold24k = const Value.absent(),
                Value<double?> silverRate = const Value.absent(),
              }) => DailyRatesCompanion(
                id: id,
                date: date,
                gold16k: gold16k,
                gold18k: gold18k,
                gold22k: gold22k,
                gold24k: gold24k,
                silverRate: silverRate,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime date,
                Value<double?> gold16k = const Value.absent(),
                Value<double?> gold18k = const Value.absent(),
                Value<double?> gold22k = const Value.absent(),
                Value<double?> gold24k = const Value.absent(),
                Value<double?> silverRate = const Value.absent(),
              }) => DailyRatesCompanion.insert(
                id: id,
                date: date,
                gold16k: gold16k,
                gold18k: gold18k,
                gold22k: gold22k,
                gold24k: gold24k,
                silverRate: silverRate,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DailyRatesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DailyRatesTable,
      DailyRate,
      $$DailyRatesTableFilterComposer,
      $$DailyRatesTableOrderingComposer,
      $$DailyRatesTableAnnotationComposer,
      $$DailyRatesTableCreateCompanionBuilder,
      $$DailyRatesTableUpdateCompanionBuilder,
      (DailyRate, BaseReferences<_$AppDatabase, $DailyRatesTable, DailyRate>),
      DailyRate,
      PrefetchHooks Function()
    >;
typedef $$PartiesTableCreateCompanionBuilder =
    PartiesCompanion Function({
      Value<int> id,
      required String name,
      required PartyGroupType groupType,
      Value<String?> mobile,
      Value<String?> state,
      Value<String?> address,
      Value<String?> kycDocType,
      Value<String?> kycDocNumber,
      Value<DateTime> createdAt,
    });
typedef $$PartiesTableUpdateCompanionBuilder =
    PartiesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<PartyGroupType> groupType,
      Value<String?> mobile,
      Value<String?> state,
      Value<String?> address,
      Value<String?> kycDocType,
      Value<String?> kycDocNumber,
      Value<DateTime> createdAt,
    });

final class $$PartiesTableReferences
    extends BaseReferences<_$AppDatabase, $PartiesTable, Party> {
  $$PartiesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$GirviLoansTable, List<GirviLoan>>
  _girviLoansRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.girviLoans,
    aliasName: $_aliasNameGenerator(db.parties.id, db.girviLoans.partyId),
  );

  $$GirviLoansTableProcessedTableManager get girviLoansRefs {
    final manager = $$GirviLoansTableTableManager(
      $_db,
      $_db.girviLoans,
    ).filter((f) => f.partyId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_girviLoansRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $KarigarTransactionsTable,
    List<KarigarTransaction>
  >
  _karigarTransactionsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.karigarTransactions,
        aliasName: $_aliasNameGenerator(
          db.parties.id,
          db.karigarTransactions.karigarId,
        ),
      );

  $$KarigarTransactionsTableProcessedTableManager get karigarTransactionsRefs {
    final manager = $$KarigarTransactionsTableTableManager(
      $_db,
      $_db.karigarTransactions,
    ).filter((f) => f.karigarId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _karigarTransactionsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$GstVouchersTable, List<GstVoucher>>
  _gstVouchersRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.gstVouchers,
    aliasName: $_aliasNameGenerator(db.parties.id, db.gstVouchers.partyId),
  );

  $$GstVouchersTableProcessedTableManager get gstVouchersRefs {
    final manager = $$GstVouchersTableTableManager(
      $_db,
      $_db.gstVouchers,
    ).filter((f) => f.partyId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_gstVouchersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PartiesTableFilterComposer
    extends Composer<_$AppDatabase, $PartiesTable> {
  $$PartiesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<PartyGroupType, PartyGroupType, String>
  get groupType => $composableBuilder(
    column: $table.groupType,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get mobile => $composableBuilder(
    column: $table.mobile,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kycDocType => $composableBuilder(
    column: $table.kycDocType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kycDocNumber => $composableBuilder(
    column: $table.kycDocNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> girviLoansRefs(
    Expression<bool> Function($$GirviLoansTableFilterComposer f) f,
  ) {
    final $$GirviLoansTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.girviLoans,
      getReferencedColumn: (t) => t.partyId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GirviLoansTableFilterComposer(
            $db: $db,
            $table: $db.girviLoans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> karigarTransactionsRefs(
    Expression<bool> Function($$KarigarTransactionsTableFilterComposer f) f,
  ) {
    final $$KarigarTransactionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.karigarTransactions,
      getReferencedColumn: (t) => t.karigarId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$KarigarTransactionsTableFilterComposer(
            $db: $db,
            $table: $db.karigarTransactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> gstVouchersRefs(
    Expression<bool> Function($$GstVouchersTableFilterComposer f) f,
  ) {
    final $$GstVouchersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.gstVouchers,
      getReferencedColumn: (t) => t.partyId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GstVouchersTableFilterComposer(
            $db: $db,
            $table: $db.gstVouchers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PartiesTableOrderingComposer
    extends Composer<_$AppDatabase, $PartiesTable> {
  $$PartiesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get groupType => $composableBuilder(
    column: $table.groupType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mobile => $composableBuilder(
    column: $table.mobile,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kycDocType => $composableBuilder(
    column: $table.kycDocType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kycDocNumber => $composableBuilder(
    column: $table.kycDocNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PartiesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PartiesTable> {
  $$PartiesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumnWithTypeConverter<PartyGroupType, String> get groupType =>
      $composableBuilder(column: $table.groupType, builder: (column) => column);

  GeneratedColumn<String> get mobile =>
      $composableBuilder(column: $table.mobile, builder: (column) => column);

  GeneratedColumn<String> get state =>
      $composableBuilder(column: $table.state, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get kycDocType => $composableBuilder(
    column: $table.kycDocType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get kycDocNumber => $composableBuilder(
    column: $table.kycDocNumber,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> girviLoansRefs<T extends Object>(
    Expression<T> Function($$GirviLoansTableAnnotationComposer a) f,
  ) {
    final $$GirviLoansTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.girviLoans,
      getReferencedColumn: (t) => t.partyId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GirviLoansTableAnnotationComposer(
            $db: $db,
            $table: $db.girviLoans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> karigarTransactionsRefs<T extends Object>(
    Expression<T> Function($$KarigarTransactionsTableAnnotationComposer a) f,
  ) {
    final $$KarigarTransactionsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.karigarTransactions,
          getReferencedColumn: (t) => t.karigarId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$KarigarTransactionsTableAnnotationComposer(
                $db: $db,
                $table: $db.karigarTransactions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> gstVouchersRefs<T extends Object>(
    Expression<T> Function($$GstVouchersTableAnnotationComposer a) f,
  ) {
    final $$GstVouchersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.gstVouchers,
      getReferencedColumn: (t) => t.partyId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GstVouchersTableAnnotationComposer(
            $db: $db,
            $table: $db.gstVouchers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PartiesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PartiesTable,
          Party,
          $$PartiesTableFilterComposer,
          $$PartiesTableOrderingComposer,
          $$PartiesTableAnnotationComposer,
          $$PartiesTableCreateCompanionBuilder,
          $$PartiesTableUpdateCompanionBuilder,
          (Party, $$PartiesTableReferences),
          Party,
          PrefetchHooks Function({
            bool girviLoansRefs,
            bool karigarTransactionsRefs,
            bool gstVouchersRefs,
          })
        > {
  $$PartiesTableTableManager(_$AppDatabase db, $PartiesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$PartiesTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$PartiesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$PartiesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<PartyGroupType> groupType = const Value.absent(),
                Value<String?> mobile = const Value.absent(),
                Value<String?> state = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<String?> kycDocType = const Value.absent(),
                Value<String?> kycDocNumber = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => PartiesCompanion(
                id: id,
                name: name,
                groupType: groupType,
                mobile: mobile,
                state: state,
                address: address,
                kycDocType: kycDocType,
                kycDocNumber: kycDocNumber,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required PartyGroupType groupType,
                Value<String?> mobile = const Value.absent(),
                Value<String?> state = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<String?> kycDocType = const Value.absent(),
                Value<String?> kycDocNumber = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => PartiesCompanion.insert(
                id: id,
                name: name,
                groupType: groupType,
                mobile: mobile,
                state: state,
                address: address,
                kycDocType: kycDocType,
                kycDocNumber: kycDocNumber,
                createdAt: createdAt,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$PartiesTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({
            girviLoansRefs = false,
            karigarTransactionsRefs = false,
            gstVouchersRefs = false,
          }) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (girviLoansRefs) db.girviLoans,
                if (karigarTransactionsRefs) db.karigarTransactions,
                if (gstVouchersRefs) db.gstVouchers,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (girviLoansRefs)
                    await $_getPrefetchedData<Party, $PartiesTable, GirviLoan>(
                      currentTable: table,
                      referencedTable: $$PartiesTableReferences
                          ._girviLoansRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$PartiesTableReferences(
                                db,
                                table,
                                p0,
                              ).girviLoansRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) => e.partyId == item.id,
                          ),
                      typedResults: items,
                    ),
                  if (karigarTransactionsRefs)
                    await $_getPrefetchedData<
                      Party,
                      $PartiesTable,
                      KarigarTransaction
                    >(
                      currentTable: table,
                      referencedTable: $$PartiesTableReferences
                          ._karigarTransactionsRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$PartiesTableReferences(
                                db,
                                table,
                                p0,
                              ).karigarTransactionsRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) => e.karigarId == item.id,
                          ),
                      typedResults: items,
                    ),
                  if (gstVouchersRefs)
                    await $_getPrefetchedData<Party, $PartiesTable, GstVoucher>(
                      currentTable: table,
                      referencedTable: $$PartiesTableReferences
                          ._gstVouchersRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$PartiesTableReferences(
                                db,
                                table,
                                p0,
                              ).gstVouchersRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) => e.partyId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$PartiesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PartiesTable,
      Party,
      $$PartiesTableFilterComposer,
      $$PartiesTableOrderingComposer,
      $$PartiesTableAnnotationComposer,
      $$PartiesTableCreateCompanionBuilder,
      $$PartiesTableUpdateCompanionBuilder,
      (Party, $$PartiesTableReferences),
      Party,
      PrefetchHooks Function({
        bool girviLoansRefs,
        bool karigarTransactionsRefs,
        bool gstVouchersRefs,
      })
    >;
typedef $$GirviLoansTableCreateCompanionBuilder =
    GirviLoansCompanion Function({
      Value<int> id,
      required String slipNumber,
      required int partyId,
      required DateTime transactionDate,
      required DateTime interestStartDate,
      required double roi,
      required InterestType interestType,
      required MetalType metalType,
      required double grossWeight,
      required double purityPercent,
      required double netWeight,
      required double estimatedValue,
      required double principalAmount,
      required PaymentMode paymentMode,
      required String itemDescription,
      Value<String?> localPhotoPath,
      Value<String?> guarantorName,
      Value<String?> guarantorPhone,
      Value<String?> guarantorAddress,
      Value<String?> rackLocation,
      Value<String?> remarks,
      Value<LoanStatus> status,
    });
typedef $$GirviLoansTableUpdateCompanionBuilder =
    GirviLoansCompanion Function({
      Value<int> id,
      Value<String> slipNumber,
      Value<int> partyId,
      Value<DateTime> transactionDate,
      Value<DateTime> interestStartDate,
      Value<double> roi,
      Value<InterestType> interestType,
      Value<MetalType> metalType,
      Value<double> grossWeight,
      Value<double> purityPercent,
      Value<double> netWeight,
      Value<double> estimatedValue,
      Value<double> principalAmount,
      Value<PaymentMode> paymentMode,
      Value<String> itemDescription,
      Value<String?> localPhotoPath,
      Value<String?> guarantorName,
      Value<String?> guarantorPhone,
      Value<String?> guarantorAddress,
      Value<String?> rackLocation,
      Value<String?> remarks,
      Value<LoanStatus> status,
    });

final class $$GirviLoansTableReferences
    extends BaseReferences<_$AppDatabase, $GirviLoansTable, GirviLoan> {
  $$GirviLoansTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PartiesTable _partyIdTable(_$AppDatabase db) => db.parties
      .createAlias($_aliasNameGenerator(db.girviLoans.partyId, db.parties.id));

  $$PartiesTableProcessedTableManager get partyId {
    final $_column = $_itemColumn<int>('party_id')!;

    final manager = $$PartiesTableTableManager(
      $_db,
      $_db.parties,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_partyIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$LoanReceiptsTable, List<LoanReceipt>>
  _loanReceiptsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.loanReceipts,
    aliasName: $_aliasNameGenerator(db.girviLoans.id, db.loanReceipts.loanId),
  );

  $$LoanReceiptsTableProcessedTableManager get loanReceiptsRefs {
    final manager = $$LoanReceiptsTableTableManager(
      $_db,
      $_db.loanReceipts,
    ).filter((f) => f.loanId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_loanReceiptsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$GirviLoansTableFilterComposer
    extends Composer<_$AppDatabase, $GirviLoansTable> {
  $$GirviLoansTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get slipNumber => $composableBuilder(
    column: $table.slipNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get transactionDate => $composableBuilder(
    column: $table.transactionDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get interestStartDate => $composableBuilder(
    column: $table.interestStartDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get roi => $composableBuilder(
    column: $table.roi,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<InterestType, InterestType, String>
  get interestType => $composableBuilder(
    column: $table.interestType,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<MetalType, MetalType, String> get metalType =>
      $composableBuilder(
        column: $table.metalType,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<double> get grossWeight => $composableBuilder(
    column: $table.grossWeight,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get purityPercent => $composableBuilder(
    column: $table.purityPercent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get netWeight => $composableBuilder(
    column: $table.netWeight,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get estimatedValue => $composableBuilder(
    column: $table.estimatedValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get principalAmount => $composableBuilder(
    column: $table.principalAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<PaymentMode, PaymentMode, String>
  get paymentMode => $composableBuilder(
    column: $table.paymentMode,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get itemDescription => $composableBuilder(
    column: $table.itemDescription,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localPhotoPath => $composableBuilder(
    column: $table.localPhotoPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get guarantorName => $composableBuilder(
    column: $table.guarantorName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get guarantorPhone => $composableBuilder(
    column: $table.guarantorPhone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get guarantorAddress => $composableBuilder(
    column: $table.guarantorAddress,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rackLocation => $composableBuilder(
    column: $table.rackLocation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get remarks => $composableBuilder(
    column: $table.remarks,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<LoanStatus, LoanStatus, String> get status =>
      $composableBuilder(
        column: $table.status,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  $$PartiesTableFilterComposer get partyId {
    final $$PartiesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.partyId,
      referencedTable: $db.parties,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PartiesTableFilterComposer(
            $db: $db,
            $table: $db.parties,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> loanReceiptsRefs(
    Expression<bool> Function($$LoanReceiptsTableFilterComposer f) f,
  ) {
    final $$LoanReceiptsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.loanReceipts,
      getReferencedColumn: (t) => t.loanId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LoanReceiptsTableFilterComposer(
            $db: $db,
            $table: $db.loanReceipts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$GirviLoansTableOrderingComposer
    extends Composer<_$AppDatabase, $GirviLoansTable> {
  $$GirviLoansTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get slipNumber => $composableBuilder(
    column: $table.slipNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get transactionDate => $composableBuilder(
    column: $table.transactionDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get interestStartDate => $composableBuilder(
    column: $table.interestStartDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get roi => $composableBuilder(
    column: $table.roi,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get interestType => $composableBuilder(
    column: $table.interestType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get metalType => $composableBuilder(
    column: $table.metalType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get grossWeight => $composableBuilder(
    column: $table.grossWeight,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get purityPercent => $composableBuilder(
    column: $table.purityPercent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get netWeight => $composableBuilder(
    column: $table.netWeight,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get estimatedValue => $composableBuilder(
    column: $table.estimatedValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get principalAmount => $composableBuilder(
    column: $table.principalAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paymentMode => $composableBuilder(
    column: $table.paymentMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get itemDescription => $composableBuilder(
    column: $table.itemDescription,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localPhotoPath => $composableBuilder(
    column: $table.localPhotoPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get guarantorName => $composableBuilder(
    column: $table.guarantorName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get guarantorPhone => $composableBuilder(
    column: $table.guarantorPhone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get guarantorAddress => $composableBuilder(
    column: $table.guarantorAddress,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rackLocation => $composableBuilder(
    column: $table.rackLocation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get remarks => $composableBuilder(
    column: $table.remarks,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  $$PartiesTableOrderingComposer get partyId {
    final $$PartiesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.partyId,
      referencedTable: $db.parties,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PartiesTableOrderingComposer(
            $db: $db,
            $table: $db.parties,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GirviLoansTableAnnotationComposer
    extends Composer<_$AppDatabase, $GirviLoansTable> {
  $$GirviLoansTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get slipNumber => $composableBuilder(
    column: $table.slipNumber,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get transactionDate => $composableBuilder(
    column: $table.transactionDate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get interestStartDate => $composableBuilder(
    column: $table.interestStartDate,
    builder: (column) => column,
  );

  GeneratedColumn<double> get roi =>
      $composableBuilder(column: $table.roi, builder: (column) => column);

  GeneratedColumnWithTypeConverter<InterestType, String> get interestType =>
      $composableBuilder(
        column: $table.interestType,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<MetalType, String> get metalType =>
      $composableBuilder(column: $table.metalType, builder: (column) => column);

  GeneratedColumn<double> get grossWeight => $composableBuilder(
    column: $table.grossWeight,
    builder: (column) => column,
  );

  GeneratedColumn<double> get purityPercent => $composableBuilder(
    column: $table.purityPercent,
    builder: (column) => column,
  );

  GeneratedColumn<double> get netWeight =>
      $composableBuilder(column: $table.netWeight, builder: (column) => column);

  GeneratedColumn<double> get estimatedValue => $composableBuilder(
    column: $table.estimatedValue,
    builder: (column) => column,
  );

  GeneratedColumn<double> get principalAmount => $composableBuilder(
    column: $table.principalAmount,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<PaymentMode, String> get paymentMode =>
      $composableBuilder(
        column: $table.paymentMode,
        builder: (column) => column,
      );

  GeneratedColumn<String> get itemDescription => $composableBuilder(
    column: $table.itemDescription,
    builder: (column) => column,
  );

  GeneratedColumn<String> get localPhotoPath => $composableBuilder(
    column: $table.localPhotoPath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get guarantorName => $composableBuilder(
    column: $table.guarantorName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get guarantorPhone => $composableBuilder(
    column: $table.guarantorPhone,
    builder: (column) => column,
  );

  GeneratedColumn<String> get guarantorAddress => $composableBuilder(
    column: $table.guarantorAddress,
    builder: (column) => column,
  );

  GeneratedColumn<String> get rackLocation => $composableBuilder(
    column: $table.rackLocation,
    builder: (column) => column,
  );

  GeneratedColumn<String> get remarks =>
      $composableBuilder(column: $table.remarks, builder: (column) => column);

  GeneratedColumnWithTypeConverter<LoanStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  $$PartiesTableAnnotationComposer get partyId {
    final $$PartiesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.partyId,
      referencedTable: $db.parties,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PartiesTableAnnotationComposer(
            $db: $db,
            $table: $db.parties,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> loanReceiptsRefs<T extends Object>(
    Expression<T> Function($$LoanReceiptsTableAnnotationComposer a) f,
  ) {
    final $$LoanReceiptsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.loanReceipts,
      getReferencedColumn: (t) => t.loanId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LoanReceiptsTableAnnotationComposer(
            $db: $db,
            $table: $db.loanReceipts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$GirviLoansTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GirviLoansTable,
          GirviLoan,
          $$GirviLoansTableFilterComposer,
          $$GirviLoansTableOrderingComposer,
          $$GirviLoansTableAnnotationComposer,
          $$GirviLoansTableCreateCompanionBuilder,
          $$GirviLoansTableUpdateCompanionBuilder,
          (GirviLoan, $$GirviLoansTableReferences),
          GirviLoan,
          PrefetchHooks Function({bool partyId, bool loanReceiptsRefs})
        > {
  $$GirviLoansTableTableManager(_$AppDatabase db, $GirviLoansTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$GirviLoansTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$GirviLoansTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$GirviLoansTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> slipNumber = const Value.absent(),
                Value<int> partyId = const Value.absent(),
                Value<DateTime> transactionDate = const Value.absent(),
                Value<DateTime> interestStartDate = const Value.absent(),
                Value<double> roi = const Value.absent(),
                Value<InterestType> interestType = const Value.absent(),
                Value<MetalType> metalType = const Value.absent(),
                Value<double> grossWeight = const Value.absent(),
                Value<double> purityPercent = const Value.absent(),
                Value<double> netWeight = const Value.absent(),
                Value<double> estimatedValue = const Value.absent(),
                Value<double> principalAmount = const Value.absent(),
                Value<PaymentMode> paymentMode = const Value.absent(),
                Value<String> itemDescription = const Value.absent(),
                Value<String?> localPhotoPath = const Value.absent(),
                Value<String?> guarantorName = const Value.absent(),
                Value<String?> guarantorPhone = const Value.absent(),
                Value<String?> guarantorAddress = const Value.absent(),
                Value<String?> rackLocation = const Value.absent(),
                Value<String?> remarks = const Value.absent(),
                Value<LoanStatus> status = const Value.absent(),
              }) => GirviLoansCompanion(
                id: id,
                slipNumber: slipNumber,
                partyId: partyId,
                transactionDate: transactionDate,
                interestStartDate: interestStartDate,
                roi: roi,
                interestType: interestType,
                metalType: metalType,
                grossWeight: grossWeight,
                purityPercent: purityPercent,
                netWeight: netWeight,
                estimatedValue: estimatedValue,
                principalAmount: principalAmount,
                paymentMode: paymentMode,
                itemDescription: itemDescription,
                localPhotoPath: localPhotoPath,
                guarantorName: guarantorName,
                guarantorPhone: guarantorPhone,
                guarantorAddress: guarantorAddress,
                rackLocation: rackLocation,
                remarks: remarks,
                status: status,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String slipNumber,
                required int partyId,
                required DateTime transactionDate,
                required DateTime interestStartDate,
                required double roi,
                required InterestType interestType,
                required MetalType metalType,
                required double grossWeight,
                required double purityPercent,
                required double netWeight,
                required double estimatedValue,
                required double principalAmount,
                required PaymentMode paymentMode,
                required String itemDescription,
                Value<String?> localPhotoPath = const Value.absent(),
                Value<String?> guarantorName = const Value.absent(),
                Value<String?> guarantorPhone = const Value.absent(),
                Value<String?> guarantorAddress = const Value.absent(),
                Value<String?> rackLocation = const Value.absent(),
                Value<String?> remarks = const Value.absent(),
                Value<LoanStatus> status = const Value.absent(),
              }) => GirviLoansCompanion.insert(
                id: id,
                slipNumber: slipNumber,
                partyId: partyId,
                transactionDate: transactionDate,
                interestStartDate: interestStartDate,
                roi: roi,
                interestType: interestType,
                metalType: metalType,
                grossWeight: grossWeight,
                purityPercent: purityPercent,
                netWeight: netWeight,
                estimatedValue: estimatedValue,
                principalAmount: principalAmount,
                paymentMode: paymentMode,
                itemDescription: itemDescription,
                localPhotoPath: localPhotoPath,
                guarantorName: guarantorName,
                guarantorPhone: guarantorPhone,
                guarantorAddress: guarantorAddress,
                rackLocation: rackLocation,
                remarks: remarks,
                status: status,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$GirviLoansTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({partyId = false, loanReceiptsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (loanReceiptsRefs) db.loanReceipts],
              addJoins: <
                T extends TableManagerState<
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic
                >
              >(state) {
                if (partyId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.partyId,
                            referencedTable: $$GirviLoansTableReferences
                                ._partyIdTable(db),
                            referencedColumn:
                                $$GirviLoansTableReferences
                                    ._partyIdTable(db)
                                    .id,
                          )
                          as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (loanReceiptsRefs)
                    await $_getPrefetchedData<
                      GirviLoan,
                      $GirviLoansTable,
                      LoanReceipt
                    >(
                      currentTable: table,
                      referencedTable: $$GirviLoansTableReferences
                          ._loanReceiptsRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$GirviLoansTableReferences(
                                db,
                                table,
                                p0,
                              ).loanReceiptsRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) =>
                              referencedItems.where((e) => e.loanId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$GirviLoansTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GirviLoansTable,
      GirviLoan,
      $$GirviLoansTableFilterComposer,
      $$GirviLoansTableOrderingComposer,
      $$GirviLoansTableAnnotationComposer,
      $$GirviLoansTableCreateCompanionBuilder,
      $$GirviLoansTableUpdateCompanionBuilder,
      (GirviLoan, $$GirviLoansTableReferences),
      GirviLoan,
      PrefetchHooks Function({bool partyId, bool loanReceiptsRefs})
    >;
typedef $$LoanReceiptsTableCreateCompanionBuilder =
    LoanReceiptsCompanion Function({
      Value<int> id,
      required String receiptNumber,
      required int loanId,
      required DateTime date,
      required PaymentMode paymentMode,
      required ReceiptType receiptType,
      required double amount,
      Value<String?> remarks,
    });
typedef $$LoanReceiptsTableUpdateCompanionBuilder =
    LoanReceiptsCompanion Function({
      Value<int> id,
      Value<String> receiptNumber,
      Value<int> loanId,
      Value<DateTime> date,
      Value<PaymentMode> paymentMode,
      Value<ReceiptType> receiptType,
      Value<double> amount,
      Value<String?> remarks,
    });

final class $$LoanReceiptsTableReferences
    extends BaseReferences<_$AppDatabase, $LoanReceiptsTable, LoanReceipt> {
  $$LoanReceiptsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $GirviLoansTable _loanIdTable(_$AppDatabase db) =>
      db.girviLoans.createAlias(
        $_aliasNameGenerator(db.loanReceipts.loanId, db.girviLoans.id),
      );

  $$GirviLoansTableProcessedTableManager get loanId {
    final $_column = $_itemColumn<int>('loan_id')!;

    final manager = $$GirviLoansTableTableManager(
      $_db,
      $_db.girviLoans,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_loanIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$LoanReceiptsTableFilterComposer
    extends Composer<_$AppDatabase, $LoanReceiptsTable> {
  $$LoanReceiptsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get receiptNumber => $composableBuilder(
    column: $table.receiptNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<PaymentMode, PaymentMode, String>
  get paymentMode => $composableBuilder(
    column: $table.paymentMode,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<ReceiptType, ReceiptType, String>
  get receiptType => $composableBuilder(
    column: $table.receiptType,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get remarks => $composableBuilder(
    column: $table.remarks,
    builder: (column) => ColumnFilters(column),
  );

  $$GirviLoansTableFilterComposer get loanId {
    final $$GirviLoansTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.loanId,
      referencedTable: $db.girviLoans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GirviLoansTableFilterComposer(
            $db: $db,
            $table: $db.girviLoans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LoanReceiptsTableOrderingComposer
    extends Composer<_$AppDatabase, $LoanReceiptsTable> {
  $$LoanReceiptsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get receiptNumber => $composableBuilder(
    column: $table.receiptNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paymentMode => $composableBuilder(
    column: $table.paymentMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get receiptType => $composableBuilder(
    column: $table.receiptType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get remarks => $composableBuilder(
    column: $table.remarks,
    builder: (column) => ColumnOrderings(column),
  );

  $$GirviLoansTableOrderingComposer get loanId {
    final $$GirviLoansTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.loanId,
      referencedTable: $db.girviLoans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GirviLoansTableOrderingComposer(
            $db: $db,
            $table: $db.girviLoans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LoanReceiptsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LoanReceiptsTable> {
  $$LoanReceiptsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get receiptNumber => $composableBuilder(
    column: $table.receiptNumber,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumnWithTypeConverter<PaymentMode, String> get paymentMode =>
      $composableBuilder(
        column: $table.paymentMode,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<ReceiptType, String> get receiptType =>
      $composableBuilder(
        column: $table.receiptType,
        builder: (column) => column,
      );

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get remarks =>
      $composableBuilder(column: $table.remarks, builder: (column) => column);

  $$GirviLoansTableAnnotationComposer get loanId {
    final $$GirviLoansTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.loanId,
      referencedTable: $db.girviLoans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GirviLoansTableAnnotationComposer(
            $db: $db,
            $table: $db.girviLoans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LoanReceiptsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LoanReceiptsTable,
          LoanReceipt,
          $$LoanReceiptsTableFilterComposer,
          $$LoanReceiptsTableOrderingComposer,
          $$LoanReceiptsTableAnnotationComposer,
          $$LoanReceiptsTableCreateCompanionBuilder,
          $$LoanReceiptsTableUpdateCompanionBuilder,
          (LoanReceipt, $$LoanReceiptsTableReferences),
          LoanReceipt,
          PrefetchHooks Function({bool loanId})
        > {
  $$LoanReceiptsTableTableManager(_$AppDatabase db, $LoanReceiptsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$LoanReceiptsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$LoanReceiptsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () =>
                  $$LoanReceiptsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> receiptNumber = const Value.absent(),
                Value<int> loanId = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<PaymentMode> paymentMode = const Value.absent(),
                Value<ReceiptType> receiptType = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<String?> remarks = const Value.absent(),
              }) => LoanReceiptsCompanion(
                id: id,
                receiptNumber: receiptNumber,
                loanId: loanId,
                date: date,
                paymentMode: paymentMode,
                receiptType: receiptType,
                amount: amount,
                remarks: remarks,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String receiptNumber,
                required int loanId,
                required DateTime date,
                required PaymentMode paymentMode,
                required ReceiptType receiptType,
                required double amount,
                Value<String?> remarks = const Value.absent(),
              }) => LoanReceiptsCompanion.insert(
                id: id,
                receiptNumber: receiptNumber,
                loanId: loanId,
                date: date,
                paymentMode: paymentMode,
                receiptType: receiptType,
                amount: amount,
                remarks: remarks,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$LoanReceiptsTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({loanId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                T extends TableManagerState<
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic
                >
              >(state) {
                if (loanId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.loanId,
                            referencedTable: $$LoanReceiptsTableReferences
                                ._loanIdTable(db),
                            referencedColumn:
                                $$LoanReceiptsTableReferences
                                    ._loanIdTable(db)
                                    .id,
                          )
                          as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$LoanReceiptsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LoanReceiptsTable,
      LoanReceipt,
      $$LoanReceiptsTableFilterComposer,
      $$LoanReceiptsTableOrderingComposer,
      $$LoanReceiptsTableAnnotationComposer,
      $$LoanReceiptsTableCreateCompanionBuilder,
      $$LoanReceiptsTableUpdateCompanionBuilder,
      (LoanReceipt, $$LoanReceiptsTableReferences),
      LoanReceipt,
      PrefetchHooks Function({bool loanId})
    >;
typedef $$KarigarTransactionsTableCreateCompanionBuilder =
    KarigarTransactionsCompanion Function({
      Value<int> id,
      required String voucherNumber,
      required int karigarId,
      required DateTime date,
      required KarigarTxnType type,
      required String itemDescription,
      Value<int> quantity,
      required double grossWeight,
      required double purityPercent,
      required double netWeight,
      Value<double?> estimatedValue,
      Value<String?> remarks,
    });
typedef $$KarigarTransactionsTableUpdateCompanionBuilder =
    KarigarTransactionsCompanion Function({
      Value<int> id,
      Value<String> voucherNumber,
      Value<int> karigarId,
      Value<DateTime> date,
      Value<KarigarTxnType> type,
      Value<String> itemDescription,
      Value<int> quantity,
      Value<double> grossWeight,
      Value<double> purityPercent,
      Value<double> netWeight,
      Value<double?> estimatedValue,
      Value<String?> remarks,
    });

final class $$KarigarTransactionsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $KarigarTransactionsTable,
          KarigarTransaction
        > {
  $$KarigarTransactionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $PartiesTable _karigarIdTable(_$AppDatabase db) =>
      db.parties.createAlias(
        $_aliasNameGenerator(db.karigarTransactions.karigarId, db.parties.id),
      );

  $$PartiesTableProcessedTableManager get karigarId {
    final $_column = $_itemColumn<int>('karigar_id')!;

    final manager = $$PartiesTableTableManager(
      $_db,
      $_db.parties,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_karigarIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$KarigarTransactionsTableFilterComposer
    extends Composer<_$AppDatabase, $KarigarTransactionsTable> {
  $$KarigarTransactionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get voucherNumber => $composableBuilder(
    column: $table.voucherNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<KarigarTxnType, KarigarTxnType, String>
  get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get itemDescription => $composableBuilder(
    column: $table.itemDescription,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get grossWeight => $composableBuilder(
    column: $table.grossWeight,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get purityPercent => $composableBuilder(
    column: $table.purityPercent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get netWeight => $composableBuilder(
    column: $table.netWeight,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get estimatedValue => $composableBuilder(
    column: $table.estimatedValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get remarks => $composableBuilder(
    column: $table.remarks,
    builder: (column) => ColumnFilters(column),
  );

  $$PartiesTableFilterComposer get karigarId {
    final $$PartiesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.karigarId,
      referencedTable: $db.parties,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PartiesTableFilterComposer(
            $db: $db,
            $table: $db.parties,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$KarigarTransactionsTableOrderingComposer
    extends Composer<_$AppDatabase, $KarigarTransactionsTable> {
  $$KarigarTransactionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get voucherNumber => $composableBuilder(
    column: $table.voucherNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get itemDescription => $composableBuilder(
    column: $table.itemDescription,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get grossWeight => $composableBuilder(
    column: $table.grossWeight,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get purityPercent => $composableBuilder(
    column: $table.purityPercent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get netWeight => $composableBuilder(
    column: $table.netWeight,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get estimatedValue => $composableBuilder(
    column: $table.estimatedValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get remarks => $composableBuilder(
    column: $table.remarks,
    builder: (column) => ColumnOrderings(column),
  );

  $$PartiesTableOrderingComposer get karigarId {
    final $$PartiesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.karigarId,
      referencedTable: $db.parties,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PartiesTableOrderingComposer(
            $db: $db,
            $table: $db.parties,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$KarigarTransactionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $KarigarTransactionsTable> {
  $$KarigarTransactionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get voucherNumber => $composableBuilder(
    column: $table.voucherNumber,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumnWithTypeConverter<KarigarTxnType, String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get itemDescription => $composableBuilder(
    column: $table.itemDescription,
    builder: (column) => column,
  );

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<double> get grossWeight => $composableBuilder(
    column: $table.grossWeight,
    builder: (column) => column,
  );

  GeneratedColumn<double> get purityPercent => $composableBuilder(
    column: $table.purityPercent,
    builder: (column) => column,
  );

  GeneratedColumn<double> get netWeight =>
      $composableBuilder(column: $table.netWeight, builder: (column) => column);

  GeneratedColumn<double> get estimatedValue => $composableBuilder(
    column: $table.estimatedValue,
    builder: (column) => column,
  );

  GeneratedColumn<String> get remarks =>
      $composableBuilder(column: $table.remarks, builder: (column) => column);

  $$PartiesTableAnnotationComposer get karigarId {
    final $$PartiesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.karigarId,
      referencedTable: $db.parties,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PartiesTableAnnotationComposer(
            $db: $db,
            $table: $db.parties,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$KarigarTransactionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $KarigarTransactionsTable,
          KarigarTransaction,
          $$KarigarTransactionsTableFilterComposer,
          $$KarigarTransactionsTableOrderingComposer,
          $$KarigarTransactionsTableAnnotationComposer,
          $$KarigarTransactionsTableCreateCompanionBuilder,
          $$KarigarTransactionsTableUpdateCompanionBuilder,
          (KarigarTransaction, $$KarigarTransactionsTableReferences),
          KarigarTransaction,
          PrefetchHooks Function({bool karigarId})
        > {
  $$KarigarTransactionsTableTableManager(
    _$AppDatabase db,
    $KarigarTransactionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$KarigarTransactionsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer:
              () => $$KarigarTransactionsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $$KarigarTransactionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> voucherNumber = const Value.absent(),
                Value<int> karigarId = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<KarigarTxnType> type = const Value.absent(),
                Value<String> itemDescription = const Value.absent(),
                Value<int> quantity = const Value.absent(),
                Value<double> grossWeight = const Value.absent(),
                Value<double> purityPercent = const Value.absent(),
                Value<double> netWeight = const Value.absent(),
                Value<double?> estimatedValue = const Value.absent(),
                Value<String?> remarks = const Value.absent(),
              }) => KarigarTransactionsCompanion(
                id: id,
                voucherNumber: voucherNumber,
                karigarId: karigarId,
                date: date,
                type: type,
                itemDescription: itemDescription,
                quantity: quantity,
                grossWeight: grossWeight,
                purityPercent: purityPercent,
                netWeight: netWeight,
                estimatedValue: estimatedValue,
                remarks: remarks,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String voucherNumber,
                required int karigarId,
                required DateTime date,
                required KarigarTxnType type,
                required String itemDescription,
                Value<int> quantity = const Value.absent(),
                required double grossWeight,
                required double purityPercent,
                required double netWeight,
                Value<double?> estimatedValue = const Value.absent(),
                Value<String?> remarks = const Value.absent(),
              }) => KarigarTransactionsCompanion.insert(
                id: id,
                voucherNumber: voucherNumber,
                karigarId: karigarId,
                date: date,
                type: type,
                itemDescription: itemDescription,
                quantity: quantity,
                grossWeight: grossWeight,
                purityPercent: purityPercent,
                netWeight: netWeight,
                estimatedValue: estimatedValue,
                remarks: remarks,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$KarigarTransactionsTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({karigarId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                T extends TableManagerState<
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic
                >
              >(state) {
                if (karigarId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.karigarId,
                            referencedTable:
                                $$KarigarTransactionsTableReferences
                                    ._karigarIdTable(db),
                            referencedColumn:
                                $$KarigarTransactionsTableReferences
                                    ._karigarIdTable(db)
                                    .id,
                          )
                          as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$KarigarTransactionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $KarigarTransactionsTable,
      KarigarTransaction,
      $$KarigarTransactionsTableFilterComposer,
      $$KarigarTransactionsTableOrderingComposer,
      $$KarigarTransactionsTableAnnotationComposer,
      $$KarigarTransactionsTableCreateCompanionBuilder,
      $$KarigarTransactionsTableUpdateCompanionBuilder,
      (KarigarTransaction, $$KarigarTransactionsTableReferences),
      KarigarTransaction,
      PrefetchHooks Function({bool karigarId})
    >;
typedef $$GstVouchersTableCreateCompanionBuilder =
    GstVouchersCompanion Function({
      Value<int> id,
      required GstVoucherType voucherType,
      required PaymentTerm paymentTerm,
      required int partyId,
      Value<String?> bookSeries,
      required String billNumber,
      required DateTime date,
      Value<String?> hsnCode,
      required String description,
      required double taxSlabPercent,
      required double taxableAmount,
      required double cgstAmount,
      required double sgstAmount,
      required double totalAmount,
    });
typedef $$GstVouchersTableUpdateCompanionBuilder =
    GstVouchersCompanion Function({
      Value<int> id,
      Value<GstVoucherType> voucherType,
      Value<PaymentTerm> paymentTerm,
      Value<int> partyId,
      Value<String?> bookSeries,
      Value<String> billNumber,
      Value<DateTime> date,
      Value<String?> hsnCode,
      Value<String> description,
      Value<double> taxSlabPercent,
      Value<double> taxableAmount,
      Value<double> cgstAmount,
      Value<double> sgstAmount,
      Value<double> totalAmount,
    });

final class $$GstVouchersTableReferences
    extends BaseReferences<_$AppDatabase, $GstVouchersTable, GstVoucher> {
  $$GstVouchersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PartiesTable _partyIdTable(_$AppDatabase db) => db.parties
      .createAlias($_aliasNameGenerator(db.gstVouchers.partyId, db.parties.id));

  $$PartiesTableProcessedTableManager get partyId {
    final $_column = $_itemColumn<int>('party_id')!;

    final manager = $$PartiesTableTableManager(
      $_db,
      $_db.parties,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_partyIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$GstVouchersTableFilterComposer
    extends Composer<_$AppDatabase, $GstVouchersTable> {
  $$GstVouchersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<GstVoucherType, GstVoucherType, String>
  get voucherType => $composableBuilder(
    column: $table.voucherType,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<PaymentTerm, PaymentTerm, String>
  get paymentTerm => $composableBuilder(
    column: $table.paymentTerm,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get bookSeries => $composableBuilder(
    column: $table.bookSeries,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get billNumber => $composableBuilder(
    column: $table.billNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hsnCode => $composableBuilder(
    column: $table.hsnCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get taxSlabPercent => $composableBuilder(
    column: $table.taxSlabPercent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get taxableAmount => $composableBuilder(
    column: $table.taxableAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get cgstAmount => $composableBuilder(
    column: $table.cgstAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get sgstAmount => $composableBuilder(
    column: $table.sgstAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => ColumnFilters(column),
  );

  $$PartiesTableFilterComposer get partyId {
    final $$PartiesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.partyId,
      referencedTable: $db.parties,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PartiesTableFilterComposer(
            $db: $db,
            $table: $db.parties,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GstVouchersTableOrderingComposer
    extends Composer<_$AppDatabase, $GstVouchersTable> {
  $$GstVouchersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get voucherType => $composableBuilder(
    column: $table.voucherType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paymentTerm => $composableBuilder(
    column: $table.paymentTerm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bookSeries => $composableBuilder(
    column: $table.bookSeries,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get billNumber => $composableBuilder(
    column: $table.billNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hsnCode => $composableBuilder(
    column: $table.hsnCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get taxSlabPercent => $composableBuilder(
    column: $table.taxSlabPercent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get taxableAmount => $composableBuilder(
    column: $table.taxableAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get cgstAmount => $composableBuilder(
    column: $table.cgstAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get sgstAmount => $composableBuilder(
    column: $table.sgstAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => ColumnOrderings(column),
  );

  $$PartiesTableOrderingComposer get partyId {
    final $$PartiesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.partyId,
      referencedTable: $db.parties,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PartiesTableOrderingComposer(
            $db: $db,
            $table: $db.parties,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GstVouchersTableAnnotationComposer
    extends Composer<_$AppDatabase, $GstVouchersTable> {
  $$GstVouchersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<GstVoucherType, String> get voucherType =>
      $composableBuilder(
        column: $table.voucherType,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<PaymentTerm, String> get paymentTerm =>
      $composableBuilder(
        column: $table.paymentTerm,
        builder: (column) => column,
      );

  GeneratedColumn<String> get bookSeries => $composableBuilder(
    column: $table.bookSeries,
    builder: (column) => column,
  );

  GeneratedColumn<String> get billNumber => $composableBuilder(
    column: $table.billNumber,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get hsnCode =>
      $composableBuilder(column: $table.hsnCode, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<double> get taxSlabPercent => $composableBuilder(
    column: $table.taxSlabPercent,
    builder: (column) => column,
  );

  GeneratedColumn<double> get taxableAmount => $composableBuilder(
    column: $table.taxableAmount,
    builder: (column) => column,
  );

  GeneratedColumn<double> get cgstAmount => $composableBuilder(
    column: $table.cgstAmount,
    builder: (column) => column,
  );

  GeneratedColumn<double> get sgstAmount => $composableBuilder(
    column: $table.sgstAmount,
    builder: (column) => column,
  );

  GeneratedColumn<double> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => column,
  );

  $$PartiesTableAnnotationComposer get partyId {
    final $$PartiesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.partyId,
      referencedTable: $db.parties,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PartiesTableAnnotationComposer(
            $db: $db,
            $table: $db.parties,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GstVouchersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GstVouchersTable,
          GstVoucher,
          $$GstVouchersTableFilterComposer,
          $$GstVouchersTableOrderingComposer,
          $$GstVouchersTableAnnotationComposer,
          $$GstVouchersTableCreateCompanionBuilder,
          $$GstVouchersTableUpdateCompanionBuilder,
          (GstVoucher, $$GstVouchersTableReferences),
          GstVoucher,
          PrefetchHooks Function({bool partyId})
        > {
  $$GstVouchersTableTableManager(_$AppDatabase db, $GstVouchersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$GstVouchersTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$GstVouchersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () =>
                  $$GstVouchersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<GstVoucherType> voucherType = const Value.absent(),
                Value<PaymentTerm> paymentTerm = const Value.absent(),
                Value<int> partyId = const Value.absent(),
                Value<String?> bookSeries = const Value.absent(),
                Value<String> billNumber = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<String?> hsnCode = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<double> taxSlabPercent = const Value.absent(),
                Value<double> taxableAmount = const Value.absent(),
                Value<double> cgstAmount = const Value.absent(),
                Value<double> sgstAmount = const Value.absent(),
                Value<double> totalAmount = const Value.absent(),
              }) => GstVouchersCompanion(
                id: id,
                voucherType: voucherType,
                paymentTerm: paymentTerm,
                partyId: partyId,
                bookSeries: bookSeries,
                billNumber: billNumber,
                date: date,
                hsnCode: hsnCode,
                description: description,
                taxSlabPercent: taxSlabPercent,
                taxableAmount: taxableAmount,
                cgstAmount: cgstAmount,
                sgstAmount: sgstAmount,
                totalAmount: totalAmount,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required GstVoucherType voucherType,
                required PaymentTerm paymentTerm,
                required int partyId,
                Value<String?> bookSeries = const Value.absent(),
                required String billNumber,
                required DateTime date,
                Value<String?> hsnCode = const Value.absent(),
                required String description,
                required double taxSlabPercent,
                required double taxableAmount,
                required double cgstAmount,
                required double sgstAmount,
                required double totalAmount,
              }) => GstVouchersCompanion.insert(
                id: id,
                voucherType: voucherType,
                paymentTerm: paymentTerm,
                partyId: partyId,
                bookSeries: bookSeries,
                billNumber: billNumber,
                date: date,
                hsnCode: hsnCode,
                description: description,
                taxSlabPercent: taxSlabPercent,
                taxableAmount: taxableAmount,
                cgstAmount: cgstAmount,
                sgstAmount: sgstAmount,
                totalAmount: totalAmount,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$GstVouchersTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({partyId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                T extends TableManagerState<
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic
                >
              >(state) {
                if (partyId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.partyId,
                            referencedTable: $$GstVouchersTableReferences
                                ._partyIdTable(db),
                            referencedColumn:
                                $$GstVouchersTableReferences
                                    ._partyIdTable(db)
                                    .id,
                          )
                          as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$GstVouchersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GstVouchersTable,
      GstVoucher,
      $$GstVouchersTableFilterComposer,
      $$GstVouchersTableOrderingComposer,
      $$GstVouchersTableAnnotationComposer,
      $$GstVouchersTableCreateCompanionBuilder,
      $$GstVouchersTableUpdateCompanionBuilder,
      (GstVoucher, $$GstVouchersTableReferences),
      GstVoucher,
      PrefetchHooks Function({bool partyId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$DailyRatesTableTableManager get dailyRates =>
      $$DailyRatesTableTableManager(_db, _db.dailyRates);
  $$PartiesTableTableManager get parties =>
      $$PartiesTableTableManager(_db, _db.parties);
  $$GirviLoansTableTableManager get girviLoans =>
      $$GirviLoansTableTableManager(_db, _db.girviLoans);
  $$LoanReceiptsTableTableManager get loanReceipts =>
      $$LoanReceiptsTableTableManager(_db, _db.loanReceipts);
  $$KarigarTransactionsTableTableManager get karigarTransactions =>
      $$KarigarTransactionsTableTableManager(_db, _db.karigarTransactions);
  $$GstVouchersTableTableManager get gstVouchers =>
      $$GstVouchersTableTableManager(_db, _db.gstVouchers);
}
