import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todavenda/app/app_bloc_observer.dart';
import 'package:todavenda/auth/bloc/auth_bloc.dart';
import 'package:todavenda/auth/services/auth_service.dart';
import 'package:todavenda/cart/bloc/cart_bloc.dart';
import 'package:todavenda/clients/clients.dart';
import 'package:todavenda/products/products.dart';
import 'package:todavenda/sales/sales.dart';

injectRepositories() {
  return [
    RepositoryProvider.value(value: AuthService()),
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
        productRepository: context.read<ProductRepository>(),
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
