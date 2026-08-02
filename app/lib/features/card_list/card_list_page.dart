import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../core/constants/bank_catalog.dart';
import '../../data/local/app_database.dart';
import '../../data/models/card_face.dart';
import '../../shared/widgets/card_carousel.dart';

/// 卡片列表流（实时监听数据库变更）。
final cardListProvider = StreamProvider<List<CardMetaData>>((ref) {
  return ref.watch(cardRepositoryProvider).watchAllCards();
});

/// 首页：卡包。卡片轮播，点卡片翻转看详情，FAB 添加。
class CardListPage extends ConsumerWidget {
  const CardListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cardsAsync = ref.watch(cardListProvider);
    final banksAsync = ref.watch(bankCatalogProvider);
    final facesAsync = ref.watch(allFacesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('卡包'),
        actions: [
          IconButton(
            key: const Key('settings_button'),
            icon: const Icon(Icons.settings_outlined),
            tooltip: '设置',
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        key: const Key('add_card_button'),
        onPressed: () => context.push('/add'),
        child: const Icon(Icons.add),
      ),
      body: cardsAsync.when(
        data: (cards) => banksAsync.when(
          data: (banks) => facesAsync.when(
            data: (faces) => cards.isEmpty
                ? const _EmptyState()
                : Padding(
                    padding: const EdgeInsets.only(top: 48),
                    child: _CardCarouselView(
                      cards: cards,
                      banks: banks,
                      faces: faces,
                    ),
                  ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Center(child: Text('卡面库加载失败：$error')),
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(child: Text('银行列表加载失败：$error')),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('卡片加载失败：$error')),
      ),
    );
  }
}

class _CardCarouselView extends ConsumerWidget {
  const _CardCarouselView({
    required this.cards,
    required this.banks,
    required this.faces,
  });

  final List<CardMetaData> cards;
  final List<Bank> banks;
  final List<CardFace> faces;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CardCarousel(
      cards: cards,
      faces: faces,
      banks: banks,
      onEdit: (card) => context.push('/edit/${card.id}'),
      onDelete: (card) => _confirmDelete(context, ref, card),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    CardMetaData card,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('删除卡片'),
        content: const Text('将同时清除卡号等敏感信息，确定删除？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('确认删除'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(cardRepositoryProvider).deleteCard(card.id);
    }
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('还没有卡片'));
  }
}
