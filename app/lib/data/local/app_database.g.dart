// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $CardMetaTable extends CardMeta
    with TableInfo<$CardMetaTable, CardMetaData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CardMetaTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bankCodeMeta = const VerificationMeta(
    'bankCode',
  );
  @override
  late final GeneratedColumn<String> bankCode = GeneratedColumn<String>(
    'bank_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bankNameMeta = const VerificationMeta(
    'bankName',
  );
  @override
  late final GeneratedColumn<String> bankName = GeneratedColumn<String>(
    'bank_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cardTypeMeta = const VerificationMeta(
    'cardType',
  );
  @override
  late final GeneratedColumn<String> cardType = GeneratedColumn<String>(
    'card_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nicknameMeta = const VerificationMeta(
    'nickname',
  );
  @override
  late final GeneratedColumn<String> nickname = GeneratedColumn<String>(
    'nickname',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _last4Meta = const VerificationMeta('last4');
  @override
  late final GeneratedColumn<String> last4 = GeneratedColumn<String>(
    'last4',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _faceIdMeta = const VerificationMeta('faceId');
  @override
  late final GeneratedColumn<String> faceId = GeneratedColumn<String>(
    'face_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _customFaceMeta = const VerificationMeta(
    'customFace',
  );
  @override
  late final GeneratedColumn<String> customFace = GeneratedColumn<String>(
    'custom_face',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _balanceMeta = const VerificationMeta(
    'balance',
  );
  @override
  late final GeneratedColumn<double> balance = GeneratedColumn<double>(
    'balance',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('¥'),
  );
  static const VerificationMeta _balanceUpdatedAtMeta = const VerificationMeta(
    'balanceUpdatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> balanceUpdatedAt =
      GeneratedColumn<DateTime>(
        'balance_updated_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _orderIndexMeta = const VerificationMeta(
    'orderIndex',
  );
  @override
  late final GeneratedColumn<int> orderIndex = GeneratedColumn<int>(
    'order_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
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
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    bankCode,
    bankName,
    cardType,
    nickname,
    last4,
    faceId,
    customFace,
    balance,
    currency,
    balanceUpdatedAt,
    notes,
    orderIndex,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'card_meta';
  @override
  VerificationContext validateIntegrity(
    Insertable<CardMetaData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('bank_code')) {
      context.handle(
        _bankCodeMeta,
        bankCode.isAcceptableOrUnknown(data['bank_code']!, _bankCodeMeta),
      );
    } else if (isInserting) {
      context.missing(_bankCodeMeta);
    }
    if (data.containsKey('bank_name')) {
      context.handle(
        _bankNameMeta,
        bankName.isAcceptableOrUnknown(data['bank_name']!, _bankNameMeta),
      );
    } else if (isInserting) {
      context.missing(_bankNameMeta);
    }
    if (data.containsKey('card_type')) {
      context.handle(
        _cardTypeMeta,
        cardType.isAcceptableOrUnknown(data['card_type']!, _cardTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_cardTypeMeta);
    }
    if (data.containsKey('nickname')) {
      context.handle(
        _nicknameMeta,
        nickname.isAcceptableOrUnknown(data['nickname']!, _nicknameMeta),
      );
    }
    if (data.containsKey('last4')) {
      context.handle(
        _last4Meta,
        last4.isAcceptableOrUnknown(data['last4']!, _last4Meta),
      );
    }
    if (data.containsKey('face_id')) {
      context.handle(
        _faceIdMeta,
        faceId.isAcceptableOrUnknown(data['face_id']!, _faceIdMeta),
      );
    }
    if (data.containsKey('custom_face')) {
      context.handle(
        _customFaceMeta,
        customFace.isAcceptableOrUnknown(data['custom_face']!, _customFaceMeta),
      );
    }
    if (data.containsKey('balance')) {
      context.handle(
        _balanceMeta,
        balance.isAcceptableOrUnknown(data['balance']!, _balanceMeta),
      );
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    }
    if (data.containsKey('balance_updated_at')) {
      context.handle(
        _balanceUpdatedAtMeta,
        balanceUpdatedAt.isAcceptableOrUnknown(
          data['balance_updated_at']!,
          _balanceUpdatedAtMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('order_index')) {
      context.handle(
        _orderIndexMeta,
        orderIndex.isAcceptableOrUnknown(data['order_index']!, _orderIndexMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CardMetaData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CardMetaData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      bankCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bank_code'],
      )!,
      bankName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bank_name'],
      )!,
      cardType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}card_type'],
      )!,
      nickname: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nickname'],
      ),
      last4: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last4'],
      ),
      faceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}face_id'],
      ),
      customFace: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}custom_face'],
      ),
      balance: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}balance'],
      ),
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      balanceUpdatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}balance_updated_at'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      orderIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order_index'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $CardMetaTable createAlias(String alias) {
    return $CardMetaTable(attachedDatabase, alias);
  }
}

