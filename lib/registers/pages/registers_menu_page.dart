import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:todavenda/commons/widgets/widgets.dart';

class RegistersMenuPage extends StatelessWidget {
  const RegistersMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(title: Text('Cadastros')),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                const ListSubtitle(title: 'Produtos'),
                ListTile(
                  leading: const Icon(Icons.inventory),
                  title: const Text('Produtos'),
                  onTap: () => context.go('/cadastros/produtos'),
                ),
                ListTile(
                  leading: const Icon(Icons.category),
                  title: const Text('Categorias de Produtos'),
                  onTap: () => context.go('/cadastros/produtos/categorias'),
                ),
                const ListSubtitle(title: 'Clientes'),
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('Clientes'),
                  onTap: () => context.go('/cadastros/clientes'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
