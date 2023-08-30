import 'package:flutter/material.dart';
import 'package:todavenda/products/widgets/form_fields/product_categories_selector/product_categories_selector_list_page.dart';

import '../../../models/product_category.dart';

class ProductCategoriesSelector extends StatefulWidget {
  const ProductCategoriesSelector({
    super.key,
    this.decoration,
    this.initialValue,
    required this.onChanged,
  });

  final InputDecoration? decoration;
  final List<ProductCategory>? initialValue;
  final Function(List<ProductCategory> selected) onChanged;

  @override
  State<ProductCategoriesSelector> createState() =>
      _ProductCategoriesSelectorState();
}

class _ProductCategoriesSelectorState extends State<ProductCategoriesSelector> {
  late List<ProductCategory> selecteds;

  @override
  void initState() {
    selecteds = widget.initialValue ?? [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: widget.decoration ?? const InputDecoration(),
      child: Row(
        children: [
          Expanded(child: _buildSelectedCategories()),
          _buildAddIcon(context)
        ],
      ),
    );
  }

  Widget _buildSelectedCategories() {
    if (selecteds.isEmpty) {
      return const Text('Nenhuma categoria selecionada');
    }
    return Wrap(
      children: selecteds
          .map((e) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Chip(
                  backgroundColor:
                      Theme.of(context).colorScheme.primaryContainer,
                  padding: EdgeInsets.zero,
                  label: Text(e.name),
                  deleteIcon: const Icon(Icons.close),
                  onDeleted: () {
                    setState(() => selecteds.remove(e));
                    widget.onChanged(selecteds);
                  },
                ),
              ))
          .toList(),
    );
  }

  IconButton _buildAddIcon(BuildContext context) {
    return IconButton(
      onPressed: () => Navigator.of(context)
          .push<List<ProductCategory>>(
        MaterialPageRoute(
          builder: (context) => ProductCategoriesSelectorListPage(
            selectedCategories: selecteds,
          ),
          fullscreenDialog: true,
        ),
      )
          .then(
        (selecteds) {
          if (selecteds != null && selecteds.isNotEmpty) {
            setState(() => this.selecteds = selecteds);
            widget.onChanged(selecteds);
          }
        },
      ),
      icon: const Icon(Icons.add),
    );
  }
}
