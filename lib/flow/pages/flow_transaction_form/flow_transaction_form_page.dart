import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todavenda/commons/commons.dart';
import 'package:todavenda/flow/models/flow_account.dart';
import 'package:todavenda/flow/models/flow_transaction.dart';
import 'package:todavenda/flow/pages/flow_transaction_form/bloc/flow_transaction_form_bloc.dart';
import 'package:todavenda/flow/services/flow_accounts_repository.dart';
import 'package:todavenda/flow/services/flow_transactions_repository.dart';

class FlowTransactionFormPage extends StatelessWidget {
  const FlowTransactionFormPage({super.key, this.uuid});

  final String? uuid;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FlowTransactionFormBloc(
        uuid: uuid,
        flowTransactionsRepository: context.read<FlowTransactionsRepository>(),
        flowAccountsRepository: context.read<FlowAccountsRepository>(),
      )..add(FlowTransactionFormStarted(uuid: uuid)),
      child: const FlowTransactionFormView(),
    );
  }
}

class FlowTransactionFormView extends StatelessWidget {
  const FlowTransactionFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nova transação')),
      body: BlocConsumer<FlowTransactionFormBloc, FlowTransactionFormState>(
        listener: (context, state) {
          if (state is FlowTransactionFormSuccessfullySubmitted) {
            context.pop();
          }
        },
        builder: (context, state) {
          if (state is FlowTransactionFormSubmitting ||
              state is FlowTransactionFormSuccessfullySubmitted) {
            return const LoadingWidget();
          }

          if (state is FlowTransactionFormEditing) {
            var type = state.type;
            var account = state.account;
            var description = state.description;
            var observation = state.observation;
            var amount = state.amount;
            var createdAt = state.createdAt ?? DateTime.now();

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    DropdownButtonFormField<FlowAccount>(
                      decoration: InputDecoration(
                        labelText: 'Conta',
                        errorText: state.accountError,
                      ),
                      value: account,
                      items: (state.accounts ?? [])
                          .map<DropdownMenuItem<FlowAccount>>(
                            (a) => DropdownMenuItem(
                              value: a,
                              child: Text(a.name),
                            ),
                          )
                          .toList(),
                      onChanged: (value) => account = value,
                    ),
                    const SizedBox(height: 8),
                    FlowTransactionTypeSelector(
                      initialValue: type,
                      onChanged: (value) => type = value,
                    ),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Descrição',
                        errorText: state.descriptionError,
                      ),
                      controller: TextEditingController(text: description),
                      onChanged: (value) => description = value,
                    ),
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'Observação',
                      ),
                      controller: TextEditingController(text: observation),
                      onChanged: (value) => observation = value,
                    ),
                    CurrencyField(
                      decoration: InputDecoration(
                        labelText: 'Valor',
                        errorText: state.amountError,
                      ),
                      initialValue: amount,
                      onChanged: (value) => amount = value,
                    ),
                    const SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: () {
                        final event = FlowTransactionFormSubmitted(
                          uuid: state.uuid,
                          type: type,
                          description: description,
                          observation: observation,
                          amount: amount,
                          createdAt: createdAt,
                          account: account,
                        );
                        context.read<FlowTransactionFormBloc>().add(event);
                      },
                      child: const Text('Salvar'),
                    ),
                  ],
                ),
              ),
            );
          }

          return ExceptionWidget(
            exception: state is FlowTransactionFormException ? state.ex : null,
          );
        },
      ),
    );
  }
}

class FlowTransactionTypeSelector extends StatefulWidget {
  const FlowTransactionTypeSelector({
    super.key,
    this.initialValue,
    required this.onChanged,
  });

  final FlowTransactionType? initialValue;
  final Function(dynamic value) onChanged;

  @override
  State<FlowTransactionTypeSelector> createState() =>
      _FlowTransactionTypeSelectorState();
}

class _FlowTransactionTypeSelectorState
    extends State<FlowTransactionTypeSelector> {
  late FlowTransactionType value;

  @override
  void initState() {
    value = widget.initialValue ?? FlowTransactionType.incoming;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: _buildButton(FlowTransactionType.incoming),
        ),
        Expanded(
          child: _buildButton(FlowTransactionType.outgoing),
        ),
      ],
    );
  }

  _buildButton(FlowTransactionType type) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: value == type ? type.color : null,
        foregroundColor: value == type ? Colors.white : Colors.grey,
        elevation: value == type ? 1 : 0,
        shape: const LinearBorder(),
      ),
      icon: Icon(type.icon),
      label: Text(type.label),
      onPressed: () {
        setState(() => value = type);
        widget.onChanged(value);
      },
    );
  }
}
