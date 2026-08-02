import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';

/// 设置页：卡号遮挡时长 + 卡面库手动更新。
class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  static const _maskOptions = [3, 5, 10, 15];
  bool _checking = false;

  Future<void> _checkUpdate() async {
    setState(() => _checking = true);
    final result = await ref
        .read(cardFaceUpdateServiceProvider)
        .checkForUpdates();
    if (!mounted) return;
    setState(() => _checking = false);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(result.message ?? '未发现更新')));
  }

  @override
  Widget build(BuildContext context) {
    final maskAsync = ref.watch(maskAutoHideProvider);
    final cachedAsync = ref.watch(cachedFacesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('设置')),
      body: ListView(
        children: [
          const ListTile(title: Text('卡号遮挡'), subtitle: Text('识别卡号自动隐藏时长')),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: maskAsync.when(
              data: (seconds) => SegmentedButton<int>(
                key: const Key('mask_duration'),
                segments: [
                  for (final s in _maskOptions)
                    ButtonSegment(value: s, label: Text('$s 秒')),
                ],
                selected: {seconds},
                onSelectionChanged: (selection) async {
                  await ref
                      .read(settingsStoreProvider)
                      .setMaskAutoHideSeconds(selection.first);
                  ref.invalidate(maskAutoHideProvider);
                },
              ),
              loading: () => const LinearProgressIndicator(),
              error: (error, _) => Text('加载失败：$error'),
            ),
          ),
          const Divider(),
          const ListTile(title: Text('卡面库更新')),
          cachedAsync.when(
            data: (faces) => ListTile(
              title: const Text('已缓存远程卡面'),
              subtitle: Text('${faces.length} 张'),
            ),
            loading: () => const LinearProgressIndicator(),
            error: (error, _) => Text('加载失败：$error'),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: FilledButton.icon(
              key: const Key('check_update_button'),
              icon: _checking
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.refresh),
              label: Text(_checking ? '检查中…' : '检查卡面更新'),
              onPressed: _checking ? null : _checkUpdate,
            ),
          ),
        ],
      ),
    );
  }
}
