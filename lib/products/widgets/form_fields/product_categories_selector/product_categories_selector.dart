import 'package:flutter/material.dart';

import '../../../models/product_category.dart';
import 'product_categories_selector_list_page.dart';

class ProductCategoriesSelector extends StatelessWidget {
  const ProductCategoriesSelector({
    super.key,
    this.decoration,
    required this.initialValue,
    required this.onChanged,
  });

  final InputDecoration? decoration;
  final List<ProductCategory> initialValue;
  final Function(List<ProductCategory> selected) onChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context)
          .push<List<ProductCategory>>(
        MaterialPageRoute(
          builder: (context) => ProductCategoriesSelectorListPage(
            selectedCategories: initialValue,
          ),
          fullscreenDialog: true,
        ),
      )
          .then((selected) {
        if (selected != null) {
          onChanged(selected);
        }
      }),
      child: InputDecorator(
        decoration: decoration ?? const InputDecoration(),
        child: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    if (initialValue.isEmpty) {
      return const Text('Nenhuma categoria selecionada');
    }
    return Wrap(
      children: initialValue
          .map((e) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Chip(
                  padding: EdgeInsets.zero,
                  label: Text(e.name),
                  deleteIcon: const Icon(Icons.close),
                  onDeleted: () {
                    initialValue.remove(e);
                    onChanged(initialValue);
                  },
                ),
              ))
          .toList(),
    );
  }
}
