import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

/// 银行信息（从内置 banks_cn.json 加载）。
class Bank {
  const Bank({
    required this.bankCode,
    required this.bankName,
    required this.themeColor,
  });

  final String bankCode;
  final String bankName;
  final Color themeColor;

  factory Bank.fromJson(Map<String, dynamic> json) => Bank(
    bankCode: json['bankCode'] as String,
    bankName: json['bankName'] as String,
    themeColor: _parseHex(json['themeColor'] as String?),
  );

  static Color _parseHex(String? hex) {
    if (hex == null) return const Color(0xFF607D8B);
    final value = int.tryParse(hex.replaceFirst('#', ''), radix: 16);
    if (value == null) return const Color(0xFF607D8B);
    return Color(0xFF000000 | value);
  }
}

/// 银行目录。默认从随包资产 `assets/card_faces/banks_cn.json` 加载。
class BankCatalog {
  const BankCatalog();

  static const assetPath = 'assets/card_faces/banks_cn.json';

  Future<List<Bank>> load() async {
    final raw = await rootBundle.loadString(assetPath);
    final json = jsonDecode(raw) as Map<String, dynamic>;
    final banks = (json['banks'] as List<dynamic>?) ?? const [];
    return [
      for (final item in banks) Bank.fromJson(item as Map<String, dynamic>),
    ];
  }
}
