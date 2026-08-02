import 'package:go_router/go_router.dart';

import '../features/card_list/card_list_page.dart';

/// 全局路由表。
final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const CardListPage()),
  ],
);
