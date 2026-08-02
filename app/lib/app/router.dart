import 'package:go_router/go_router.dart';

import '../features/add_card/card_form_page.dart';
import '../features/card_list/card_list_page.dart';

/// 全局路由表。
final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const CardListPage()),
    GoRoute(path: '/add', builder: (context, state) => const CardFormPage()),
    GoRoute(
      path: '/edit/:id',
      builder: (context, state) =>
          CardFormPage(cardId: state.pathParameters['id']),
    ),
  ],
);
