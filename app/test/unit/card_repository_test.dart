import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kabao/core/security/secure_storage_service.dart';
import 'package:kabao/data/local/app_database.dart';
import 'package:kabao/data/models/card_secret.dart';
import 'package:kabao/data/repositories/card_repository.dart';

/// 内存版 SecretStore，用于测试替换 Keychain。
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

void main() {
  late AppDatabase db;
  late InMemorySecretStore store;
  late CardRepository repo;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    store = InMemorySecretStore();
    repo = CardRepository(db, store);
  });

  tearDown(() async => db.close());

  CardMetaCompanion metaFor(String id, {String bankCode = 'CMB'}) {
    return CardMetaCompanion.insert(
      id: id,
      bankCode: bankCode,
      bankName: '招商银行',
      cardType: 'debit',
      createdAt: DateTime(2026, 1, 1),
      updatedAt: DateTime(2026, 1, 1),
    );
  }

  group('CardRepository', () {
    test('insertCard 写入元数据 + Keychain 敏感字段', () async {
      const secret = CardSecret(
        cardNumber: '6225882000001234',
        holderName: 'ZHANG SAN',
        expiry: '08/29',
        cvv: '123',
      );

      await repo.insertCard(metaFor('c1'), secret: secret);

      final meta = await repo.getCardById('c1');
      expect(meta, isNotNull);
      expect(meta!.bankCode, 'CMB');

      final stored = await repo.readSecret('c1');
      expect(stored, isNotNull);
      expect(stored!.cardNumber, '6225882000001234');
      expect(stored.holderName, 'ZHANG SAN');
      expect(stored.expiry, '08/29');
      expect(stored.cvv, '123');
    });

    test('readSecret 在无敏感字段时返回 null', () async {
      await repo.insertCard(metaFor('c2'));
      expect(await repo.readSecret('c2'), isNull);
    });

    test('updateCard 更新元数据并可更新敏感字段', () async {
      await repo.insertCard(metaFor('c3'), secret: const CardSecret(cardNumber: '1' * 16));
      await repo.updateCard(
        CardMetaCompanion.insert(
          id: 'c3',
          bankCode: 'CCB',
          bankName: '中国建设银行',
          cardType: 'debit',
          createdAt: DateTime(2026, 1, 1),
          updatedAt: DateTime(2026, 1, 2),
        ),
        secret: const CardSecret(cardNumber: '2' * 16, cvv: '999'),
      );

      final meta = await repo.getCardById('c3');
      expect(meta!.bankName, '中国建设银行');
      final stored = await repo.readSecret('c3');
      expect(stored!.cardNumber, '2' * 16);
      expect(stored.cvv, '999');
    });

    test('deleteCard 同时清除元数据与敏感字段', () async {
      await repo.insertCard(
        metaFor('c4'),
        secret: const CardSecret(cardNumber: '3' * 16),
      );

      await repo.deleteCard('c4');

      expect(await repo.getCardById('c4'), isNull);
      expect(await repo.readSecret('c4'), isNull);
    });

    test('watchAllCards 流式返回全部卡片', () async {
      await repo.insertCard(metaFor('c5'));
      await repo.insertCard(metaFor('c6', bankCode: 'CCB'));

      final all = await repo.watchAllCards().first;
      expect(all.length, 2);
      expect(all.map((m) => m.bankCode), containsAll(['CMB', 'CCB']));
    });
  });
}
