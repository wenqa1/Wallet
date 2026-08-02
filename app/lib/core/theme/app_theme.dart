import 'package:flutter/material.dart';

/// 应用主题。卡片风格偏"钱包"质感，深色模式跟随系统。
abstract final class AppTheme {
  static const _seed = Color(0xFF1A6BFF);

  static ThemeData light() => _base(Brightness.light);

  static ThemeData dark() => _base(Brightness.dark);

  static ThemeData _base(Brightness brightness) => ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: ColorScheme.fromSeed(seedColor: _seed, brightness: brightness),
  );
}
