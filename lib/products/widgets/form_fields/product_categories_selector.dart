import 'package:flutter/material.dart';

import '../../models/product_category.dart';
import '../../pages/product_categories_selector/product_categories_selector_list_page.dart';
import '../../widgets/product_categories_chip_list.dart';

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
          IconButton(
            onPressed: () => openAddPage(),
            icon: const Icon(Icons.add),
          )
        ],
      ),
    );
  }

  Widget _buildSelectedCategories() {
    if (selecteds.isEmpty) {
      return GestureDetector(
        onTap: openAddPage,
        child: const Text('Nenhuma categoria selecionada'),
      );
    }

    return ProductCategoriesChipList(
      categories: selecteds,
      onDeleted: (category) {
        setState(() => selecteds.remove(category));
        widget.onChanged(selecteds);
      },
    );
  }

  void openAddPage() {
    final page = MaterialPageRoute<List<ProductCategory>>(
      builder: (context) => ProductCategoriesSelectorListPage(
        selectedCategories: selecteds,
      ),
      fullscreenDialog: true,
    );

    Navigator.of(context).push(page).then(
      (selecteds) {
        if (selecteds != null && selecteds.isNotEmpty) {
          setState(() => this.selecteds = selecteds);
          widget.onChanged(selecteds);
        }
      },
    );
  }
}
