import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:todavenda/app/app_menu.dart';
import 'package:todavenda/cart/cart.dart';
import 'package:todavenda/cart/pages/cart_page/cart_finalizing_page.dart';
import 'package:todavenda/products/products.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  static get routerConfig {
    return GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: '/carrinho',
      routes: [
        ShellRoute(
          builder: (context, state, child) {
            return AppMenu(
              key: state.pageKey,
              currentRoute: state.uri.pathSegments.first,
              child: AppMenuChild(child: child),
            );
          },
          routes: [
            GoRoute(
              path: '/carrinho',
              builder: (context, state) => const CartPage(),
              routes: [
                GoRoute(
                  path: 'confirmacao',
                  builder: (context, state) => const CartCheckoutPage(),
                ),
                GoRoute(
                  path: 'pagamento',
                  builder: (context, state) => const CartPaymentPage(),
                ),
                GoRoute(
                  path: 'finalizado',
                  builder: (context, state) => const CartFinalizingPage(),
                ),
              ],
            ),
            GoRoute(
              path: '/produtos',
              builder: (context, state) => const ProductListPage(),
              routes: [
                GoRoute(
                  path: 'categorias/cadastrar',
                  builder: (context, state) => const ProductCategoryFormPage(),
                ),
                GoRoute(
                  path: 'cadastrar',
                  builder: (context, state) => const ProductFormPage(),
                ),
                GoRoute(
                  path: ':uuid',
                  builder: (context, state) => ProductPage(
                    uuid: state.pathParameters['uuid']!,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
