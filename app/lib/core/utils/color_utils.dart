import 'package:flutter/material.dart' show Color;

/// 默认卡面色（无银行匹配时的兜底）。
const defaultCardColor = Color(0xFF607D8B);

/// 解析 `#RRGGBB` / `#AARRGGBB` / `RRGGBB` 颜色，失败返回 [fallback]。
Color hexToColor(String hex, {Color fallback = defaultCardColor}) {
  final cleaned = hex.replaceFirst('#', '');
  final value = int.tryParse(cleaned, radix: 16);
  if (value == null) return fallback;
  if (cleaned.length <= 6) return Color(0xFF000000 | value);
  return Color(value);
}

/// 颜色转 `#AARRGGBB` 字符串。
String colorToHex(Color color) =>
    '#${color.toARGB32().toRadixString(16).padLeft(8, '0')}';
