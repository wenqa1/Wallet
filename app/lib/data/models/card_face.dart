import 'dart:ui';

import 'package:flutter/material.dart' show Colors;

/// 卡面资源模型。
///
/// assetType:
/// - `gradient`：内置通用渐变卡面（配色 + 行名文字，合规）
/// - `bundled`：随包内置图片卡面
/// - `remote`：网络更新下载的图片卡面
class CardFace {
  const CardFace({
    required this.faceId,
    required this.bankCode,
    required this.bankName,
    required this.cardTypes,
    required this.assetType,
    required this.version,
    this.imageUrl,
    this.assetKey,
    this.colors = const [],
    this.logoText,
    this.foreground,
  });

  final String faceId;
  final String bankCode;
  final String bankName;
  final List<String> cardTypes;
  final String assetType;
  final String? imageUrl;
  final String? assetKey;
  final List<Color> colors;
  final String? logoText;
  final Color? foreground;
  final int version;

  /// 由银行主题色合成一个渐变卡面（合规方案，无需图片资产）。
  factory CardFace.gradientFor({
    required String bankCode,
    required String bankName,
    required Color color,
    List<String> cardTypes = const ['debit', 'credit'],
  }) {
    final end = Color.lerp(color, Colors.black, 0.35) ?? color;
    return CardFace(
      faceId: 'grad-$bankCode',
      bankCode: bankCode,
      bankName: bankName,
      cardTypes: cardTypes,
      assetType: 'gradient',
      version: 1,
      colors: [color, end],
      logoText: bankCode,
    );
  }

  factory CardFace.fromJson(Map<String, dynamic> json) {
    final fallback = (json['fallback'] as Map<String, dynamic>?) ?? const {};
    final colorStrings =
        (fallback['colors'] as List<dynamic>?)?.cast<String>() ?? const [];

    return CardFace(
      faceId: json['faceId'] as String,
      bankCode: json['bankCode'] as String,
      bankName: json['bankName'] as String,
      cardTypes:
          (json['cardTypes'] as List<dynamic>?)?.cast<String>() ?? const [],
      assetType: json['assetType'] as String? ?? 'gradient',
      imageUrl: json['imageUrl'] as String?,
      assetKey: json['assetKey'] as String?,
      colors: [for (final c in colorStrings) _parseHexColor(c)],
      logoText: fallback['logoText'] as String?,
      foreground: fallback['foreground'] != null
          ? _parseHexColor(fallback['foreground'] as String)
          : null,
      version: json['version'] as int? ?? 1,
    );
  }

  static Color _parseHexColor(String hex) {
    final cleaned = hex.replaceFirst('#', '');
    final value = int.tryParse(cleaned, radix: 16);
    if (value == null) return const Color(0xFF607D8B);
    return Color(0xFF000000 | value);
  }
}
