import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todavenda/app_bloc_observer.dart';
import 'package:todavenda/products/products.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = const AppBlocObserver();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      // ignore: unnecessary_cast
      value: ProductRepositoryMock() as ProductRepository,
      child: const AppView(),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Toda Venda',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ProductListPage(),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
          case '/produtos':
            return MaterialPageRoute(builder: (_) => const ProductListPage());
          case '/produtos/novo':
            return MaterialPageRoute(builder: (_) => const ProductFormPage());
          default:
            return null;
        }
      },
    );
  }
}
