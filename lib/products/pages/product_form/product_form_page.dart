import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todavenda/commons/widgets/currency_field.dart';
import 'package:todavenda/commons/widgets/exception_widget.dart';
import 'package:todavenda/commons/widgets/loading_widget.dart';

import './bloc/product_form_bloc.dart';
import '../../services/products_repository.dart';
import '../../widgets/form_fields/form_fields.dart';

class ProductFormPage extends StatelessWidget {
  const ProductFormPage({super.key, this.uuid});

  final String? uuid;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductFormBloc(context.read<ProductsRepository>())
        ..add(ProductFormStarted(uuid: uuid)),
      child: const ProductFormView(),
    );
  }
}

class ProductFormView extends StatelessWidget {
  const ProductFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Novo produto')),
      body: BlocConsumer<ProductFormBloc, ProductFormState>(
        listener: (context, state) {
          if (state is ProductFormSuccessfullySubmitted) {
            context.pop();
          }
        },
        builder: (context, state) {
          if (state is ProductFormLoading ||
              state is ProductFormSuccessfullySubmitted) {
            return const LoadingWidget();
          }

          if (state is ProductFormEditing) {
            var description = state.description;
            var price = state.price;
            var categories = state.categories;

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Descrição',
                        errorText: state.descriptionError,
                      ),
                      controller: TextEditingController(text: description),
                      onChanged: (value) => description = value,
                    ),
                    CurrencyField(
                      decoration: const InputDecoration(labelText: 'Preço'),
                      initialValue: price,
                      onChanged: (value) => price = value,
                    ),
                    ProductCategoriesSelector(
                      decoration:
                          const InputDecoration(labelText: 'Categorias'),
                      initialValue: categories,
                      onChanged: (value) => categories = value,
                    ),
                    const SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: () {
                        final event = ProductFormSubmitted(
                          uuid: state.uuid,
                          description: description,
                          price: price,
                          categories: categories,
                        );
                        context.read<ProductFormBloc>().add(event);
                      },
                      child: const Text('Salvar'),
                    ),
                  ],
                ),
              ),
            );
          }

          return ExceptionWidget(
            exception: state is ProductFormException ? state.ex : null,
          );
        },
      ),
    );
  }
}
