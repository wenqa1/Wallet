import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:kabao/core/constants/bank_catalog.dart';
import 'package:kabao/core/utils/color_utils.dart';
import 'package:kabao/data/local/app_database.dart';
import 'package:kabao/data/models/card_face.dart';
import 'package:kabao/data/models/custom_face.dart';

/// 一张卡最终渲染用的卡面组合。
class CardFaceResolution {
  const CardFaceResolution({required this.face, this.custom});

  final CardFace face;
  final CustomFace? custom;
}

/// 卡面解析：按优先级选择渲染来源。
///
/// 自定义卡面(用户本地) > 用户选中的卡面(faceId) > 银行默认(内置库) > 渐变兜底
class CardFaceResolver {
  const CardFaceResolver();

  CardFaceResolution resolve({
    required CardMetaData card,
    required List<CardFace> bundledFaces,
    required List<Bank> banks,
  }) {
    return CardFaceResolution(
      face: _findFace(card, bundledFaces, banks),
      custom: _parseCustom(card),
    );
  }

  CustomFace? _parseCustom(CardMetaData card) {
    final raw = card.customFace;
    if (raw == null || raw.isEmpty) return null;
    try {
      return CustomFace.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } on FormatException {
      return null;
    } on TypeError {
      return null;
    }
  }

  CardFace _findFace(
    CardMetaData card,
    List<CardFace> bundledFaces,
    List<Bank> banks,
  ) {
    final faceId = card.faceId;
    if (faceId != null) {
      final hit = bundledFaces.firstWhereOrNull((f) => f.faceId == faceId);
      if (hit != null) return hit;
    }
    final byBankAndType = bundledFaces.firstWhereOrNull(
      (f) => f.bankCode == card.bankCode && f.cardTypes.contains(card.cardType),
    );
    if (byBankAndType != null) return byBankAndType;
    final byBank = bundledFaces.firstWhereOrNull(
      (f) => f.bankCode == card.bankCode,
    );
    if (byBank != null) return byBank;
    final bank = banks.firstWhereOrNull((b) => b.bankCode == card.bankCode);
    return CardFace.gradientFor(
      bankCode: card.bankCode,
      bankName: card.bankName,
      color: bank?.themeColor ?? defaultCardColor,
    );
  }
}
