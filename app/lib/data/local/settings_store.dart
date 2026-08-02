import 'package:shared_preferences/shared_preferences.dart';

/// 设置存储抽象，测试可注入内存实现。
abstract interface class SettingsStore {
  Future<int> maskAutoHideSeconds();

  Future<void> setMaskAutoHideSeconds(int seconds);
}

/// SharedPreferences 实现。
class SharedPreferencesSettingsStore implements SettingsStore {
  static const _maskAutoHideKey = 'mask_auto_hide_seconds';

  @override
  Future<int> maskAutoHideSeconds() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_maskAutoHideKey) ?? 5;
  }

  @override
  Future<void> setMaskAutoHideSeconds(int seconds) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_maskAutoHideKey, seconds);
  }
}
