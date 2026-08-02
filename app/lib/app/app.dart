import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme/app_theme.dart';
import '../features/card_list/reveal_notifier.dart';
import 'router.dart';

/// 应用根组件。
class KabaoApp extends ConsumerStatefulWidget {
  const KabaoApp({super.key});

  @override
  ConsumerState<KabaoApp> createState() => _KabaoAppState();
}

class _KabaoAppState extends ConsumerState<KabaoApp> {
  late final AppLifecycleListener _lifecycleListener;

  @override
  void initState() {
    super.initState();
    _lifecycleListener = AppLifecycleListener(
      onStateChange: (state) {
        // 切后台/切走时强制隐藏明文卡号，防窥探。
        if (state == AppLifecycleState.inactive ||
            state == AppLifecycleState.paused) {
          ref.read(revealCardIdProvider.notifier).hide();
        }
      },
    );
  }

  @override
  void dispose() {
    _lifecycleListener.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: '卡包',
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      routerConfig: appRouter,
    );
  }
}
