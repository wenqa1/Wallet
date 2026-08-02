import 'package:flutter/material.dart';

import '../../core/constants/bank_catalog.dart';
import '../../core/face/card_face_resolver.dart';
import '../../data/local/app_database.dart';
import '../../data/models/card_face.dart';
import 'card_back_details.dart';
import 'card_face_widget.dart';
import 'card_flip_view.dart';

/// 钱包式卡片轮播：PageView + 错落缩放，点击卡片 3D 翻转看详情。
class CardCarousel extends StatefulWidget {
  const CardCarousel({
    super.key,
    required this.cards,
    required this.faces,
    required this.banks,
    required this.onEdit,
    required this.onDelete,
  });

  final List<CardMetaData> cards;
  final List<CardFace> faces;
  final List<Bank> banks;
  final ValueChanged<CardMetaData> onEdit;
  final ValueChanged<CardMetaData> onDelete;

  @override
  State<CardCarousel> createState() => _CardCarouselState();
}

class _CardCarouselState extends State<CardCarousel> {
  final _controller = PageController(viewportFraction: 0.82);
  static const _resolver = CardFaceResolver();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _controller,
      itemCount: widget.cards.length,
      itemBuilder: (context, index) {
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            double page = 0;
            if (_controller.position.haveDimensions) {
              page = (_controller.page ?? 0) - index;
            }
            final scale = (1 - (page.abs() * 0.1).clamp(0.0, 0.4)).toDouble();
            return Transform.scale(scale: scale, child: child);
          },
          child: _buildCard(index),
        );
      },
    );
  }

  Widget _buildCard(int index) {
    final card = widget.cards[index];
    final resolution = _resolver.resolve(
      card: card,
      bundledFaces: widget.faces,
      banks: widget.banks,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: CardFlipView(
        front: CardFaceWidget(
          face: resolution.face,
          customFace: resolution.custom,
          nickname: card.nickname,
          cardNumberMasked: card.last4 == null ? null : '•••• ${card.last4}',
          balance: card.balance == null
              ? null
              : '${card.currency} ${card.balance!.toStringAsFixed(2)}',
        ),
        back: ColoredBox(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          child: CardBackDetails(
            card: card,
            onEdit: () => widget.onEdit(card),
            onDelete: () => widget.onDelete(card),
          ),
        ),
      ),
    );
  }
}
