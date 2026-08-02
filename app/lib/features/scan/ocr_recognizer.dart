import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

/// OCR 识别抽象，测试可注入 fake。
abstract interface class OcrRecognizer {
  /// 识别图像，返回文本行列表。
  Future<List<String>> recognize(InputImage image);

  void dispose();
}

/// ML Kit 端侧文本识别实现（离线，无网络请求）。
class MlKitOcrRecognizer implements OcrRecognizer {
  MlKitOcrRecognizer()
    : _recognizer = TextRecognizer(script: TextRecognitionScript.latin);

  final TextRecognizer _recognizer;

  @override
  Future<List<String>> recognize(InputImage image) async {
    final result = await _recognizer.processImage(image);
    final lines = <String>[];
    for (final block in result.blocks) {
      for (final line in block.lines) {
        lines.add(line.text);
      }
    }
    return lines;
  }

  @override
  void dispose() => _recognizer.close();
}
