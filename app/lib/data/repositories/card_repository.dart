import 'dart:convert';

import 'package:kabao/core/security/secure_storage_service.dart';
import 'package:kabao/data/local/app_database.dart';
import 'package:kabao/data/models/card_secret.dart';

/// 卡片读写仓储：组合 Drift 元数据 + Keychain 敏感字段。
///
/// - 元数据（银行、类型、昵称、余额、卡面等）→ [AppDatabase]
/// - 敏感字段（卡号、持卡人、有效期、CVV）→ [SecretStore]（Keychain）
/// - 增删时两个存储一起写入/清理，保证不留残余。
class CardRepository {
  const CardRepository(this._db, this._secretStore);

  final AppDatabase _db;
  final SecretStore _secretStore;

  Stream<List<CardMetaData>> watchAllCards() =>
      _db.select(_db.cardMeta).watch();

  Future<CardMetaData?> getCardById(String id) async {
    final query = _db.select(_db.cardMeta)..where((t) => t.id.equals(id));
    return query.getSingleOrNull();
  }

  /// 读取某张卡的敏感字段；无则返回 null。
  Future<CardSecret?> readSecret(String cardId) async {
    final raw = await _secretStore.read(SecureStorageService.keyFor(cardId));
    if (raw == null) return null;
    return CardSecret.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  Future<void> insertCard(CardMetaCompanion meta, {CardSecret? secret}) async {
    await _db.into(_db.cardMeta).insert(meta);
    if (secret != null) {
      await _secretStore.write(
        SecureStorageService.keyFor(meta.id.value),
        secret.encode(),
      );
    }
  }

  Future<void> updateCard(CardMetaCompanion meta, {CardSecret? secret}) async {
    await _db.update(_db.cardMeta).replace(meta);
    if (secret != null) {
      await _secretStore.write(
        SecureStorageService.keyFor(meta.id.value),
        secret.encode(),
      );
    }
  }

  /// 删除卡片：元数据与敏感字段一并清除。
  Future<void> deleteCard(String id) async {
    final query = _db.delete(_db.cardMeta)..where((t) => t.id.equals(id));
    await query.go();
    await _secretStore.delete(SecureStorageService.keyFor(id));
  }
}
