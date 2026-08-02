import 'dart:io';
import 'dart:ui' as ui;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import 'card_scan_controller.dart';
import 'card_scan_parser.dart';
import 'ocr_recognizer.dart';
import 'scan_result_card.dart';

/// 相机扫描页：实时帧 OCR，稳定命中后弹出确认卡。
///
/// 确认后 `Navigator.pop(context, CardScanCandidate)` 返回结果。
/// [recognizer] / [controller] 可注入便于测试。
class CardScanPage extends StatefulWidget {
  const CardScanPage({super.key, this.recognizer, this.controller});

  final OcrRecognizer? recognizer;
  final CardScanController? controller;

  @override
  State<CardScanPage> createState() => _CardScanPageState();
}

class _CardScanPageState extends State<CardScanPage> {
  late final OcrRecognizer _recognizer;
  late final CardScanController _controller;
  CameraController? _camera;
  String? _initError;
  bool _processing = false;

  @override
  void initState() {
    super.initState();
    _recognizer = widget.recognizer ?? MlKitOcrRecognizer();
    _controller =
        widget.controller ?? CardScanController(parser: const CardScanParser());
    _controller.addListener(_onControllerChanged);
    _controller.reset();
    _initCamera();
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChanged);
    _camera?.dispose();
    if (widget.recognizer == null) _recognizer.dispose();
    if (widget.controller == null) _controller.dispose();
    super.dispose();
  }

  void _onControllerChanged() {
    if (mounted) setState(() {});
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      final back = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );
      final camera = CameraController(back, ResolutionPreset.medium);
      await camera.initialize();
      await camera.startImageStream(_onFrame);
      if (!mounted) return;
      setState(() => _camera = camera);
    } catch (e) {
      if (!mounted) return;
      setState(() => _initError = e.toString());
    }
  }

  void _onFrame(CameraImage image) {
    if (_processing) return;
    _processing = true;
    _recognize(image).whenComplete(() => _processing = false);
  }

  Future<void> _recognize(CameraImage image) async {
    try {
      final lines = await _recognizer.recognize(_inputImageFromCamera(image));
      if (mounted) _controller.processText(lines);
    } catch (e) {
      if (mounted) _controller.setError(e);
    }
  }

  InputImage _inputImageFromCamera(CameraImage image) {
    final isAndroid = Platform.isAndroid;
    return InputImage.fromBytes(
      bytes: image.planes[0].bytes,
      metadata: InputImageMetadata(
        size: ui.Size(image.width.toDouble(), image.height.toDouble()),
        rotation: InputImageRotation.rotation90deg,
        format: isAndroid ? InputImageFormat.nv21 : InputImageFormat.bgra8888,
        bytesPerRow: image.planes[0].bytesPerRow,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('扫描卡号')),
      body: switch (_controller.status) {
        CardScanStatus.found => _buildFound(),
        CardScanStatus.error => _buildError(),
        _ => _buildPreview(),
      },
    );
  }

  Widget _buildPreview() {
    final camera = _camera;
    if (camera != null) {
      return Stack(
        fit: StackFit.expand,
        children: [
          CameraPreview(camera),
          // 扫描取景框提示。
          Center(
            child: Container(
              width: 280,
              height: 180,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: Text('对准银行卡号', style: TextStyle(color: Colors.white)),
              ),
            ),
          ),
        ],
      );
    }
    if (_initError != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text('相机初始化失败：$_initError'),
        ),
      );
    }
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildFound() {
    final candidate = _controller.candidate;
    if (candidate == null) return _buildPreview();
    return Stack(
      fit: StackFit.expand,
      children: [
        _buildPreview(),
        Positioned(
          left: 16,
          right: 16,
          bottom: 32,
          child: ScanResultCard(
            candidate: candidate,
            onRescan: _controller.reset,
            onConfirm: () => Navigator.pop(context, candidate),
          ),
        ),
      ],
    );
  }

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('识别出错：${_controller.error}'),
            const SizedBox(height: 12),
            FilledButton(onPressed: _controller.reset, child: const Text('重试')),
          ],
        ),
      ),
    );
  }
}
