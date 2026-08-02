import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 当前正在显示明文的卡 id（null 表示全部遮挡）。
///
/// 长按临时显示 → 到时自动隐藏；切后台强制隐藏。
final revealCardIdProvider = NotifierProvider<RevealNotifier, String?>(
  RevealNotifier.new,
);

class RevealNotifier extends Notifier<String?> {
  Timer? _timer;

  @override
  String? build() {
    ref.onDispose(() => _timer?.cancel());
    return null;
  }

  void reveal(String cardId, Duration duration) {
    state = cardId;
    _timer?.cancel();
    _timer = Timer(duration, () => state = null);
  }

  void hide() {
    _timer?.cancel();
    state = null;
  }
}
