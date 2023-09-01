import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todavenda/app_bloc_observer.dart';
import 'package:todavenda/cart/cart.dart';
import 'package:todavenda/products/products.dart';
import 'package:todavenda/sales/sales.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = const AppBlocObserver();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(
          // ignore: unnecessary_cast
          value: ProductRepositoryMock() as ProductRepository,
        ),
        RepositoryProvider.value(
          // ignore: unnecessary_cast
          value: SalesRepositoryMock() as SalesRepository,
        ),
      ],
      child: BlocProvider(
        create: (context) => CartBloc(
          productRepository: context.read<ProductRepository>(),
          salesRepository: context.read<SalesRepository>(),
        )..add(const CartStarted()),
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Toda Venda',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: _router,
    );
  }
}

final _router = GoRouter(
  routes: [
    GoRoute(path: '/', redirect: (context, state) => '/carrinho'),
    GoRoute(
      path: '/carrinho',
      builder: (context, state) => const CartPage(),
      routes: [
        GoRoute(
          path: 'confirmar',
          builder: (context, state) => const CartCheckoutPage(),
        ),
      ],
    ),
    GoRoute(
      path: '/vendas/:uuid/pagamento',
      builder: (context, state) =>
          SalePaymentPage(saleUuid: state.pathParameters['uuid']!),
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
);
