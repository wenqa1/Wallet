import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kabao/core/constants/bank_catalog.dart';
import 'package:kabao/core/face/card_face_resolver.dart';
import 'package:kabao/data/local/app_database.dart';
import 'package:kabao/data/models/card_face.dart';
import 'package:kabao/data/models/custom_face.dart';

void main() {
  const resolver = CardFaceResolver();

  final banks = [
    const Bank(
      bankCode: 'CMB',
      bankName: '招商银行',
      themeColor: Color(0xFFC8102E),
    ),
  ];
  final faces = [
    const CardFace(
      faceId: 'cmb-x',
      bankCode: 'CMB',
      bankName: '招商银行',
      cardTypes: ['debit', 'credit'],
      assetType: 'gradient',
      version: 1,
      colors: [Color(0xFFC8102E), Color(0xFF8C0B20)],
    ),
  ];

  CardMetaData card({
    String? faceId,
    String? customFaceJson,
    String bankCode = 'CMB',
    String cardType = 'debit',
  }) {
    return CardMetaData(
      id: 'c1',
      bankCode: bankCode,
      bankName: '招商银行',
      cardType: cardType,
      currency: '¥',
      orderIndex: 0,
      createdAt: DateTime(2026, 1, 1),
      updatedAt: DateTime(2026, 1, 1),
      faceId: faceId,
      customFace: customFaceJson,
    );
  }

  group('CardFaceResolver', () {
    test('自定义卡面优先，但仍解析出默认卡面', () {
      const custom = CustomFace(colors: [Color(0xFF123456)]);

      final r = resolver.resolve(
        card: card(customFaceJson: jsonEncode(custom.toJson())),
        bundledFaces: faces,
        banks: banks,
      );

      expect(r.custom, isNotNull);
      expect(r.custom!.colors, custom.colors);
      expect(r.face.faceId, 'cmb-x');
    });

    test('faceId 命中内置卡面', () {
      final r = resolver.resolve(
        card: card(faceId: 'cmb-x'),
        bundledFaces: faces,
        banks: banks,
      );
      expect(r.face.faceId, 'cmb-x');
    });

    test('未知 faceId 回退到银行默认卡面', () {
      final r = resolver.resolve(
        card: card(faceId: 'nope'),
        bundledFaces: faces,
        banks: banks,
      );
      expect(r.face.faceId, 'cmb-x');
    });

    test('未知银行合成渐变卡面兜底', () {
      final r = resolver.resolve(
        card: card(bankCode: 'UNKNOWN'),
        bundledFaces: faces,
        banks: banks,
      );
      expect(r.face.assetType, 'gradient');
      expect(r.face.bankCode, 'UNKNOWN');
    });

    test('损坏的 customFace JSON 不崩溃', () {
      final r = resolver.resolve(
        card: card(customFaceJson: 'not-json'),
        bundledFaces: faces,
        banks: banks,
      );
      expect(r.custom, isNull);
      expect(r.face, isNotNull);
    });
  });
}
