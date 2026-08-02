import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../core/utils/card_number_mask.dart';
import '../../data/models/card_face.dart';
import '../../shared/widgets/card_face_widget.dart';

/// 内置卡面清单（异步加载）。
final bundledFacesProvider = FutureProvider<List<CardFace>>((ref) {
  return ref.watch(cardFaceRepositoryProvider).loadBundledFaces();
});

/// 首页：卡包列表。骨架阶段展示内置卡面预览，M1 起接入真实卡片数据。
class CardListPage extends ConsumerWidget {
  const CardListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final facesAsync = ref.watch(bundledFacesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('卡包')),
      body: facesAsync.when(
        data: (faces) => _buildBody(context, faces),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('卡面加载失败：$error')),
      ),
    );
  }

  Widget _buildBody(BuildContext context, List<CardFace> faces) {
    if (faces.isEmpty) {
      return const Center(child: Text('还没有卡片'));
    }

    final sample = faces.firstWhere(
      (face) => face.bankCode == 'CMB',
      orElse: () => faces.first,
    );

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const Text('示例卡 · 内置卡面预览', style: TextStyle(fontSize: 12)),
        const SizedBox(height: 8),
        CardFaceWidget(
          face: sample,
          nickname: '工资卡',
          cardNumberMasked: maskCardNumber('6225882000001234'),
          balance: '¥ 12,800.00',
        ),
        const SizedBox(height: 24),
        Text(
          '内置卡面库：${faces.length} 张（银行配色 + 行名，合规设计）',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
