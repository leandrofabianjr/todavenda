import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todavenda/commons/widgets/exception_widget.dart';
import 'package:todavenda/commons/widgets/loading_widget.dart';

import '../../services/client_repository.dart';
import 'bloc/client_form_bloc.dart';

class ClientFormPage extends StatelessWidget {
  const ClientFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ClientFormBloc(context.read<ClientsRepository>()),
      child: const ClientFormView(),
    );
  }
}

class ClientFormView extends StatelessWidget {
  const ClientFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Novo cliente')),
      body: BlocConsumer<ClientFormBloc, ClientFormState>(
        listener: (context, state) {
          if (state is ClientFormSuccessfullySubmitted) {
            context.pop();
          }
        },
        builder: (context, state) {
          if (state is ClientFormSubmitting ||
              state is ClientFormSuccessfullySubmitted) {
            return const LoadingWidget();
          }

          if (state is ClientFormEditing) {
            var name = state.name;

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
                    const SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: () {
                        final event = ClientFormSubmitted(name: name);
                        context.read<ClientFormBloc>().add(event);
                      },
                      child: const Text('Salvar'),
                    ),
                  ],
                ),
              ),
            );
          }

          return ExceptionWidget(
            exception: state is ClientFormException ? state.ex : null,
          );
        },
      ),
    );
  }
}
