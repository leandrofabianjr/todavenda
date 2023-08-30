import 'package:flutter/material.dart';
import 'package:todavenda/products/models/models.dart';

class ProductCategoriesChipList extends StatelessWidget {
  const ProductCategoriesChipList({
    super.key,
    this.categories,
    this.onDeleted,
  });

  final List<ProductCategory>? categories;
  final Function(ProductCategory category)? onDeleted;

  @override
  Widget build(BuildContext context) {
    if (categories == null) {
      return const SizedBox();
    }
    return Wrap(
      children: categories!
          .map((c) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Chip(
                  backgroundColor:
                      Theme.of(context).colorScheme.primaryContainer,
                  padding: EdgeInsets.zero,
                  label: Text(c.name),
                  onDeleted: onDeleted != null ? () => onDeleted!(c) : null,
                ),
              ))
          .toList(),
    );
  }
}
