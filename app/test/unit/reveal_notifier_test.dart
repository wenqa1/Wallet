import 'package:fake_async/fake_async.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kabao/features/card_list/reveal_notifier.dart';

void main() {
  test('reveal 设置状态并在时长后自动隐藏', () {
    fakeAsync((async) {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container
          .read(revealCardIdProvider.notifier)
          .reveal('c1', const Duration(seconds: 5));

      expect(container.read(revealCardIdProvider), 'c1');
      async.elapse(const Duration(seconds: 4));
      expect(container.read(revealCardIdProvider), 'c1');
      async.elapse(const Duration(seconds: 1));
      expect(container.read(revealCardIdProvider), isNull);
    });
  });

  test('hide 立即隐藏', () {
    fakeAsync((async) {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(revealCardIdProvider.notifier);
      notifier.reveal('c1', const Duration(seconds: 5));
      notifier.hide();

      expect(container.read(revealCardIdProvider), isNull);
    });
  });

  test('再次 reveal 重置计时', () {
    fakeAsync((async) {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(revealCardIdProvider.notifier);
      notifier.reveal('c1', const Duration(seconds: 5));
      async.elapse(const Duration(seconds: 3));
      notifier.reveal('c2', const Duration(seconds: 5));

      expect(container.read(revealCardIdProvider), 'c2');
      async.elapse(const Duration(seconds: 3));
      expect(container.read(revealCardIdProvider), 'c2'); // 重置后未到 5s
      async.elapse(const Duration(seconds: 2));
      expect(container.read(revealCardIdProvider), isNull);
    });
  });
}
