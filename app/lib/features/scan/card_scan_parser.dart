import 'dart:math';

import 'package:kabao/core/utils/luhn.dart';

/// 一次 OCR 识别出的候选卡片信息。
class CardScanCandidate {
  const CardScanCandidate({
    required this.cardNumber,
    this.holderName,
    this.expiry,
  });

  final String cardNumber;
  final String? holderName;
  final String? expiry;
}

/// 从 OCR 文本行中提取卡片信息（纯逻辑，可单测）。
///
/// - 卡号：13~19 位数字且 Luhn 合法
/// - 持卡人：卡号上一行的全大写姓名
/// - 有效期：同/邻行的 `MM/YY` 模式
class CardScanParser {
  const CardScanParser();

  static final _expiryRe = RegExp(r'(0[1-9]|1[0-2])/(\d{2})');
  static final _nameRe = RegExp(r'^[A-Z][A-Z\s.\-]{2,29}$');

  List<CardScanCandidate> parse(List<String> lines) {
    final results = <CardScanCandidate>[];
    for (var i = 0; i < lines.length; i++) {
      final number = _findCardNumber(lines[i]);
      if (number == null) continue;
      results.add(
        CardScanCandidate(
          cardNumber: number,
          holderName: _holderNameAbove(lines, i),
          expiry: _expiryNear(lines, i),
        ),
      );
    }
    return results;
  }

  /// 在行内数字串中查找 Luhn 合法的 13~19 位子串（从最长开始）。
  String? _findCardNumber(String line) {
    final digits = line.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 13) return null;
    final maxLen = min(digits.length, 19);
    for (var len = maxLen; len >= 13; len--) {
      for (var start = 0; start + len <= digits.length; start++) {
        final sub = digits.substring(start, start + len);
        if (isLuhnValid(sub)) return sub;
      }
    }
    return null;
  }

  String? _holderNameAbove(List<String> lines, int index) {
    if (index == 0) return null;
    final above = lines[index - 1].trim();
    return _nameRe.hasMatch(above) ? above : null;
  }

  String? _expiryNear(List<String> lines, int index) {
    final start = max(0, index - 1);
    final end = min(index + 1, lines.length - 1);
    for (var i = start; i <= end; i++) {
      final match = _expiryRe.firstMatch(lines[i]);
      if (match != null) return match.group(0);
    }
    return null;
  }
}
