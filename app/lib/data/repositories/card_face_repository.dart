import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../models/card_face.dart';

/// 卡面仓储：加载内置卡面清单，后续接入网络增量更新（M4）。
class CardFaceRepository {
  const CardFaceRepository();

  static const bundledManifestPath = 'assets/card_faces/bundled_manifest.json';

  /// 从随包 assets 加载内置卡面清单。
  Future<List<CardFace>> loadBundledFaces() async {
    final raw = await rootBundle.loadString(bundledManifestPath);
    final json = jsonDecode(raw) as Map<String, dynamic>;
    final faces = (json['faces'] as List<dynamic>?) ?? const [];
    return [
      for (final item in faces) CardFace.fromJson(item as Map<String, dynamic>),
    ];
  }

  /// 按银行代码 + 卡类型匹配默认卡面，找不到时返回 null（由调用方兜底）。
  CardFace? findDefault(
    List<CardFace> faces, {
    required String bankCode,
    required String cardType,
  }) {
    for (final face in faces) {
      if (face.bankCode == bankCode && face.cardTypes.contains(cardType)) {
        return face;
      }
    }
    for (final face in faces) {
      if (face.bankCode == bankCode) return face;
    }
    return null;
  }
}
