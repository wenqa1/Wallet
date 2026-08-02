import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';
import 'router.dart';

/// 应用根组件。
class KabaoApp extends StatelessWidget {
  const KabaoApp({super.key});

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
