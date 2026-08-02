import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../core/utils/card_number_mask.dart';
import '../../data/local/app_database.dart';
import '../../features/card_list/reveal_notifier.dart';

/// 卡片背面详情：卡号遮挡（长按临时显示 + 自动隐藏）、持卡人、有效期、CVV、余额。
class CardBackDetails extends ConsumerWidget {
  const CardBackDetails({
    super.key,
    required this.card,
    this.onEdit,
    this.onDelete,
  });

  final CardMetaData card;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final revealed = ref.watch(revealCardIdProvider) == card.id;
    final secretAsync = ref.watch(cardSecretProvider(card.id));
    final maskSecondsAsync = ref.watch(maskAutoHideProvider);
    final secret = secretAsync.valueOrNull;

    final number = revealed && secret != null
        ? formatCardNumber(secret.cardNumber)
        : '•••• ${card.last4 ?? ''}';

    void onLongPress() {
      final seconds = maskSecondsAsync.valueOrNull ?? 5;
      ref
          .read(revealCardIdProvider.notifier)
          .reveal(card.id, Duration(seconds: seconds));
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _row(context, '卡号（长按显示）', number, onLongPress: onLongPress),
          _row(context, '持卡人', secret?.holderName ?? '-'),
          _row(context, '有效期', secret?.expiry ?? '-'),
          _row(context, 'CVV', secret?.cvv == null ? '-' : '•••'),
          _row(
            context,
            '余额',
            card.balance == null
                ? '-'
                : '${card.currency} ${card.balance!.toStringAsFixed(2)}',
          ),
          const SizedBox(height: 8),
          if (onEdit != null || onDelete != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (onDelete != null)
                  TextButton.icon(
                    onPressed: onDelete,
                    icon: const Icon(Icons.delete_outline, size: 18),
                    label: const Text('删除'),
                  ),
                if (onEdit != null)
                  TextButton.icon(
                    onPressed: onEdit,
                    icon: const Icon(Icons.edit_outlined, size: 18),
                    label: const Text('编辑'),
                  ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _row(
    BuildContext context,
    String label,
    String value, {
    VoidCallback? onLongPress,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: GestureDetector(
              onLongPress: onLongPress,
              child: Text(
                value,
                textAlign: TextAlign.end,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
