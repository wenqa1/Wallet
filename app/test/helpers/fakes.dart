import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kabao/app/providers.dart';
import 'package:kabao/core/constants/bank_catalog.dart';
import 'package:kabao/core/security/secure_storage_service.dart';
import 'package:kabao/data/local/app_database.dart';
import 'package:kabao/data/repositories/card_repository.dart';

/// 内存版 Keychain，测试用。
class InMemorySecretStore implements SecretStore {
  final _map = <String, String>{};

  @override
  Future<void> delete(String key) async => _map.remove(key);

  @override
  Future<void> deleteAll() async => _map.clear();

  @override
  Future<String?> read(String key) async => _map[key];

  @override
  Future<void> write(String key, String value) async => _map[key] = value;
}

const testBanks = [
  Bank(bankCode: 'CMB', bankName: '招商银行', themeColor: Color(0xFFC8102E)),
  Bank(bankCode: 'CCB', bankName: '中国建设银行', themeColor: Color(0xFF003C71)),
];

/// 测试夹具：内存 DB + 内存 Keychain + 固定银行目录。
class TestHarness {
  TestHarness()
    : db = AppDatabase.forTesting(NativeDatabase.memory()),
      store = InMemorySecretStore();

  final AppDatabase db;
  final InMemorySecretStore store;

  CardRepository get repo => CardRepository(db, store);

  ProviderScope scope({required Widget child}) {
    return ProviderScope(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        secretStoreProvider.overrideWithValue(store),
        bankCatalogProvider.overrideWith((ref) async => testBanks),
      ],
      child: child,
    );
  }

  Future<void> close() => db.close();
}
