import 'dart:io';

import 'package:flutter/material.dart';

import '../../data/models/card_face.dart';
import '../../data/models/custom_face.dart';

/// 卡片正面渲染。
///
/// 渲染优先级：
/// 1. 自定义卡面背景图（[CustomFace.imagePath] 存在）
/// 2. 自定义卡面渐变（[CustomFace.colors]）
/// 3. 资源卡面（[CardFace.assetType] = gradient / bundled / remote）
class CardFaceWidget extends StatelessWidget {
  const CardFaceWidget({
    super.key,
    required this.face,
    this.customFace,
    this.imagePath,
    this.nickname,
    this.cardNumberMasked,
    this.balance,
  });

  final CardFace face;
  final CustomFace? customFace;

  /// 远程卡面已下载的本地图片路径；提供且存在时用图片渲染。
  final String? imagePath;

  final String? nickname;
  final String? cardNumberMasked;
  final String? balance;

  /// 银行卡标准宽高比。
  static const aspectRatio = 3.37 / 2.125;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: aspectRatio,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: _buildBackground(),
      ),
    );
  }

  Widget _buildBackground() {
    final custom = customFace;
    final customImagePath = custom?.imagePath;
    // 1. 自定义背景图。
    if (customImagePath != null && File(customImagePath).existsSync()) {
      return _imageBackground(
        image: Image.file(File(customImagePath), fit: BoxFit.cover),
        foreground: custom?.foreground ?? Colors.white,
        logoText: custom?.logoText,
        bankName: custom?.bankNameText ?? face.bankName,
      );
    }
    // 2. 远程卡面已下载的本地图片。
    if (imagePath != null && File(imagePath!).existsSync()) {
      return _imageBackground(
        image: Image.file(File(imagePath!), fit: BoxFit.cover),
        foreground: face.foreground ?? Colors.white,
        logoText: face.logoText,
        bankName: face.bankName,
      );
    }
    // 3. 远程卡面未下载时的在线兜底。
    if (face.assetType == 'remote' && face.imageUrl != null) {
      return _imageBackground(
        image: Image.network(
          face.imageUrl!,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => _gradientBackground(custom),
        ),
        foreground: face.foreground ?? Colors.white,
        logoText: face.logoText,
        bankName: face.bankName,
      );
    }
    return _gradientBackground(custom);
  }

  Widget _imageBackground({
    required Image image,
    required Color foreground,
    String? logoText,
    required String bankName,
  }) {
    return Stack(
      fit: StackFit.expand,
      children: [
        image,
        _content(
          foreground: foreground,
          logoText: logoText,
          bankName: bankName,
        ),
      ],
    );
  }

  Widget _gradientBackground(CustomFace? custom) {
    final colors = (custom != null && custom.colors.isNotEmpty)
        ? custom.colors
        : (face.colors.isNotEmpty
              ? face.colors
              : const [Color(0xFF607D8B), Color(0xFF37474F)]);
    final foreground = custom?.foreground ?? face.foreground ?? Colors.white;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
      ),
      child: _content(
        foreground: foreground,
        logoText: custom?.logoText ?? face.logoText,
        bankName: custom?.bankNameText ?? face.bankName,
      ),
    );
  }

  Widget _content({
    required Color foreground,
    String? logoText,
    required String bankName,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (logoText != null)
                Text(
                  logoText,
                  style: TextStyle(
                    color: foreground,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
              const Spacer(),
              if (bankName.isNotEmpty)
                Text(
                  bankName,
                  style: TextStyle(color: foreground, fontSize: 11),
                ),
            ],
          ),
          const Spacer(),
          if (nickname != null)
            Text(nickname!, style: TextStyle(color: foreground, fontSize: 13)),
          const SizedBox(height: 4),
          if (cardNumberMasked != null)
            Text(
              cardNumberMasked!,
              style: TextStyle(
                color: foreground,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.5,
              ),
            ),
          if (balance != null)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                balance!,
                style: TextStyle(color: foreground, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }
}
