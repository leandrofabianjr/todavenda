import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todavenda/commons/widgets/exception_widget.dart';
import 'package:todavenda/commons/widgets/loading_widget.dart';

import '../../../models/product_category.dart';
import '../../../services/product_repository.dart';
import '../../form_fields/product_categories_selector/bloc/product_categories_selector_bloc.dart';

class ProductCategoriesSelectorListPage extends StatelessWidget {
  const ProductCategoriesSelectorListPage({
    super.key,
    required this.selectedCategories,
  });

  final List<ProductCategory> selectedCategories;

  @override
  Widget build(BuildContext context) {
    final repository = context.read<ProductRepository>();
    final event = ProductCategoriesSelectorStarted(
      initialSelectedCategories: selectedCategories,
    );
    return BlocProvider(
      create: (context) =>
          ProductCategoriesSelectorBloc(repository)..add(event),
      child: const ProductCategoriesSelectorListView(),
    );
  }
}

class ProductCategoriesSelectorListView extends StatelessWidget {
  const ProductCategoriesSelectorListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categorias de Produtos'),
        actions: [
          IconButton(
            onPressed: () => context.go('/produtos/categorias/novo'),
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: BlocConsumer<ProductCategoriesSelectorBloc,
          ProductCategoriesSelectorState>(
        listener: (context, state) {
          if (state is ProductCategoriesSelectorSubmitting) {
            context.pop(state.selectedCategories);
          }
        },
        builder: (context, state) {
          if (state is ProductCategoriesSelectorLoading ||
              state is ProductCategoriesSelectorSubmitting) {
            return const LoadingWidget();
          }

          if (state is ProductCategoriesSelectorLoaded) {
            if (state.categories.isEmpty) {
              return const Center(child: Text('Não há categorias cadastradas'));
            }

            return ListView(
              children: state.categories.entries.map(
                (mappedCategory) {
                  final category = mappedCategory.key;
                  final isSelected = mappedCategory.value;
                  return ProductCategoriesSelectorListTile(
                    isSelected: isSelected,
                    title: Text(category.name),
                    subtitle: category.description == null
                        ? null
                        : Text(category.description!),
                    onChanged: () => context
                        .read<ProductCategoriesSelectorBloc>()
                        .add(ProductCategoriesSelectorSelected(
                          selectedCategory: category,
                        )),
                  );
                },
              ).toList(),
            );
          }

          final exception =
              state is ProductCategoriesSelectorException ? state.ex : null;
          return ExceptionWidget(exception: exception);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.read<ProductCategoriesSelectorBloc>().add(
              ProductCategoriesSelectorSubmitted(),
            ),
        child: const Icon(Icons.check),
      ),
    );
  }
}

class ProductCategoriesSelectorListTile extends StatefulWidget {
  const ProductCategoriesSelectorListTile({
    super.key,
    required this.onChanged,
    this.isSelected,
    this.title,
    this.subtitle,
  });

  final void Function() onChanged;
  final bool? isSelected;
  final Widget? title;
  final Widget? subtitle;

  @override
  State<ProductCategoriesSelectorListTile> createState() =>
      _ProductCategoriesSelectorListTileState();
}

class _ProductCategoriesSelectorListTileState
    extends State<ProductCategoriesSelectorListTile> {
  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      onChanged: (_) => widget.onChanged(),
      value: widget.isSelected,
      title: widget.title,
      subtitle: widget.subtitle,
    );
  }
}
