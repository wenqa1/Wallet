import 'package:flutter_test/flutter_test.dart';
import 'package:kabao/features/scan/card_scan_controller.dart';
import 'package:kabao/features/scan/card_scan_parser.dart';

void main() {
  const parser = CardScanParser();

  CardScanController build({int stableFrames = 3}) =>
      CardScanController(parser: parser, stableFrames: stableFrames);

  test('初始状态为 idle', () {
    final controller = build();
    expect(controller.status, CardScanStatus.idle);
    controller.dispose();
  });

  test('无候选时保持 scanning', () {
    final controller = build();
    controller.processText(const ['no numbers here']);
    expect(controller.status, CardScanStatus.scanning);
    expect(controller.candidate, isNull);
    controller.dispose();
  });

  test('同一卡号连续 stableFrames 次后进入 found', () {
    final controller = build(stableFrames: 3);
    controller.processText(const ['4111 1111 1111 1111']);
    expect(controller.status, CardScanStatus.scanning);
    controller.processText(const ['4111 1111 1111 1111']);
    expect(controller.status, CardScanStatus.scanning);
    controller.processText(const ['4111 1111 1111 1111']);
    expect(controller.status, CardScanStatus.found);
    expect(controller.candidate!.cardNumber, '4111111111111111');
    controller.dispose();
  });

  test('卡号变化会重置连续帧计数', () {
    final controller = build(stableFrames: 3);
    controller.processText(const ['4111 1111 1111 1111']);
    controller.processText(const ['4111 1111 1111 1111']);
    controller.processText(const ['5500005555555559']); // 变化 → 重置
    expect(controller.status, CardScanStatus.scanning);
    controller.processText(const ['5500005555555559']);
    controller.processText(const ['5500005555555559']);
    expect(controller.status, CardScanStatus.found);
    expect(controller.candidate!.cardNumber, '5500005555555559');
    controller.dispose();
  });

  test('stableFrames=1 时首次命中即 found', () {
    final controller = build(stableFrames: 1);
    controller.processText(const ['4111 1111 1111 1111']);
    expect(controller.status, CardScanStatus.found);
    controller.dispose();
  });

  test('reset 回到 scanning 并清空候选', () {
    final controller = build(stableFrames: 1);
    controller.processText(const ['4111 1111 1111 1111']);
    expect(controller.status, CardScanStatus.found);
    controller.reset();
    expect(controller.status, CardScanStatus.scanning);
    expect(controller.candidate, isNull);
    controller.dispose();
  });

  test('setError 进入 error 状态', () {
    final controller = build();
    controller.setError(Exception('boom'));
    expect(controller.status, CardScanStatus.error);
    expect(controller.error, contains('boom'));
    controller.dispose();
  });
}
