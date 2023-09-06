import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todavenda/auth/auth.dart';
import 'package:todavenda/cart/bloc/cart_bloc.dart';
import 'package:todavenda/clients/clients.dart';
import 'package:todavenda/data/data.dart';
import 'package:todavenda/products/products.dart';
import 'package:todavenda/sales/sales.dart';

import 'app_bloc_observer.dart';

injectRepositories() {
  // ignore: unnecessary_cast
  final authService = AuthServiceFirebase() as AuthService;
  return [
    RepositoryProvider.value(value: authService),
    RepositoryProvider.value(
      // ignore: unnecessary_cast
      value: UsersRepositoryFirestore(authService) as UsersRepository,
    ),
    RepositoryProvider.value(
      // ignore: unnecessary_cast
      value: ProductsRepositoryMock() as ProductsRepository,
    ),
    RepositoryProvider.value(
      // ignore: unnecessary_cast
      value: SalesRepositoryMock() as SalesRepository,
    ),
    RepositoryProvider.value(
      // ignore: unnecessary_cast
      value: ClientsRepositoryMock() as ClientsRepository,
    ),
  ];
}

injectBlocProviders() {
  return [
    BlocProvider(
      create: (context) =>
          AuthBloc(context.read<AuthService>())..add(const AuthStarted()),
    ),
    BlocProvider(
      create: (context) => CartBloc(
        productRepository: context.read<ProductsRepository>(),
        salesRepository: context.read<SalesRepository>(),
      ),
    ),
  ];
}

Widget injectDependencies({required Widget child}) {
  Bloc.observer = const AppBlocObserver();

  return MultiRepositoryProvider(
    providers: injectRepositories(),
    child: MultiBlocProvider(
      providers: injectBlocProviders(),
      child: child,
    ),
  );
}
