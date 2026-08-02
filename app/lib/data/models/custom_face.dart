import 'dart:ui';

import 'package:kabao/core/utils/color_utils.dart';

/// 用户自定义卡面，序列化后存于 [CardMeta].customFace。
///
/// - 纯渐变：由 [colors] 渲染
/// - 背景图：由 [imagePath]（本地文件路径）渲染，文字叠加其上
class CustomFace {
  const CustomFace({
    required this.colors,
    this.foreground,
    this.logoText,
    this.bankNameText,
    this.imagePath,
  });

  final List<Color> colors;
  final Color? foreground;
  final String? logoText;
  final String? bankNameText;
  final String? imagePath;

  Map<String, dynamic> toJson() => {
    'colors': [for (final c in colors) colorToHex(c)],
    if (foreground != null) 'foreground': colorToHex(foreground!),
    if (logoText != null) 'logoText': logoText,
    if (bankNameText != null) 'bankNameText': bankNameText,
    if (imagePath != null) 'imagePath': imagePath,
  };

  factory CustomFace.fromJson(Map<String, dynamic> json) => CustomFace(
    colors: [
      for (final c in (json['colors'] as List<dynamic>?) ?? const [])
        hexToColor(c.toString()),
    ],
    foreground: json['foreground'] != null
        ? hexToColor(json['foreground'] as String)
        : null,
    logoText: json['logoText'] as String?,
    bankNameText: json['bankNameText'] as String?,
    imagePath: json['imagePath'] as String?,
  );
}
