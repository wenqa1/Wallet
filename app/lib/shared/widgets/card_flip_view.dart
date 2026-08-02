import 'dart:math' as math;

import 'package:flutter/material.dart';

/// 3D 翻转容器：点击在 [front] 与 [back] 之间切换。
class CardFlipView extends StatefulWidget {
  const CardFlipView({super.key, required this.front, required this.back});

  final Widget front;
  final Widget back;

  @override
  State<CardFlipView> createState() => _CardFlipViewState();
}

class _CardFlipViewState extends State<CardFlipView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 400),
  );
  bool _showFront = true;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    if (_controller.isAnimating) return;
    if (_showFront) {
      _controller.forward(from: 0);
    } else {
      _controller.reverse();
    }
    _showFront = !_showFront;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggle,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final angle = _controller.value * math.pi;
          final showFront = angle < math.pi / 2;

          return Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.0012)
              ..rotateY(angle),
            alignment: Alignment.center,
            child: showFront
                ? widget.front
                : Transform(
                    transform: Matrix4.rotationY(math.pi),
                    alignment: Alignment.center,
                    child: widget.back,
                  ),
          );
        },
      ),
    );
  }
}
