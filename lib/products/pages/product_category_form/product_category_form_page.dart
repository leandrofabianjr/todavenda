import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todavenda/commons/commons.dart';

import '../../pages/product_category_form/bloc/product_category_form_bloc.dart';
import '../../services/product_categories_repository.dart';

class ProductCategoryFormPage extends StatelessWidget {
  const ProductCategoryFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductCategoryFormBloc(
        context.read<ProductCategoriesRepository>(),
      ),
      child: const ProductCategoryFormView(),
    );
  }
}

class ProductCategoryFormView extends StatelessWidget {
  const ProductCategoryFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nova categoria de produto')),
      body: BlocConsumer<ProductCategoryFormBloc, ProductCategoryFormState>(
        listener: (context, state) {
          if (state is ProductCategoryFormSuccessfullySubmitted) {
            context.pop();
          }
        },
        builder: (context, state) {
          if (state is ProductCategoryFormSubmitting ||
              state is ProductCategoryFormSuccessfullySubmitted) {
            return const LoadingWidget();
          }

          if (state is ProductCategoryFormEditing) {
            var name = state.name;
            var description = state.description;

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
                    const SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: () {
                        final event = ProductCategoryFormSubmitted(
                          name: name,
                          description: description,
                        );
                        context.read<ProductCategoryFormBloc>().add(event);
                      },
                      child: const Text('Salvar'),
                    ),
                  ],
                ),
              ),
            );
          }

          return ExceptionWidget(
            exception: state is ProductCategoryFormException ? state.ex : null,
          );
        },
      ),
    );
  }
}
