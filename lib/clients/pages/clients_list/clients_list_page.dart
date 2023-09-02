import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todavenda/commons/widgets/exception_widget.dart';
import 'package:todavenda/commons/widgets/loading_widget.dart';

import '../../models/client.dart';
import '../../services/client_repository.dart';
import 'bloc/clients_list_bloc.dart';

class ClientListPage extends StatelessWidget {
  const ClientListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ClientListBloc(context.read<ClientsRepository>())
        ..add(ClientListStarted()),
      child: const ClientListView(),
    );
  }
}

class ClientListView extends StatelessWidget {
  const ClientListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const ClientListAppBar(),
          BlocBuilder<ClientListBloc, ClientListState>(
            builder: (context, state) {
              if (state is ClientListLoading) {
                return const SliverFillRemaining(child: LoadingWidget());
              }

              if (state is ClientListLoaded) {
                state.clients.map((p) => ClientListViewTile(p)).toList();

                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => ClientListViewTile(
                      state.clients[index],
                    ),
                    childCount: state.clients.length,
                  ),
                );
              }

              return SliverFillRemaining(
                child: ExceptionWidget(
                  exception: state is ClientListException ? state.ex : null,
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            context.push('/cadastros/clientes/cadastrar').then((value) {
          context.read<ClientListBloc>().add(ClientListStarted());
        }),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class ClientListAppBar extends StatelessWidget {
  const ClientListAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const SliverAppBar(
      title: Text('Clientes'),
      floating: true,
    );
  }
}

class ClientListViewTile extends StatelessWidget {
  const ClientListViewTile(this.client, {super.key});

  final Client client;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.person),
      title: Text(client.name),
      onTap: () => context.go('/cadastros/clientes/${client.uuid}'),
    );
  }
}
