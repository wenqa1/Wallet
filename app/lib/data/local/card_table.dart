import 'package:drift/drift.dart';

/// 卡片元数据表（非敏感字段）。
///
/// 卡号/CVV/有效期等敏感字段不在此表，存 Keychain（见 SecureStorageService）。
class CardMeta extends Table {
  TextColumn get id => text()();
  TextColumn get bankCode => text()();
  TextColumn get bankName => text()();
  TextColumn get cardType => text()();
  TextColumn get nickname => text().nullable()();
  TextColumn get faceId => text().nullable()();
  TextColumn get customFace => text().nullable()();
  RealColumn get balance => real().nullable()();
  TextColumn get currency => text().withDefault(const Constant('¥'))();
  DateTimeColumn get balanceUpdatedAt => dateTime().nullable()();
  TextColumn get notes => text().nullable()();
  IntColumn get orderIndex => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
