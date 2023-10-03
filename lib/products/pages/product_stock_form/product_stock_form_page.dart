import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todavenda/commons/widgets/exception_widget.dart';
import 'package:todavenda/commons/widgets/loading_widget.dart';

import '../../services/products_repository.dart';
import 'bloc/product_stock_form_bloc.dart';

class ProductStockFormPage extends StatelessWidget {
  const ProductStockFormPage({super.key, required this.productUuid});

  final String productUuid;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductStockFormBloc(
        productRepository: context.read<ProductsRepository>(),
        productUuid: productUuid,
      )..add(const ProductStockFormStarted()),
      child: const ProductStockFormView(),
    );
  }
}

class ProductStockFormView extends StatelessWidget {
  const ProductStockFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Atualizar estoque')),
      body: BlocConsumer<ProductStockFormBloc, ProductStockFormState>(
        listener: (context, state) {
          if (state.status == ProductStockFormStatus.success) {
            context.pop();
          }
        },
        builder: (context, state) {
          if (state.status == ProductStockFormStatus.loading) {
            return const LoadingWidget();
          }

          if (state.status == ProductStockFormStatus.editing) {
            var quantity = state.quantity;
            var observation = state.observation;
            var quantityError = state.quantityError;
            var createdAt = state.createdAt;

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Quantidade',
                        errorText: quantityError,
                      ),
                      controller: quantity == null
                          ? null
                          : TextEditingController(
                              text: quantity.toString(),
                            ),
                      onChanged: (value) => quantity = int.tryParse(value) ?? 0,
                    ),
                    DateTimeFormField(
                      initialValue: createdAt,
                      decoration: const InputDecoration(
                        suffixIcon: Icon(Icons.event_note),
                        labelText: 'Adicionado em',
                      ),
                      mode: DateTimeFieldPickerMode.dateAndTime,
                      autovalidateMode: AutovalidateMode.always,
                      validator: (value) => value == null
                          ? 'Informe a data de atualização do estoque'
                          : null,
                      onDateSelected: (DateTime value) => createdAt = value,
                      use24hFormat: true,
                    ),
                    TextField(
                      decoration:
                          const InputDecoration(labelText: 'Observação'),
                      controller: TextEditingController(text: observation),
                      onChanged: (value) => observation = value,
                    ),
                    const SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: () {
                        final event = ProductStockFormSubmitted(
                          createdAt: createdAt,
                          quantity: quantity,
                          observation: observation,
                        );
                        context.read<ProductStockFormBloc>().add(event);
                      },
                      child: const Text('Salvar'),
                    ),
                  ],
                ),
              ),
            );
          }

          return ExceptionWidget(exception: state.exception);
        },
      ),
    );
  }
}
