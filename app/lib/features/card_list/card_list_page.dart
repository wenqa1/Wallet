import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../core/constants/bank_catalog.dart';
import '../../core/face/card_face_resolver.dart';
import '../../data/local/app_database.dart';
import '../../data/models/card_face.dart';
import '../../shared/widgets/card_tile.dart';

/// 卡片列表流（实时监听数据库变更）。
final cardListProvider = StreamProvider<List<CardMetaData>>((ref) {
  return ref.watch(cardRepositoryProvider).watchAllCards();
});

/// 首页：卡包。网格展示真实卡片，FAB 添加，点卡片可编辑/删除。
class CardListPage extends ConsumerWidget {
  const CardListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cardsAsync = ref.watch(cardListProvider);
    final banksAsync = ref.watch(bankCatalogProvider);
    final facesAsync = ref.watch(allFacesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('卡包')),
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
                : _CardGrid(cards: cards, banks: banks, faces: faces),
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

class _CardGrid extends ConsumerWidget {
  const _CardGrid({
    required this.cards,
    required this.banks,
    required this.faces,
  });

  final List<CardMetaData> cards;
  final List<Bank> banks;
  final List<CardFace> faces;

  static const _resolver = CardFaceResolver();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 380,
        mainAxisExtent: 200,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: cards.length,
      itemBuilder: (context, index) {
        final card = cards[index];
        return InkWell(
          key: Key('card_${card.id}'),
          borderRadius: BorderRadius.circular(16),
          onTap: () => _showActions(context, ref, card),
          child: CardTile(
            card: card,
            resolution: _resolver.resolve(
              card: card,
              bundledFaces: faces,
              banks: banks,
            ),
          ),
        );
      },
    );
  }

  Future<void> _showActions(
    BuildContext context,
    WidgetRef ref,
    CardMetaData card,
  ) async {
    final action = await showModalBottomSheet<String>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: const Text('编辑'),
              onTap: () => Navigator.pop(sheetContext, 'edit'),
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline),
              title: const Text('删除'),
              onTap: () => Navigator.pop(sheetContext, 'delete'),
            ),
          ],
        ),
      ),
    );

    if (!context.mounted) return;

    if (action == 'edit') {
      context.push('/edit/${card.id}');
    } else if (action == 'delete') {
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
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('还没有卡片'));
  }
}
