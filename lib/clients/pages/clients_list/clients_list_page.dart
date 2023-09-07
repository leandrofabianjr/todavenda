import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todavenda/commons/widgets/exception_widget.dart';
import 'package:todavenda/commons/widgets/loading_widget.dart';
import 'package:todavenda/companies/companies.dart';

import '../../models/client.dart';
import '../../services/clients_repository.dart';
import 'bloc/clients_list_bloc.dart';

class ClientListPage extends StatelessWidget {
  const ClientListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final companyUuid = CompanySelectorBloc.getCompanyUuid(context);
    return BlocProvider(
      create: (context) => ClientListBloc(context.read<ClientsRepository>())
        ..add(ClientListStarted(companyUuid: companyUuid)),
      child: const ClientListView(),
    );
  }
}

class ClientListView extends StatelessWidget {
  const ClientListView({super.key});

  @override
  Widget build(BuildContext context) {
    final companyUuid = CompanySelectorBloc.getCompanyUuid(context);
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
                final clients = state.clients;

                if (clients.isEmpty) {
                  return const SliverFillRemaining(
                    child: Center(child: Text('Não há clientes cadastrados')),
                  );
                }

                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => ClientListViewTile(
                      clients[index],
                    ),
                    childCount: clients.length,
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
        onPressed: () => context.push('/cadastros/clientes/cadastrar').then(
          (value) {
            context
                .read<ClientListBloc>()
                .add(ClientListStarted(companyUuid: companyUuid));
          },
        ),
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
      subtitle: client.phone != null ? Text(client.phone!) : null,
      onTap: () => context.go('/cadastros/clientes/${client.uuid}'),
    );
  }
}
