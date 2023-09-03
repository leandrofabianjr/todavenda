import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todavenda/cart/bloc/cart_bloc.dart';
import 'package:todavenda/clients/clients.dart';
import 'package:todavenda/firebase_options.dart';
import 'package:todavenda/products/products.dart';
import 'package:todavenda/sales/sales.dart';

import 'app_bloc_observer.dart';
import 'app_view.dart';

List<RepositoryProvider> injectRepositories() {
  return [
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

List<BlocProvider> injectBlocProviders() {
  return [
    BlocProvider(
      create: (context) => CartBloc(
        productRepository: context.read<ProductRepository>(),
        salesRepository: context.read<SalesRepository>(),
      ),
    ),
  ];
}

Future injectDependencies(AppView app) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  Bloc.observer = const AppBlocObserver();

  return MultiRepositoryProvider(
    providers: injectRepositories(),
    child: MultiBlocProvider(
      providers: injectBlocProviders(),
      child: app,
    ),
  );
}

Future<void> appBootstrap() async {
  await injectDependencies(const AppView());
}
