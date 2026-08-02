import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kabao/app/providers.dart';
import 'package:kabao/data/local/settings_store.dart';
import 'package:kabao/data/repositories/card_face_update_service.dart';
import 'package:kabao/features/settings/settings_page.dart';

class FakeSettingsStore implements SettingsStore {
  int seconds = 5;

  @override
  Future<int> maskAutoHideSeconds() async => seconds;

  @override
  Future<void> setMaskAutoHideSeconds(int seconds) async {
    this.seconds = seconds;
  }
}

class FakeUpdateService implements CardFaceUpdateService {
  CardFaceUpdateResult result = const CardFaceUpdateResult(
    updated: true,
    message: '已更新 3 张卡面',
  );
  int calls = 0;

  @override
  Future<CardFaceUpdateResult> checkForUpdates() async {
    calls++;
    return result;
  }
}

void main() {
  late FakeSettingsStore settings;
  late FakeUpdateService updateService;

  setUp(() {
    settings = FakeSettingsStore();
    updateService = FakeUpdateService();
  });

  Future<void> pumpSettings(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          settingsStoreProvider.overrideWithValue(settings),
          cardFaceUpdateServiceProvider.overrideWithValue(updateService),
          cachedFacesProvider.overrideWith((ref) async => const []),
        ],
        child: const MaterialApp(home: SettingsPage()),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('显示当前遮挡时长并可切换持久化', (tester) async {
    await pumpSettings(tester);

    await tester.tap(find.text('10 秒'));
    await tester.pumpAndSettle();

    expect(settings.seconds, 10);
  });

  testWidgets('检查卡面更新触发服务并提示结果', (tester) async {
    await pumpSettings(tester);

    await tester.tap(find.byKey(const Key('check_update_button')));
    await tester.pumpAndSettle();

    expect(updateService.calls, 1);
    expect(find.text('已更新 3 张卡面'), findsOneWidget);
  });
}
