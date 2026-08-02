import 'package:flutter/material.dart';

import '../../core/face/card_face_resolver.dart';
import '../../data/local/app_database.dart';
import 'card_face_widget.dart';

/// 列表中的单张卡片。卡号只显示后四位（last4 存于元数据，无需读 Keychain）。
class CardTile extends StatelessWidget {
  const CardTile({super.key, required this.card, required this.resolution});

  final CardMetaData card;
  final CardFaceResolution resolution;

  @override
  Widget build(BuildContext context) {
    final last4 = card.last4;
    final balance = card.balance;

    return CardFaceWidget(
      face: resolution.face,
      customFace: resolution.custom,
      nickname: card.nickname,
      cardNumberMasked: last4 == null ? null : '•••• $last4',
      balance: balance == null
          ? null
          : '${card.currency} ${balance.toStringAsFixed(2)}',
    );
  }
}
