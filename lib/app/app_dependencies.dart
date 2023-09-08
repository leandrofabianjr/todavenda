import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todavenda/auth/auth.dart';
import 'package:todavenda/cart/bloc/cart_bloc.dart';
import 'package:todavenda/companies/companies.dart';
import 'package:todavenda/data/firebase/firebase.dart';
import 'package:todavenda/products/products.dart';
import 'package:todavenda/sales/sales.dart';

import 'app_bloc_observer.dart';

injectRepositories() {
  return firebaseRepositoryProviders;
}

injectBlocProviders() {
  return [
    BlocProvider(
      create: (context) =>
          AuthBloc(context.read<AuthService>())..add(const AuthStarted()),
    ),
    BlocProvider(
      create: (context) => CompanySelectorBloc(
        context.read<CompaniesRepository>(),
      ),
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
