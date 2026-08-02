import 'package:drift/drift.dart';

/// 网络更新的卡面缓存表（内置卡面来自随包 assets，不在此表）。
class CardFaceCache extends Table {
  TextColumn get faceId => text()();
  TextColumn get bankCode => text()();
  TextColumn get bankName => text()();
  TextColumn get cardTypes => text()(); // JSON 数组字符串
  TextColumn get assetType => text()(); // bundled | remote | gradient
  TextColumn get imageUrl => text().nullable()();
  TextColumn get assetKey => text().nullable()();
  TextColumn get colors => text().nullable()(); // JSON 数组字符串
  TextColumn get logoText => text().nullable()();
  TextColumn get foreground => text().nullable()();
  IntColumn get version => integer()();
  IntColumn get manifestVersion => integer()();

  @override
  Set<Column> get primaryKey => {faceId};
}
