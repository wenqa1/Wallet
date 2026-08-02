import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// 敏感数据存储抽象。测试时可用内存实现替换，生产用 Keychain。
abstract interface class SecretStore {
  Future<String?> read(String key);

  Future<void> write(String key, String value);

  Future<void> delete(String key);

  Future<void> deleteAll();
}

/// Keychain 实现。
///
/// iOS 走 Keychain（默认 accessibility 为 first_unlock_this_device），
/// Android 走 EncryptedSharedPreferences。卡号、CVV、有效期等只能存这里，
/// 严禁写入普通 SQLite 或日志。
class SecureStorageService implements SecretStore {
  SecureStorageService({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  /// 敏感字段在 Keychain 中的 key 前缀。
  static const keyPrefix = 'card_secret_';

  static String keyFor(String cardId) => '$keyPrefix$cardId';

  @override
  Future<String?> read(String key) => _storage.read(key: key);

  @override
  Future<void> write(String key, String value) =>
      _storage.write(key: key, value: value);

  @override
  Future<void> delete(String key) => _storage.delete(key: key);

  @override
  Future<void> deleteAll() => _storage.deleteAll();
}
