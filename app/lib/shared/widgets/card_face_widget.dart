import 'package:flutter/material.dart';

import '../../data/models/card_face.dart';

/// 卡片正面渲染。
///
/// v1 内置库为 gradient 渐变卡面；bundled/remote 图片卡面在 M2/M4
/// 接入图片加载后复用同一组件（按 assetType 分支渲染）。
class CardFaceWidget extends StatelessWidget {
  const CardFaceWidget({
    super.key,
    required this.face,
    this.nickname,
    this.cardNumberMasked,
    this.balance,
  });

  final CardFace face;
  final String? nickname;
  final String? cardNumberMasked;
  final String? balance;

  /// 银行卡标准宽高比。
  static const aspectRatio = 3.37 / 2.125;

  @override
  Widget build(BuildContext context) {
    final colors = face.colors.isNotEmpty
        ? face.colors
        : const [Color(0xFF607D8B), Color(0xFF37474F)];
    final foreground = face.foreground ?? Colors.white;

    return AspectRatio(
      aspectRatio: aspectRatio,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: colors,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (face.logoText != null)
                      Text(
                        face.logoText!,
                        style: TextStyle(
                          color: foreground,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                        ),
                      ),
                    const Spacer(),
                    if (face.bankName.isNotEmpty)
                      Text(
                        face.bankName,
                        style: TextStyle(color: foreground, fontSize: 11),
                      ),
                  ],
                ),
                const Spacer(),
                if (nickname != null)
                  Text(
                    nickname!,
                    style: TextStyle(color: foreground, fontSize: 13),
                  ),
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
          ),
        ),
      ),
    );
  }
}
