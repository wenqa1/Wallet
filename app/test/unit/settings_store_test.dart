import 'package:flutter_test/flutter_test.dart';
import 'package:kabao/data/local/settings_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('遮挡时长默认 5 秒并可设置', () async {
    SharedPreferences.setMockInitialValues({});
    final store = SharedPreferencesSettingsStore();

    expect(await store.maskAutoHideSeconds(), 5);

    await store.setMaskAutoHideSeconds(10);
    expect(await store.maskAutoHideSeconds(), 10);
  });
}
