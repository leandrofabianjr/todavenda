import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todavenda/commons/commons.dart';
import 'package:todavenda/flow/pages/flow_account_form/bloc/flow_account_form_bloc.dart';
import 'package:todavenda/flow/services/flow_accounts_repository.dart';

class FlowAccountFormPage extends StatelessWidget {
  const FlowAccountFormPage({super.key, this.uuid});

  final String? uuid;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FlowAccountFormBloc(
        context.read<FlowAccountsRepository>(),
        uuid: uuid,
      )..add(FlowAccountFormStarted(uuid: uuid)),
      child: const FlowAccountFormView(),
    );
  }
}

class FlowAccountFormView extends StatelessWidget {
  const FlowAccountFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nova conta')),
      body: BlocConsumer<FlowAccountFormBloc, FlowAccountFormState>(
        listener: (context, state) {
          if (state is FlowAccountFormSuccessfullySubmitted) {
            context.pop();
          }
        },
        builder: (context, state) {
          if (state is FlowAccountFormSubmitting ||
              state is FlowAccountFormSuccessfullySubmitted) {
            return const LoadingWidget();
          }

          if (state is FlowAccountFormEditing) {
            var name = state.name;
            var description = state.description;
            var currentAmount = state.currentAmount;

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Nome',
                        errorText: state.nameError,
                      ),
                      controller: TextEditingController(text: name),
                      onChanged: (value) => name = value,
                    ),
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'Descrição',
                      ),
                      controller: TextEditingController(text: description),
                      onChanged: (value) => description = value,
                    ),
                    if (state.uuid == null)
                      CurrencyField(
                        decoration: const InputDecoration(
                          labelText: 'Saldo atual',
                        ),
                        initialValue: currentAmount,
                        onChanged: (value) => currentAmount = value,
                      ),
                    const SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: () {
                        final event = FlowAccountFormSubmitted(
                          uuid: state.uuid,
                          name: name,
                          description: description,
                          currentAmount: currentAmount,
                        );
                        context.read<FlowAccountFormBloc>().add(event);
                      },
                      child: const Text('Salvar'),
                    ),
                  ],
                ),
              ),
            );
          }

          return ExceptionWidget(
            exception: state is FlowAccountFormException ? state.ex : null,
          );
        },
      ),
    );
  }
}
