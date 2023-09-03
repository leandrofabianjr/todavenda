import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todavenda/app/app_router.dart';
import 'package:todavenda/cart/cart.dart';
import 'package:todavenda/clients/services/services.dart';
import 'package:todavenda/products/products.dart';
import 'package:todavenda/sales/sales.dart';

export 'app_bloc_observer.dart';

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
        RepositoryProvider.value(
          // ignore: unnecessary_cast
          value: ClientsRepositoryMock() as ClientsRepository,
        ),
      ],
      child: BlocProvider(
        create: (context) => CartBloc(
          productRepository: context.read<ProductRepository>(),
          salesRepository: context.read<SalesRepository>(),
        ),
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
      routerConfig: appRouterConfig,
    );
  }
}
