import 'package:flutter/foundation.dart';

import 'card_scan_parser.dart';

/// 扫描状态机。
enum CardScanStatus { idle, scanning, found, error }

/// 卡片扫描控制器：接收 OCR 文本行，连续多帧命中同一卡号后进入 found。
///
/// 与相机/ML Kit 解耦，便于纯逻辑测试；真实帧处理见 `CardScanPage`。
class CardScanController extends ChangeNotifier {
  CardScanController({required this.parser, this.stableFrames = 3})
    : assert(stableFrames >= 1);

  final CardScanParser parser;
  final int stableFrames;

  CardScanStatus _status = CardScanStatus.idle;
  CardScanCandidate? _candidate;
  String? _error;
  int _consecutive = 0;
  String? _lastNumber;

  CardScanStatus get status => _status;
  CardScanCandidate? get candidate => _candidate;
  String? get error => _error;

  /// 重新开始扫描。
  void reset() {
    _status = CardScanStatus.scanning;
    _candidate = null;
    _error = null;
    _consecutive = 0;
    _lastNumber = null;
    notifyListeners();
  }

  /// 处理一帧 OCR 文本行。
  void processText(List<String> lines) {
    final results = parser.parse(lines);
    if (results.isEmpty) {
      _consecutive = 0;
      _lastNumber = null;
      _status = CardScanStatus.scanning;
      notifyListeners();
      return;
    }

    final best = results.first;
    if (best.cardNumber == _lastNumber) {
      _consecutive++;
    } else {
      _lastNumber = best.cardNumber;
      _consecutive = 1;
    }

    if (_consecutive >= stableFrames) {
      _candidate = best;
      _status = CardScanStatus.found;
    } else {
      _status = CardScanStatus.scanning;
    }
    notifyListeners();
  }

  void setError(Object error) {
    _status = CardScanStatus.error;
    _error = error.toString();
    notifyListeners();
  }
}
