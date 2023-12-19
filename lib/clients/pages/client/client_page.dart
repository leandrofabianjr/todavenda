import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todavenda/commons/commons.dart';

import '../../clients.dart';
import 'bloc/client_bloc.dart';

class ClientPage extends StatelessWidget {
  const ClientPage({super.key, required this.uuid});

  final String uuid;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ClientBloc(
        context.read<ClientsRepository>(),
        uuid: uuid,
      )..add(const ClientStarted()),
      child: const ClientView(),
    );
  }
}

class ClientView extends StatelessWidget {
  const ClientView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<ClientBloc, ClientState>(
          builder: (context, state) {
            if (state is ClientReady) {
              return Text(state.client.name);
            }
            return const SizedBox();
          },
        ),
        actions: [
          BlocBuilder<ClientBloc, ClientState>(
            builder: (context, state) {
              if (state is ClientReady) {
                return IconButton(
                  onPressed: () => context
                      .go('/cadastros/clientes/${state.client.uuid}/editar'),
                  icon: const Icon(Icons.edit),
                );
              }
              return const SizedBox();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<ClientBloc, ClientState>(
          builder: (context, state) {
            if (state is ClientLoading) {
              return const LoadingWidget();
            }

            if (state is ClientReady) {
              final client = state.client;

              return Column(
                children: [
                  DescriptionDetail(
                    description: const Text('Nome'),
                    detail: Text(
                      client.name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  if (client.phone != null)
                    DescriptionDetail(
                      description: const Text('Telefone'),
                      detail: Text(
                        client.phone!,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  if (client.address != null)
                    DescriptionDetail(
                      description: const Text('Endereço'),
                      detail: Text(
                        client.address!,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  if (client.observation != null)
                    DescriptionDetail(
                      description: const Text('Observação'),
                      detail: Text(
                        client.observation!,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  // if (owings.isNotEmpty)
                  //   {
                  //     // TODO mostrar dívidas fiadas
                  //   }
                ],
              );
            }

            return ExceptionWidget(
              exception: state is ClientException ? state.ex : null,
            );
          },
        ),
      ),
    );
  }
}
