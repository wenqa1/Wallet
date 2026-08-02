import 'package:flutter/material.dart';

import '../../core/utils/card_number_mask.dart';
import 'card_scan_parser.dart';

/// 扫描命中后的确认卡片：展示识别结果，提供「重新扫描 / 确认使用」。
class ScanResultCard extends StatelessWidget {
  const ScanResultCard({
    super.key,
    required this.candidate,
    required this.onConfirm,
    required this.onRescan,
  });

  final CardScanCandidate candidate;
  final VoidCallback onConfirm;
  final VoidCallback onRescan;

  @override
  Widget build(BuildContext context) {
    final holderName = candidate.holderName;
    final expiry = candidate.expiry;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('识别到卡号', style: Theme.of(context).textTheme.labelMedium),
            const SizedBox(height: 4),
            Text(
              formatCardNumber(candidate.cardNumber),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                letterSpacing: 1.5,
              ),
            ),
            if (holderName != null) ...[
              const SizedBox(height: 8),
              Text('持卡人：$holderName'),
            ],
            if (expiry != null) ...[
              const SizedBox(height: 4),
              Text('有效期：$expiry'),
            ],
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(onPressed: onRescan, child: const Text('重新扫描')),
                const SizedBox(width: 8),
                FilledButton(onPressed: onConfirm, child: const Text('确认使用')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
