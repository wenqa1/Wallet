import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kabao/app/providers.dart';
import 'package:kabao/core/constants/bank_catalog.dart';
import 'package:kabao/data/local/app_database.dart';
import 'package:kabao/data/models/card_secret.dart';
import 'package:kabao/data/repositories/card_repository.dart';

const testBanks = [
  Bank(bankCode: 'CMB', bankName: '招商银行', themeColor: Color(0xFFC8102E)),
  Bank(bankCode: 'CCB', bankName: '中国建设银行', themeColor: Color(0xFF003C71)),
];

/// 内存版卡片仓储，widget 测试用（纯 microtask，无真实 I/O）。
class FakeCardRepository implements CardRepository {
  final _cards = <String, CardMetaData>{};
  final _secrets = <String, CardSecret>{};

  CardMetaData _fromCompanion(CardMetaCompanion c) => CardMetaData(
    id: c.id.value,
    bankCode: c.bankCode.value,
    bankName: c.bankName.value,
    cardType: c.cardType.value,
    nickname: c.nickname.value,
    last4: c.last4.value,
    balance: c.balance.value,
    currency: c.currency.present ? c.currency.value : '¥',
    balanceUpdatedAt: c.balanceUpdatedAt.value,
    notes: c.notes.value,
    orderIndex: c.orderIndex.present ? c.orderIndex.value : 0,
    createdAt: c.createdAt.value,
    updatedAt: c.updatedAt.value,
  );

  void seed(CardMetaCompanion meta, {CardSecret? secret}) {
    final row = _fromCompanion(meta);
    _cards[row.id] = row;
    if (secret != null) _secrets[row.id] = secret;
  }

  @override
  Stream<List<CardMetaData>> watchAllCards() =>
      Stream.value(_cards.values.toList());

  @override
  Future<CardMetaData?> getCardById(String id) async => _cards[id];

  @override
  Future<CardSecret?> readSecret(String cardId) async => _secrets[cardId];

  @override
  Future<void> insertCard(CardMetaCompanion meta, {CardSecret? secret}) async {
    seed(meta, secret: secret);
  }

  @override
  Future<void> updateCard(CardMetaCompanion meta, {CardSecret? secret}) async {
    seed(meta, secret: secret);
  }

  @override
  Future<void> deleteCard(String id) async {
    _cards.remove(id);
    _secrets.remove(id);
  }
}

/// 测试夹具：fake 仓储 + 固定银行目录。
class TestHarness {
  TestHarness();

  final FakeCardRepository repo = FakeCardRepository();

  ProviderScope scope({required Widget child}) {
    return ProviderScope(
      overrides: [
        cardRepositoryProvider.overrideWithValue(repo),
        bankCatalogProvider.overrideWith((ref) async => testBanks),
      ],
      child: child,
    );
  }

  Future<void> close() async {}
}