class CardMetaData extends DataClass implements Insertable<CardMetaData> {
  final String id;
  final String bankCode;
  final String bankName;
  final String cardType;
  final String? nickname;
  final String? last4;
  final String? faceId;
  final String? customFace;
  final double? balance;
  final String currency;
  final DateTime? balanceUpdatedAt;
  final String? notes;
  final int orderIndex;
  final DateTime createdAt;
  final DateTime updatedAt;
  const CardMetaData({
    required this.id,
    required this.bankCode,
    required this.bankName,
    required this.cardType,
    this.nickname,
    this.last4,
    this.faceId,
    this.customFace,
    this.balance,
    required this.currency,
    this.balanceUpdatedAt,
    this.notes,
    required this.orderIndex,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['bank_code'] = Variable<String>(bankCode);
    map['bank_name'] = Variable<String>(bankName);
    map['card_type'] = Variable<String>(cardType);
    if (!nullToAbsent || nickname != null) {
      map['nickname'] = Variable<String>(nickname);
    }
    if (!nullToAbsent || last4 != null) {
      map['last4'] = Variable<String>(last4);
    }
    if (!nullToAbsent || faceId != null) {
      map['face_id'] = Variable<String>(faceId);
    }
    if (!nullToAbsent || customFace != null) {
      map['custom_face'] = Variable<String>(customFace);
    }
    if (!nullToAbsent || balance != null) {
      map['balance'] = Variable<double>(balance);
    }
    map['currency'] = Variable<String>(currency);
    if (!nullToAbsent || balanceUpdatedAt != null) {
      map['balance_updated_at'] = Variable<DateTime>(balanceUpdatedAt);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['order_index'] = Variable<int>(orderIndex);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  CardMetaCompanion toCompanion(bool nullToAbsent) {
    return CardMetaCompanion(
      id: Value(id),
      bankCode: Value(bankCode),
      bankName: Value(bankName),
      cardType: Value(cardType),
      nickname: nickname == null && nullToAbsent
          ? const Value.absent()
          : Value(nickname),
      last4: last4 == null && nullToAbsent
          ? const Value.absent()
          : Value(last4),
      faceId: faceId == null && nullToAbsent
          ? const Value.absent()
          : Value(faceId),
      customFace: customFace == null && nullToAbsent
          ? const Value.absent()
          : Value(customFace),
      balance: balance == null && nullToAbsent
          ? const Value.absent()
          : Value(balance),
      currency: Value(currency),
      balanceUpdatedAt: balanceUpdatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(balanceUpdatedAt),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      orderIndex: Value(orderIndex),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory CardMetaData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CardMetaData(
      id: serializer.fromJson<String>(json['id']),
      bankCode: serializer.fromJson<String>(json['bankCode']),
      bankName: serializer.fromJson<String>(json['bankName']),
      cardType: serializer.fromJson<String>(json['cardType']),
      nickname: serializer.fromJson<String?>(json['nickname']),
      last4: serializer.fromJson<String?>(json['last4']),
      faceId: serializer.fromJson<String?>(json['faceId']),
      customFace: serializer.fromJson<String?>(json['customFace']),
      balance: serializer.fromJson<double?>(json['balance']),
      currency: serializer.fromJson<String>(json['currency']),
      balanceUpdatedAt: serializer.fromJson<DateTime?>(
        json['balanceUpdatedAt'],
      ),
      notes: serializer.fromJson<String?>(json['notes']),
      orderIndex: serializer.fromJson<int>(json['orderIndex']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'bankCode': serializer.toJson<String>(bankCode),
      'bankName': serializer.toJson<String>(bankName),
      'cardType': serializer.toJson<String>(cardType),
      'nickname': serializer.toJson<String?>(nickname),
      'last4': serializer.toJson<String?>(last4),
      'faceId': serializer.toJson<String?>(faceId),
      'customFace': serializer.toJson<String?>(customFace),
      'balance': serializer.toJson<double?>(balance),
      'currency': serializer.toJson<String>(currency),
      'balanceUpdatedAt': serializer.toJson<DateTime?>(balanceUpdatedAt),
      'notes': serializer.toJson<String?>(notes),
      'orderIndex': serializer.toJson<int>(orderIndex),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  CardMetaData copyWith({
    String? id,
    String? bankCode,
    String? bankName,
    String? cardType,
    Value<String?> nickname = const Value.absent(),
    Value<String?> last4 = const Value.absent(),
    Value<String?> faceId = const Value.absent(),
    Value<String?> customFace = const Value.absent(),
    Value<double?> balance = const Value.absent(),
    String? currency,
    Value<DateTime?> balanceUpdatedAt = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    int? orderIndex,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => CardMetaData(
    id: id ?? this.id,
    bankCode: bankCode ?? this.bankCode,
    bankName: bankName ?? this.bankName,
    cardType: cardType ?? this.cardType,
    nickname: nickname.present ? nickname.value : this.nickname,
    last4: last4.present ? last4.value : this.last4,
    faceId: faceId.present ? faceId.value : this.faceId,
    customFace: customFace.present ? customFace.value : this.customFace,
    balance: balance.present ? balance.value : this.balance,
    currency: currency ?? this.currency,
    balanceUpdatedAt: balanceUpdatedAt.present
        ? balanceUpdatedAt.value
        : this.balanceUpdatedAt,
    notes: notes.present ? notes.value : this.notes,
    orderIndex: orderIndex ?? this.orderIndex,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  CardMetaData copyWithCompanion(CardMetaCompanion data) {
    return CardMetaData(
      id: data.id.present ? data.id.value : this.id,
      bankCode: data.bankCode.present ? data.bankCode.value : this.bankCode,
      bankName: data.bankName.present ? data.bankName.value : this.bankName,
      cardType: data.cardType.present ? data.cardType.value : this.cardType,
      nickname: data.nickname.present ? data.nickname.value : this.nickname,
      last4: data.last4.present ? data.last4.value : this.last4,
      faceId: data.faceId.present ? data.faceId.value : this.faceId,
      customFace: data.customFace.present
          ? data.customFace.value
          : this.customFace,
      balance: data.balance.present ? data.balance.value : this.balance,
      currency: data.currency.present ? data.currency.value : this.currency,
      balanceUpdatedAt: data.balanceUpdatedAt.present
          ? data.balanceUpdatedAt.value
          : this.balanceUpdatedAt,
      notes: data.notes.present ? data.notes.value : this.notes,
      orderIndex: data.orderIndex.present
          ? data.orderIndex.value
          : this.orderIndex,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CardMetaData(')
          ..write('id: $id, ')
          ..write('bankCode: $bankCode, ')
          ..write('bankName: $bankName, ')
          ..write('cardType: $cardType, ')
          ..write('nickname: $nickname, ')
          ..write('last4: $last4, ')
          ..write('faceId: $faceId, ')
          ..write('customFace: $customFace, ')
          ..write('balance: $balance, ')
          ..write('currency: $currency, ')
          ..write('balanceUpdatedAt: $balanceUpdatedAt, ')
          ..write('notes: $notes, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    bankCode,
    bankName,
    cardType,
    nickname,
    last4,
    faceId,
    customFace,
    balance,
    currency,
    balanceUpdatedAt,
    notes,
    orderIndex,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CardMetaData &&
          other.id == this.id &&
          other.bankCode == this.bankCode &&
          other.bankName == this.bankName &&
          other.cardType == this.cardType &&
          other.nickname == this.nickname &&
          other.last4 == this.last4 &&
          other.faceId == this.faceId &&
          other.customFace == this.customFace &&
          other.balance == this.balance &&
          other.currency == this.currency &&
          other.balanceUpdatedAt == this.balanceUpdatedAt &&
          other.notes == this.notes &&
          other.orderIndex == this.orderIndex &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class CardMetaCompanion extends UpdateCompanion<CardMetaData> {
  final Value<String> id;
  final Value<String> bankCode;
  final Value<String> bankName;
  final Value<String> cardType;
  final Value<String?> nickname;
  final Value<String?> last4;
  final Value<String?> faceId;
  final Value<String?> customFace;
  final Value<double?> balance;
  final Value<String> currency;
  final Value<DateTime?> balanceUpdatedAt;
  final Value<String?> notes;
  final Value<int> orderIndex;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const CardMetaCompanion({
    this.id = const Value.absent(),
    this.bankCode = const Value.absent(),
    this.bankName = const Value.absent(),
    this.cardType = const Value.absent(),
    this.nickname = const Value.absent(),
    this.last4 = const Value.absent(),
    this.faceId = const Value.absent(),
    this.customFace = const Value.absent(),
    this.balance = const Value.absent(),
    this.currency = const Value.absent(),
    this.balanceUpdatedAt = const Value.absent(),
    this.notes = const Value.absent(),
    this.orderIndex = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CardMetaCompanion.insert({
    required String id,
    required String bankCode,
    required String bankName,
    required String cardType,
    this.nickname = const Value.absent(),
    this.last4 = const Value.absent(),
    this.faceId = const Value.absent(),
    this.customFace = const Value.absent(),
    this.balance = const Value.absent(),
    this.currency = const Value.absent(),
    this.balanceUpdatedAt = const Value.absent(),
    this.notes = const Value.absent(),
    this.orderIndex = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       bankCode = Value(bankCode),
       bankName = Value(bankName),
       cardType = Value(cardType),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<CardMetaData> custom({
    Expression<String>? id,
    Expression<String>? bankCode,
    Expression<String>? bankName,
    Expression<String>? cardType,
    Expression<String>? nickname,
    Expression<String>? last4,
    Expression<String>? faceId,
    Expression<String>? customFace,
    Expression<double>? balance,
    Expression<String>? currency,
    Expression<DateTime>? balanceUpdatedAt,
    Expression<String>? notes,
    Expression<int>? orderIndex,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (bankCode != null) 'bank_code': bankCode,
      if (bankName != null) 'bank_name': bankName,
      if (cardType != null) 'card_type': cardType,
      if (nickname != null) 'nickname': nickname,
      if (last4 != null) 'last4': last4,
      if (faceId != null) 'face_id': faceId,
      if (customFace != null) 'custom_face': customFace,
      if (balance != null) 'balance': balance,
      if (currency != null) 'currency': currency,
      if (balanceUpdatedAt != null) 'balance_updated_at': balanceUpdatedAt,
      if (notes != null) 'notes': notes,
      if (orderIndex != null) 'order_index': orderIndex,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CardMetaCompanion copyWith({
    Value<String>? id,
    Value<String>? bankCode,
    Value<String>? bankName,
    Value<String>? cardType,
    Value<String?>? nickname,
    Value<String?>? last4,
    Value<String?>? faceId,
    Value<String?>? customFace,
    Value<double?>? balance,
    Value<String>? currency,
    Value<DateTime?>? balanceUpdatedAt,
    Value<String?>? notes,
    Value<int>? orderIndex,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return CardMetaCompanion(
      id: id ?? this.id,
      bankCode: bankCode ?? this.bankCode,
      bankName: bankName ?? this.bankName,
      cardType: cardType ?? this.cardType,
      nickname: nickname ?? this.nickname,
      last4: last4 ?? this.last4,
      faceId: faceId ?? this.faceId,
      customFace: customFace ?? this.customFace,
      balance: balance ?? this.balance,
      currency: currency ?? this.currency,
      balanceUpdatedAt: balanceUpdatedAt ?? this.balanceUpdatedAt,
      notes: notes ?? this.notes,
      orderIndex: orderIndex ?? this.orderIndex,
      createdAt: createdAt ?? this.createdAt,
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
    if (bankCode.present) {
      map['bank_code'] = Variable<String>(bankCode.value);
    }
    if (bankName.present) {
      map['bank_name'] = Variable<String>(bankName.value);
    }
    if (cardType.present) {
      map['card_type'] = Variable<String>(cardType.value);
    }
    if (nickname.present) {
      map['nickname'] = Variable<String>(nickname.value);
    }
    if (last4.present) {
      map['last4'] = Variable<String>(last4.value);
    }
    if (faceId.present) {
      map['face_id'] = Variable<String>(faceId.value);
    }
    if (customFace.present) {
      map['custom_face'] = Variable<String>(customFace.value);
    }
    if (balance.present) {
      map['balance'] = Variable<double>(balance.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (balanceUpdatedAt.present) {
      map['balance_updated_at'] = Variable<DateTime>(balanceUpdatedAt.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (orderIndex.present) {
      map['order_index'] = Variable<int>(orderIndex.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CardMetaCompanion(')
          ..write('id: $id, ')
          ..write('bankCode: $bankCode, ')
          ..write('bankName: $bankName, ')
          ..write('cardType: $cardType, ')
          ..write('nickname: $nickname, ')
          ..write('last4: $last4, ')
          ..write('faceId: $faceId, ')
          ..write('customFace: $customFace, ')
          ..write('balance: $balance, ')
          ..write('currency: $currency, ')
          ..write('balanceUpdatedAt: $balanceUpdatedAt, ')
          ..write('notes: $notes, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CardFaceCacheTable extends CardFaceCache
    with TableInfo<$CardFaceCacheTable, CardFaceCacheData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CardFaceCacheTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _faceIdMeta = const VerificationMeta('faceId');
  @override
  late final GeneratedColumn<String> faceId = GeneratedColumn<String>(
    'face_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bankCodeMeta = const VerificationMeta(
    'bankCode',
  );
  @override
  late final GeneratedColumn<String> bankCode = GeneratedColumn<String>(
    'bank_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bankNameMeta = const VerificationMeta(
    'bankName',
  );
  @override
  late final GeneratedColumn<String> bankName = GeneratedColumn<String>(
    'bank_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cardTypesMeta = const VerificationMeta(
    'cardTypes',
  );
  @override
  late final GeneratedColumn<String> cardTypes = GeneratedColumn<String>(
    'card_types',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _assetTypeMeta = const VerificationMeta(
    'assetType',
  );
  @override
  late final GeneratedColumn<String> assetType = GeneratedColumn<String>(
    'asset_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _imageUrlMeta = const VerificationMeta(
    'imageUrl',
  );
  @override
  late final GeneratedColumn<String> imageUrl = GeneratedColumn<String>(
    'image_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _assetKeyMeta = const VerificationMeta(
    'assetKey',
  );
  @override
  late final GeneratedColumn<String> assetKey = GeneratedColumn<String>(
    'asset_key',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _colorsMeta = const VerificationMeta('colors');
  @override
  late final GeneratedColumn<String> colors = GeneratedColumn<String>(
    'colors',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _logoTextMeta = const VerificationMeta(
    'logoText',
  );
  @override
  late final GeneratedColumn<String> logoText = GeneratedColumn<String>(
    'logo_text',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _foregroundMeta = const VerificationMeta(
    'foreground',
  );
  @override
  late final GeneratedColumn<String> foreground = GeneratedColumn<String>(
    'foreground',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _manifestVersionMeta = const VerificationMeta(
    'manifestVersion',
  );
  @override
  late final GeneratedColumn<int> manifestVersion = GeneratedColumn<int>(
    'manifest_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    faceId,
    bankCode,
    bankName,
    cardTypes,
    assetType,
    imageUrl,
    assetKey,
    colors,
    logoText,
    foreground,
    version,
    manifestVersion,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'card_face_cache';
  @override
  VerificationContext validateIntegrity(
    Insertable<CardFaceCacheData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('face_id')) {
      context.handle(
        _faceIdMeta,
        faceId.isAcceptableOrUnknown(data['face_id']!, _faceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_faceIdMeta);
    }
    if (data.containsKey('bank_code')) {
      context.handle(
        _bankCodeMeta,
        bankCode.isAcceptableOrUnknown(data['bank_code']!, _bankCodeMeta),
      );
    } else if (isInserting) {
      context.missing(_bankCodeMeta);
    }
    if (data.containsKey('bank_name')) {
      context.handle(
        _bankNameMeta,
        bankName.isAcceptableOrUnknown(data['bank_name']!, _bankNameMeta),
      );
    } else if (isInserting) {
      context.missing(_bankNameMeta);
    }
    if (data.containsKey('card_types')) {
      context.handle(
        _cardTypesMeta,
        cardTypes.isAcceptableOrUnknown(data['card_types']!, _cardTypesMeta),
      );
    } else if (isInserting) {
      context.missing(_cardTypesMeta);
    }
    if (data.containsKey('asset_type')) {
      context.handle(
        _assetTypeMeta,
        assetType.isAcceptableOrUnknown(data['asset_type']!, _assetTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_assetTypeMeta);
    }
    if (data.containsKey('image_url')) {
      context.handle(
        _imageUrlMeta,
        imageUrl.isAcceptableOrUnknown(data['image_url']!, _imageUrlMeta),
      );
    }
    if (data.containsKey('asset_key')) {
      context.handle(
        _assetKeyMeta,
        assetKey.isAcceptableOrUnknown(data['asset_key']!, _assetKeyMeta),
      );
    }
    if (data.containsKey('colors')) {
      context.handle(
        _colorsMeta,
        colors.isAcceptableOrUnknown(data['colors']!, _colorsMeta),
      );
    }
    if (data.containsKey('logo_text')) {
      context.handle(
        _logoTextMeta,
        logoText.isAcceptableOrUnknown(data['logo_text']!, _logoTextMeta),
      );
    }
    if (data.containsKey('foreground')) {
      context.handle(
        _foregroundMeta,
        foreground.isAcceptableOrUnknown(data['foreground']!, _foregroundMeta),
      );
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    } else if (isInserting) {
      context.missing(_versionMeta);
    }
    if (data.containsKey('manifest_version')) {
      context.handle(
        _manifestVersionMeta,
        manifestVersion.isAcceptableOrUnknown(
          data['manifest_version']!,
          _manifestVersionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_manifestVersionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {faceId};
  @override
  CardFaceCacheData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CardFaceCacheData(
      faceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}face_id'],
      )!,
      bankCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bank_code'],
      )!,
      bankName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bank_name'],
      )!,
      cardTypes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}card_types'],
      )!,
      assetType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}asset_type'],
      )!,
      imageUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_url'],
      ),
      assetKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}asset_key'],
      ),
      colors: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}colors'],
      ),
      logoText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}logo_text'],
      ),
      foreground: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}foreground'],
      ),
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      manifestVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}manifest_version'],
      )!,
    );
  }

  @override
  $CardFaceCacheTable createAlias(String alias) {
    return $CardFaceCacheTable(attachedDatabase, alias);
  }
}

class CardFaceCacheData extends DataClass
    implements Insertable<CardFaceCacheData> {
  final String faceId;
  final String bankCode;
  final String bankName;
  final String cardTypes;
  final String assetType;
  final String? imageUrl;
  final String? assetKey;
  final String? colors;
  final String? logoText;
  final String? foreground;
  final int version;
  final int manifestVersion;
  const CardFaceCacheData({
    required this.faceId,
    required this.bankCode,
    required this.bankName,
    required this.cardTypes,
    required this.assetType,
    this.imageUrl,
    this.assetKey,
    this.colors,
    this.logoText,
    this.foreground,
    required this.version,
    required this.manifestVersion,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['face_id'] = Variable<String>(faceId);
    map['bank_code'] = Variable<String>(bankCode);
    map['bank_name'] = Variable<String>(bankName);
    map['card_types'] = Variable<String>(cardTypes);
    map['asset_type'] = Variable<String>(assetType);
    if (!nullToAbsent || imageUrl != null) {
      map['image_url'] = Variable<String>(imageUrl);
    }
    if (!nullToAbsent || assetKey != null) {
      map['asset_key'] = Variable<String>(assetKey);
    }
    if (!nullToAbsent || colors != null) {
      map['colors'] = Variable<String>(colors);
    }
    if (!nullToAbsent || logoText != null) {
      map['logo_text'] = Variable<String>(logoText);
    }
    if (!nullToAbsent || foreground != null) {
      map['foreground'] = Variable<String>(foreground);
    }
    map['version'] = Variable<int>(version);
    map['manifest_version'] = Variable<int>(manifestVersion);
    return map;
  }

  CardFaceCacheCompanion toCompanion(bool nullToAbsent) {
    return CardFaceCacheCompanion(
      faceId: Value(faceId),
      bankCode: Value(bankCode),
      bankName: Value(bankName),
      cardTypes: Value(cardTypes),
      assetType: Value(assetType),
      imageUrl: imageUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(imageUrl),
      assetKey: assetKey == null && nullToAbsent
          ? const Value.absent()
          : Value(assetKey),
      colors: colors == null && nullToAbsent
          ? const Value.absent()
          : Value(colors),
      logoText: logoText == null && nullToAbsent
          ? const Value.absent()
          : Value(logoText),
      foreground: foreground == null && nullToAbsent
          ? const Value.absent()
          : Value(foreground),
      version: Value(version),
      manifestVersion: Value(manifestVersion),
    );
  }

  factory CardFaceCacheData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CardFaceCacheData(
      faceId: serializer.fromJson<String>(json['faceId']),
      bankCode: serializer.fromJson<String>(json['bankCode']),
      bankName: serializer.fromJson<String>(json['bankName']),
      cardTypes: serializer.fromJson<String>(json['cardTypes']),
      assetType: serializer.fromJson<String>(json['assetType']),
      imageUrl: serializer.fromJson<String?>(json['imageUrl']),
      assetKey: serializer.fromJson<String?>(json['assetKey']),
      colors: serializer.fromJson<String?>(json['colors']),
      logoText: serializer.fromJson<String?>(json['logoText']),
      foreground: serializer.fromJson<String?>(json['foreground']),
      version: serializer.fromJson<int>(json['version']),
      manifestVersion: serializer.fromJson<int>(json['manifestVersion']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'faceId': serializer.toJson<String>(faceId),
      'bankCode': serializer.toJson<String>(bankCode),
      'bankName': serializer.toJson<String>(bankName),
      'cardTypes': serializer.toJson<String>(cardTypes),
      'assetType': serializer.toJson<String>(assetType),
      'imageUrl': serializer.toJson<String?>(imageUrl),
      'assetKey': serializer.toJson<String?>(assetKey),
      'colors': serializer.toJson<String?>(colors),
      'logoText': serializer.toJson<String?>(logoText),
      'foreground': serializer.toJson<String?>(foreground),
      'version': serializer.toJson<int>(version),
      'manifestVersion': serializer.toJson<int>(manifestVersion),
    };
  }

  CardFaceCacheData copyWith({
    String? faceId,
    String? bankCode,
    String? bankName,
    String? cardTypes,
    String? assetType,
    Value<String?> imageUrl = const Value.absent(),
    Value<String?> assetKey = const Value.absent(),
    Value<String?> colors = const Value.absent(),
    Value<String?> logoText = const Value.absent(),
    Value<String?> foreground = const Value.absent(),
    int? version,
    int? manifestVersion,
  }) => CardFaceCacheData(
    faceId: faceId ?? this.faceId,
    bankCode: bankCode ?? this.bankCode,
    bankName: bankName ?? this.bankName,
    cardTypes: cardTypes ?? this.cardTypes,
    assetType: assetType ?? this.assetType,
    imageUrl: imageUrl.present ? imageUrl.value : this.imageUrl,
    assetKey: assetKey.present ? assetKey.value : this.assetKey,
    colors: colors.present ? colors.value : this.colors,
    logoText: logoText.present ? logoText.value : this.logoText,
    foreground: foreground.present ? foreground.value : this.foreground,
    version: version ?? this.version,
    manifestVersion: manifestVersion ?? this.manifestVersion,
  );
  CardFaceCacheData copyWithCompanion(CardFaceCacheCompanion data) {
    return CardFaceCacheData(
      faceId: data.faceId.present ? data.faceId.value : this.faceId,
      bankCode: data.bankCode.present ? data.bankCode.value : this.bankCode,
      bankName: data.bankName.present ? data.bankName.value : this.bankName,
      cardTypes: data.cardTypes.present ? data.cardTypes.value : this.cardTypes,
      assetType: data.assetType.present ? data.assetType.value : this.assetType,
      imageUrl: data.imageUrl.present ? data.imageUrl.value : this.imageUrl,
      assetKey: data.assetKey.present ? data.assetKey.value : this.assetKey,
      colors: data.colors.present ? data.colors.value : this.colors,
      logoText: data.logoText.present ? data.logoText.value : this.logoText,
      foreground: data.foreground.present
          ? data.foreground.value
          : this.foreground,
      version: data.version.present ? data.version.value : this.version,
      manifestVersion: data.manifestVersion.present
          ? data.manifestVersion.value
          : this.manifestVersion,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CardFaceCacheData(')
          ..write('faceId: $faceId, ')
          ..write('bankCode: $bankCode, ')
          ..write('bankName: $bankName, ')
          ..write('cardTypes: $cardTypes, ')
          ..write('assetType: $assetType, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('assetKey: $assetKey, ')
          ..write('colors: $colors, ')
          ..write('logoText: $logoText, ')
          ..write('foreground: $foreground, ')
          ..write('version: $version, ')
          ..write('manifestVersion: $manifestVersion')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    faceId,
    bankCode,
    bankName,
    cardTypes,
    assetType,
    imageUrl,
    assetKey,
    colors,
    logoText,
    foreground,
    version,
    manifestVersion,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CardFaceCacheData &&
          other.faceId == this.faceId &&
          other.bankCode == this.bankCode &&
          other.bankName == this.bankName &&
          other.cardTypes == this.cardTypes &&
          other.assetType == this.assetType &&
          other.imageUrl == this.imageUrl &&
          other.assetKey == this.assetKey &&
          other.colors == this.colors &&
          other.logoText == this.logoText &&
          other.foreground == this.foreground &&
          other.version == this.version &&
          other.manifestVersion == this.manifestVersion);
}

class CardFaceCacheCompanion extends UpdateCompanion<CardFaceCacheData> {
  final Value<String> faceId;
  final Value<String> bankCode;
  final Value<String> bankName;
  final Value<String> cardTypes;
  final Value<String> assetType;
  final Value<String?> imageUrl;
  final Value<String?> assetKey;
  final Value<String?> colors;
  final Value<String?> logoText;
  final Value<String?> foreground;
  final Value<int> version;
  final Value<int> manifestVersion;
  final Value<int> rowid;
  const CardFaceCacheCompanion({
    this.faceId = const Value.absent(),
    this.bankCode = const Value.absent(),
    this.bankName = const Value.absent(),
    this.cardTypes = const Value.absent(),
    this.assetType = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.assetKey = const Value.absent(),
    this.colors = const Value.absent(),
    this.logoText = const Value.absent(),
    this.foreground = const Value.absent(),
    this.version = const Value.absent(),
    this.manifestVersion = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CardFaceCacheCompanion.insert({
    required String faceId,
    required String bankCode,
    required String bankName,
    required String cardTypes,
    required String assetType,
    this.imageUrl = const Value.absent(),
    this.assetKey = const Value.absent(),
    this.colors = const Value.absent(),
    this.logoText = const Value.absent(),
    this.foreground = const Value.absent(),
    required int version,
    required int manifestVersion,
    this.rowid = const Value.absent(),
  }) : faceId = Value(faceId),
       bankCode = Value(bankCode),
       bankName = Value(bankName),
       cardTypes = Value(cardTypes),
       assetType = Value(assetType),
       version = Value(version),
       manifestVersion = Value(manifestVersion);
  static Insertable<CardFaceCacheData> custom({
    Expression<String>? faceId,
    Expression<String>? bankCode,
    Expression<String>? bankName,
    Expression<String>? cardTypes,
    Expression<String>? assetType,
    Expression<String>? imageUrl,
    Expression<String>? assetKey,
    Expression<String>? colors,
    Expression<String>? logoText,
    Expression<String>? foreground,
    Expression<int>? version,
    Expression<int>? manifestVersion,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (faceId != null) 'face_id': faceId,
      if (bankCode != null) 'bank_code': bankCode,
      if (bankName != null) 'bank_name': bankName,
      if (cardTypes != null) 'card_types': cardTypes,
      if (assetType != null) 'asset_type': assetType,
      if (imageUrl != null) 'image_url': imageUrl,
      if (assetKey != null) 'asset_key': assetKey,
      if (colors != null) 'colors': colors,
      if (logoText != null) 'logo_text': logoText,
      if (foreground != null) 'foreground': foreground,
      if (version != null) 'version': version,
      if (manifestVersion != null) 'manifest_version': manifestVersion,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CardFaceCacheCompanion copyWith({
    Value<String>? faceId,
    Value<String>? bankCode,
    Value<String>? bankName,
    Value<String>? cardTypes,
    Value<String>? assetType,
    Value<String?>? imageUrl,
    Value<String?>? assetKey,
    Value<String?>? colors,
    Value<String?>? logoText,
    Value<String?>? foreground,
    Value<int>? version,
    Value<int>? manifestVersion,
    Value<int>? rowid,
  }) {
    return CardFaceCacheCompanion(
      faceId: faceId ?? this.faceId,
      bankCode: bankCode ?? this.bankCode,
      bankName: bankName ?? this.bankName,
      cardTypes: cardTypes ?? this.cardTypes,
      assetType: assetType ?? this.assetType,
      imageUrl: imageUrl ?? this.imageUrl,
      assetKey: assetKey ?? this.assetKey,
      colors: colors ?? this.colors,
      logoText: logoText ?? this.logoText,
      foreground: foreground ?? this.foreground,
      version: version ?? this.version,
      manifestVersion: manifestVersion ?? this.manifestVersion,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (faceId.present) {
      map['face_id'] = Variable<String>(faceId.value);
    }
    if (bankCode.present) {
      map['bank_code'] = Variable<String>(bankCode.value);
    }
    if (bankName.present) {
      map['bank_name'] = Variable<String>(bankName.value);
    }
    if (cardTypes.present) {
      map['card_types'] = Variable<String>(cardTypes.value);
    }
    if (assetType.present) {
      map['asset_type'] = Variable<String>(assetType.value);
    }
    if (imageUrl.present) {
      map['image_url'] = Variable<String>(imageUrl.value);
    }
    if (assetKey.present) {
      map['asset_key'] = Variable<String>(assetKey.value);
    }
    if (colors.present) {
      map['colors'] = Variable<String>(colors.value);
    }
    if (logoText.present) {
      map['logo_text'] = Variable<String>(logoText.value);
    }
    if (foreground.present) {
      map['foreground'] = Variable<String>(foreground.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (manifestVersion.present) {
      map['manifest_version'] = Variable<int>(manifestVersion.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CardFaceCacheCompanion(')
          ..write('faceId: $faceId, ')
          ..write('bankCode: $bankCode, ')
          ..write('bankName: $bankName, ')
          ..write('cardTypes: $cardTypes, ')
          ..write('assetType: $assetType, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('assetKey: $assetKey, ')
          ..write('colors: $colors, ')
          ..write('logoText: $logoText, ')
          ..write('foreground: $foreground, ')
          ..write('version: $version, ')
          ..write('manifestVersion: $manifestVersion, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CardMetaTable cardMeta = $CardMetaTable(this);
  late final $CardFaceCacheTable cardFaceCache = $CardFaceCacheTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [cardMeta, cardFaceCache];
}

typedef $$CardMetaTableCreateCompanionBuilder =
    CardMetaCompanion Function({
      required String id,
      required String bankCode,
      required String bankName,
      required String cardType,
      Value<String?> nickname,
      Value<String?> last4,
      Value<String?> faceId,
      Value<String?> customFace,
      Value<double?> balance,
      Value<String> currency,
      Value<DateTime?> balanceUpdatedAt,
      Value<String?> notes,
      Value<int> orderIndex,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$CardMetaTableUpdateCompanionBuilder =
    CardMetaCompanion Function({
      Value<String> id,
      Value<String> bankCode,
      Value<String> bankName,
      Value<String> cardType,
      Value<String?> nickname,
      Value<String?> last4,
      Value<String?> faceId,
      Value<String?> customFace,
      Value<double?> balance,
      Value<String> currency,
      Value<DateTime?> balanceUpdatedAt,
      Value<String?> notes,
      Value<int> orderIndex,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$CardMetaTableFilterComposer
    extends Composer<_$AppDatabase, $CardMetaTable> {
  $$CardMetaTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bankCode => $composableBuilder(
    column: $table.bankCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bankName => $composableBuilder(
    column: $table.bankName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cardType => $composableBuilder(
    column: $table.cardType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nickname => $composableBuilder(
    column: $table.nickname,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get last4 => $composableBuilder(
    column: $table.last4,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get faceId => $composableBuilder(
    column: $table.faceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get customFace => $composableBuilder(
    column: $table.customFace,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get balance => $composableBuilder(
    column: $table.balance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get balanceUpdatedAt => $composableBuilder(
    column: $table.balanceUpdatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CardMetaTableOrderingComposer
    extends Composer<_$AppDatabase, $CardMetaTable> {
  $$CardMetaTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bankCode => $composableBuilder(
    column: $table.bankCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bankName => $composableBuilder(
    column: $table.bankName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cardType => $composableBuilder(
    column: $table.cardType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nickname => $composableBuilder(
    column: $table.nickname,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get last4 => $composableBuilder(
    column: $table.last4,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get faceId => $composableBuilder(
    column: $table.faceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customFace => $composableBuilder(
    column: $table.customFace,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get balance => $composableBuilder(
    column: $table.balance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get balanceUpdatedAt => $composableBuilder(
    column: $table.balanceUpdatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CardMetaTableAnnotationComposer
    extends Composer<_$AppDatabase, $CardMetaTable> {
  $$CardMetaTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get bankCode =>
      $composableBuilder(column: $table.bankCode, builder: (column) => column);

  GeneratedColumn<String> get bankName =>
      $composableBuilder(column: $table.bankName, builder: (column) => column);

  GeneratedColumn<String> get cardType =>
      $composableBuilder(column: $table.cardType, builder: (column) => column);

  GeneratedColumn<String> get nickname =>
      $composableBuilder(column: $table.nickname, builder: (column) => column);

  GeneratedColumn<String> get last4 =>
      $composableBuilder(column: $table.last4, builder: (column) => column);

  GeneratedColumn<String> get faceId =>
      $composableBuilder(column: $table.faceId, builder: (column) => column);

  GeneratedColumn<String> get customFace => $composableBuilder(
    column: $table.customFace,
    builder: (column) => column,
  );

  GeneratedColumn<double> get balance =>
      $composableBuilder(column: $table.balance, builder: (column) => column);

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<DateTime> get balanceUpdatedAt => $composableBuilder(
    column: $table.balanceUpdatedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$CardMetaTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CardMetaTable,
          CardMetaData,
          $$CardMetaTableFilterComposer,
          $$CardMetaTableOrderingComposer,
          $$CardMetaTableAnnotationComposer,
          $$CardMetaTableCreateCompanionBuilder,
          $$CardMetaTableUpdateCompanionBuilder,
          (
            CardMetaData,
            BaseReferences<_$AppDatabase, $CardMetaTable, CardMetaData>,
          ),
          CardMetaData,
          PrefetchHooks Function()
        > {
  $$CardMetaTableTableManager(_$AppDatabase db, $CardMetaTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CardMetaTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CardMetaTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CardMetaTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> bankCode = const Value.absent(),
                Value<String> bankName = const Value.absent(),
                Value<String> cardType = const Value.absent(),
                Value<String?> nickname = const Value.absent(),
                Value<String?> last4 = const Value.absent(),
                Value<String?> faceId = const Value.absent(),
                Value<String?> customFace = const Value.absent(),
                Value<double?> balance = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<DateTime?> balanceUpdatedAt = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> orderIndex = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CardMetaCompanion(
                id: id,
                bankCode: bankCode,
                bankName: bankName,
                cardType: cardType,
                nickname: nickname,
                last4: last4,
                faceId: faceId,
                customFace: customFace,
                balance: balance,
                currency: currency,
                balanceUpdatedAt: balanceUpdatedAt,
                notes: notes,
                orderIndex: orderIndex,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String bankCode,
                required String bankName,
                required String cardType,
                Value<String?> nickname = const Value.absent(),
                Value<String?> last4 = const Value.absent(),
                Value<String?> faceId = const Value.absent(),
                Value<String?> customFace = const Value.absent(),
                Value<double?> balance = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<DateTime?> balanceUpdatedAt = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> orderIndex = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => CardMetaCompanion.insert(
                id: id,
                bankCode: bankCode,
                bankName: bankName,
                cardType: cardType,
                nickname: nickname,
                last4: last4,
                faceId: faceId,
                customFace: customFace,
                balance: balance,
                currency: currency,
                balanceUpdatedAt: balanceUpdatedAt,
                notes: notes,
                orderIndex: orderIndex,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CardMetaTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CardMetaTable,
      CardMetaData,
      $$CardMetaTableFilterComposer,
      $$CardMetaTableOrderingComposer,
      $$CardMetaTableAnnotationComposer,
      $$CardMetaTableCreateCompanionBuilder,
      $$CardMetaTableUpdateCompanionBuilder,
      (
        CardMetaData,
        BaseReferences<_$AppDatabase, $CardMetaTable, CardMetaData>,
      ),
      CardMetaData,
      PrefetchHooks Function()
    >;
typedef $$CardFaceCacheTableCreateCompanionBuilder =
    CardFaceCacheCompanion Function({
      required String faceId,
      required String bankCode,
      required String bankName,
      required String cardTypes,
      required String assetType,
      Value<String?> imageUrl,
      Value<String?> assetKey,
      Value<String?> colors,
      Value<String?> logoText,
      Value<String?> foreground,
      required int version,
      required int manifestVersion,
      Value<int> rowid,
    });
typedef $$CardFaceCacheTableUpdateCompanionBuilder =
    CardFaceCacheCompanion Function({
      Value<String> faceId,
      Value<String> bankCode,
      Value<String> bankName,
      Value<String> cardTypes,
      Value<String> assetType,
      Value<String?> imageUrl,
      Value<String?> assetKey,
      Value<String?> colors,
      Value<String?> logoText,
      Value<String?> foreground,
      Value<int> version,
      Value<int> manifestVersion,
      Value<int> rowid,
    });

class $$CardFaceCacheTableFilterComposer
    extends Composer<_$AppDatabase, $CardFaceCacheTable> {
  $$CardFaceCacheTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get faceId => $composableBuilder(
    column: $table.faceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bankCode => $composableBuilder(
    column: $table.bankCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bankName => $composableBuilder(
    column: $table.bankName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cardTypes => $composableBuilder(
    column: $table.cardTypes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get assetType => $composableBuilder(
    column: $table.assetType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get assetKey => $composableBuilder(
    column: $table.assetKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get colors => $composableBuilder(
    column: $table.colors,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get logoText => $composableBuilder(
    column: $table.logoText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get foreground => $composableBuilder(
    column: $table.foreground,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get manifestVersion => $composableBuilder(
    column: $table.manifestVersion,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CardFaceCacheTableOrderingComposer
    extends Composer<_$AppDatabase, $CardFaceCacheTable> {
  $$CardFaceCacheTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get faceId => $composableBuilder(
    column: $table.faceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bankCode => $composableBuilder(
    column: $table.bankCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bankName => $composableBuilder(
    column: $table.bankName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cardTypes => $composableBuilder(
    column: $table.cardTypes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get assetType => $composableBuilder(
    column: $table.assetType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get assetKey => $composableBuilder(
    column: $table.assetKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get colors => $composableBuilder(
    column: $table.colors,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get logoText => $composableBuilder(
    column: $table.logoText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get foreground => $composableBuilder(
    column: $table.foreground,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get manifestVersion => $composableBuilder(
    column: $table.manifestVersion,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CardFaceCacheTableAnnotationComposer
    extends Composer<_$AppDatabase, $CardFaceCacheTable> {
  $$CardFaceCacheTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get faceId =>
      $composableBuilder(column: $table.faceId, builder: (column) => column);

  GeneratedColumn<String> get bankCode =>
      $composableBuilder(column: $table.bankCode, builder: (column) => column);

  GeneratedColumn<String> get bankName =>
      $composableBuilder(column: $table.bankName, builder: (column) => column);

  GeneratedColumn<String> get cardTypes =>
      $composableBuilder(column: $table.cardTypes, builder: (column) => column);

  GeneratedColumn<String> get assetType =>
      $composableBuilder(column: $table.assetType, builder: (column) => column);

  GeneratedColumn<String> get imageUrl =>
      $composableBuilder(column: $table.imageUrl, builder: (column) => column);

  GeneratedColumn<String> get assetKey =>
      $composableBuilder(column: $table.assetKey, builder: (column) => column);

  GeneratedColumn<String> get colors =>
      $composableBuilder(column: $table.colors, builder: (column) => column);

  GeneratedColumn<String> get logoText =>
      $composableBuilder(column: $table.logoText, builder: (column) => column);

  GeneratedColumn<String> get foreground => $composableBuilder(
    column: $table.foreground,
    builder: (column) => column,
  );

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<int> get manifestVersion => $composableBuilder(
    column: $table.manifestVersion,
    builder: (column) => column,
  );
}

class $$CardFaceCacheTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CardFaceCacheTable,
          CardFaceCacheData,
          $$CardFaceCacheTableFilterComposer,
          $$CardFaceCacheTableOrderingComposer,
          $$CardFaceCacheTableAnnotationComposer,
          $$CardFaceCacheTableCreateCompanionBuilder,
          $$CardFaceCacheTableUpdateCompanionBuilder,
          (
            CardFaceCacheData,
            BaseReferences<
              _$AppDatabase,
              $CardFaceCacheTable,
              CardFaceCacheData
            >,
          ),
          CardFaceCacheData,
          PrefetchHooks Function()
        > {
  $$CardFaceCacheTableTableManager(_$AppDatabase db, $CardFaceCacheTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CardFaceCacheTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CardFaceCacheTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CardFaceCacheTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> faceId = const Value.absent(),
                Value<String> bankCode = const Value.absent(),
                Value<String> bankName = const Value.absent(),
                Value<String> cardTypes = const Value.absent(),
                Value<String> assetType = const Value.absent(),
                Value<String?> imageUrl = const Value.absent(),
                Value<String?> assetKey = const Value.absent(),
                Value<String?> colors = const Value.absent(),
                Value<String?> logoText = const Value.absent(),
                Value<String?> foreground = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<int> manifestVersion = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CardFaceCacheCompanion(
                faceId: faceId,
                bankCode: bankCode,
                bankName: bankName,
                cardTypes: cardTypes,
                assetType: assetType,
                imageUrl: imageUrl,
                assetKey: assetKey,
                colors: colors,
                logoText: logoText,
                foreground: foreground,
                version: version,
                manifestVersion: manifestVersion,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String faceId,
                required String bankCode,
                required String bankName,
                required String cardTypes,
                required String assetType,
                Value<String?> imageUrl = const Value.absent(),
                Value<String?> assetKey = const Value.absent(),
                Value<String?> colors = const Value.absent(),
                Value<String?> logoText = const Value.absent(),
                Value<String?> foreground = const Value.absent(),
                required int version,
                required int manifestVersion,
                Value<int> rowid = const Value.absent(),
              }) => CardFaceCacheCompanion.insert(
                faceId: faceId,
                bankCode: bankCode,
                bankName: bankName,
                cardTypes: cardTypes,
                assetType: assetType,
                imageUrl: imageUrl,
                assetKey: assetKey,
                colors: colors,
                logoText: logoText,
                foreground: foreground,
                version: version,
                manifestVersion: manifestVersion,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CardFaceCacheTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CardFaceCacheTable,
      CardFaceCacheData,
      $$CardFaceCacheTableFilterComposer,
      $$CardFaceCacheTableOrderingComposer,
      $$CardFaceCacheTableAnnotationComposer,
      $$CardFaceCacheTableCreateCompanionBuilder,
      $$CardFaceCacheTableUpdateCompanionBuilder,
      (
        CardFaceCacheData,
        BaseReferences<_$AppDatabase, $CardFaceCacheTable, CardFaceCacheData>,
      ),
      CardFaceCacheData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CardMetaTableTableManager get cardMeta =>
      $$CardMetaTableTableManager(_db, _db.cardMeta);
  $$CardFaceCacheTableTableManager get cardFaceCache =>
      $$CardFaceCacheTableTableManager(_db, _db.cardFaceCache);
}
