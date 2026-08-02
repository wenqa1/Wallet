import '../local/app_database.dart';

/// 卡片读写仓储：组合 Drift 元数据 + Keychain 敏感字段。
///
/// 本骨架先实现元数据（非敏感）读写，敏感字段的 Keychain 读写
/// 在 M1 里程碑（卡片 CRUD）中与 [SecureStorageService] 组合。
class CardRepository {
  const CardRepository(this._db);

  final AppDatabase _db;

  Stream<List<CardMetaData>> watchAllCards() =>
      _db.select(_db.cardMeta).watch();

  Future<CardMetaData?> getCardById(String id) async {
    final query = _db.select(_db.cardMeta)..where((t) => t.id.equals(id));
    return query.getSingleOrNull();
  }

  Future<void> insertCard(CardMetaCompanion companion) =>
      _db.into(_db.cardMeta).insert(companion);

  Future<void> updateCard(CardMetaCompanion companion) =>
      _db.update(_db.cardMeta).replace(companion);

  Future<void> deleteCard(String id) async {
    final query = _db.delete(_db.cardMeta)..where((t) => t.id.equals(id));
    await query.go();
  }
}
