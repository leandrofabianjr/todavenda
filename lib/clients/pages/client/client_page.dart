import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CustomScrollView(
          slivers: [
            BlocBuilder<ClientBloc, ClientState>(
              builder: (context, state) {
                if (state is ClientLoaded) {
                  final client = state.client;
                  return SliverAppBar(
                    title: Text(client.name),
                  );
                }
                return const SliverAppBar();
              },
            ),
            BlocBuilder<ClientBloc, ClientState>(
              builder: (context, state) {
                if (state is ClientLoading) {
                  return const SliverFillRemaining(child: LoadingWidget());
                }

                if (state is ClientLoaded) {
                  final client = state.client;

                  return SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        DescriptionDetail(
                          name: const Text('Nome'),
                          detail: Text(
                            client.name,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        if (client.phone != null)
                          DescriptionDetail(
                            name: const Text('Telefone'),
                            detail: Text(
                              client.phone!,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                        if (client.address != null)
                          DescriptionDetail(
                            name: const Text('Endereço'),
                            detail: Text(
                              client.address!,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                        if (client.observation != null)
                          DescriptionDetail(
                            name: const Text('Observação'),
                            detail: Text(
                              client.observation!,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                      ],
                    ),
                  );
                }

                return SliverFillRemaining(
                  child: ExceptionWidget(
                    exception: state is ClientException ? state.ex : null,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class DescriptionDetail extends StatelessWidget {
  const DescriptionDetail({
    super.key,
    required this.name,
    required this.detail,
  });

  final Widget name;
  final Widget detail;

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.horizontal,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        name,
        Flexible(
          flex: 1,
          child: detail,
        ),
      ],
    );
  }
}
