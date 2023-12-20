import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todavenda/commons/commons.dart';
import 'package:todavenda/flow/pages/flow_account/bloc/flow_account_bloc.dart';
import 'package:todavenda/flow/services/flow_accounts_service.dart';

class FlowAccountPage extends StatelessWidget {
  const FlowAccountPage({super.key, required this.uuid});

  final String uuid;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FlowAccountBloc(
        context.read<FlowAccountsRepository>(),
        uuid: uuid,
      )..add(const FlowAccountStarted()),
      child: const FlowAccountView(),
    );
  }
}

class FlowAccountView extends StatelessWidget {
  const FlowAccountView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: BlocBuilder<FlowAccountBloc, FlowAccountState>(
            builder: (context, state) {
              if (state is FlowAccountReady) {
                return Text(state.account.name);
              }
              return const SizedBox();
            },
          ),
          actions: [
            BlocBuilder<FlowAccountBloc, FlowAccountState>(
              builder: (context, state) {
                if (state is FlowAccountReady) {
                  return IconButton(
                    onPressed: () => context.go(
                      '/fluxo/contas/${state.account.uuid}/editar',
                    ),
                    icon: const Icon(Icons.edit),
                  );
                }
                return const SizedBox();
              },
            ),
          ]),
      body: BlocBuilder<FlowAccountBloc, FlowAccountState>(
        builder: (context, state) {
          if (state is FlowAccountLoading) {
            return const LoadingWidget();
          }

          if (state is FlowAccountReady) {
            final account = state.account;

            return ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                DescriptionDetail(
                  description: const Text('Saldo atual'),
                  detail: Text(
                    account.currentAmount.toCurrency(),
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                if (account.description != null)
                  DescriptionDetail(
                    description: const Text('Descrição'),
                    detail: Text(
                      account.description!,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
              ],
            );
          }

          return ExceptionWidget(
            exception: state is FlowAccountException ? state.ex : null,
          );
        },
      ),
    );
  }
}
