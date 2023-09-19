import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:todavenda/app/router/guards/auth_guard.dart';
import 'package:todavenda/auth/auth.dart';
import 'package:todavenda/cart/cart.dart';
import 'package:todavenda/cart/pages/pages.dart';
import 'package:todavenda/clients/pages/pages.dart';
import 'package:todavenda/me/pages/me_page.dart';
import 'package:todavenda/products/pages/pages.dart';
import 'package:todavenda/registers/pages/pages.dart';
import 'package:todavenda/reports/pages/pages.dart';
import 'package:todavenda/sales/pages/pages.dart';
import 'package:todavenda/session/pages/pages.dart';

import '../app_tab_bar.dart';
import 'app_router_observer.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _cartNavigatorKey = GlobalKey<NavigatorState>();
final _reportsNavigatorKey = GlobalKey<NavigatorState>();
final _registersNavigatorKey = GlobalKey<NavigatorState>();
final _meNavigatorKey = GlobalKey<NavigatorState>();

final appRouterConfig = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  observers: [AppRouterObserver()],
  redirect: (context, state) => authGuard(context),
  routes: [
    GoRoute(path: '/', redirect: (context, state) => '/vender'),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return AppTabBar(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          navigatorKey: _cartNavigatorKey,
          routes: <RouteBase>[
            GoRoute(
              path: '/caixa',
              builder: (context, state) => const SessionSummaryPage(),
              routes: [
                GoRoute(
                  path: 'abrir',
                  builder: (context, state) => const CreateSessionPage(),
                ),
                GoRoute(
                  path: 'suprir',
                  builder: (context, state) => const CreateSessionSupplyPage(),
                ),
                GoRoute(
                  path: 'sangrar',
                  builder: (context, state) => const CreateSessionPickUpPage(),
                ),
                GoRoute(
                  path: 'fechar',
                  builder: (context, state) => const CloseSessionPage(),
                ),
              ],
            ),
            GoRoute(
              path: '/vender',
              builder: (context, state) => const SellPage(),
              routes: [
                GoRoute(
                  path: 'confirmacao',
                  builder: (context, state) => const SellCheckoutPage(),
                ),
                GoRoute(
                  path: 'pagamento',
                  builder: (context, state) => const SellPaymentPage(),
                ),
                GoRoute(
                  path: 'finalizado',
                  builder: (context, state) => const SellFinalizingPage(),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _reportsNavigatorKey,
          routes: <RouteBase>[
            GoRoute(
              path: '/relatorios',
              builder: (context, state) => const ReportsMenuPage(),
              routes: [
                GoRoute(
                  path: 'vendas',
                  builder: (context, state) => const SalesListPage(),
                  routes: [
                    GoRoute(
                      path: ':uuid',
                      builder: (context, state) => SalePage(
                        uuid: state.pathParameters['uuid']!,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _registersNavigatorKey,
          routes: <RouteBase>[
            GoRoute(
              path: '/cadastros',
              builder: (context, state) => const RegistersMenuPage(),
              routes: [
                GoRoute(
                  path: 'produtos',
                  builder: (context, state) => const ProductListPage(),
                  routes: [
                    GoRoute(
                      path: 'categorias/cadastrar',
                      builder: (context, state) =>
                          const ProductCategoryFormPage(),
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
                GoRoute(
                  path: 'clientes',
                  builder: (context, state) => const ClientListPage(),
                  routes: [
                    GoRoute(
                      path: 'cadastrar',
                      builder: (context, state) => const ClientFormPage(),
                    ),
                    GoRoute(
                      path: ':uuid',
                      builder: (context, state) => ClientPage(
                        uuid: state.pathParameters['uuid']!,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _meNavigatorKey,
          routes: <RouteBase>[
            GoRoute(
              path: '/eu',
              builder: (context, state) => const MePage(),
            ),
          ],
        ),
      ],
    ),
  ],
);
