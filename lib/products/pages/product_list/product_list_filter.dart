import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum ProductListShow {
  all,
  onlyStockControlled,
  notStockControlled,
}

enum ProductListSort {
  description,
  price,
  stock,
  createdAt,
}

class ProductListFilter {
  ProductListFilter({
    this.searchTerm,
    this.show = ProductListShow.all,
    this.sortBy = ProductListSort.description,
    this.sortDesc = false,
  });

  String? searchTerm;
  ProductListShow show;
  ProductListSort sortBy;
  bool sortDesc;
}

class ProductListFilterDialog extends StatefulWidget {
  const ProductListFilterDialog({
    super.key,
    required this.filter,
  });

  final ProductListFilter filter;

  static Future<ProductListFilter?> of(
    BuildContext context,
    ProductListFilter filter,
  ) {
    return showDialog<ProductListFilter>(
      context: context,
      builder: (_) => ProductListFilterDialog(
        filter: filter,
      ),
    );
  }

  @override
  State<ProductListFilterDialog> createState() =>
      _ProductListFilterDialogState();
}

class _ProductListFilterDialogState extends State<ProductListFilterDialog> {
  late ProductListFilter filter;

  @override
  void initState() {
    filter = widget.filter;
    super.initState();
  }

  void _updateFilterShow(ProductListShow? value) {
    filter.show = value ?? ProductListShow.all;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding:
          const EdgeInsets.only(left: 16, top: 16, bottom: 0, right: 0),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Filtrar produtos'),
          IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.close),
          )
        ],
      ),
      contentPadding: EdgeInsets.zero,
      content: SizedBox(
        height: 300,
        width: double.maxFinite,
        child: ListView(
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 24, top: 8),
              child: Text('Mostrar:'),
            ),
            RadioListTile<ProductListShow>(
              visualDensity: VisualDensity.compact,
              value: ProductListShow.all,
              groupValue: filter.show,
              onChanged: _updateFilterShow,
              title: const Text('Todos'),
            ),
            RadioListTile<ProductListShow>(
              visualDensity: VisualDensity.compact,
              value: ProductListShow.onlyStockControlled,
              groupValue: filter.show,
              onChanged: _updateFilterShow,
              title: const Text('Com controle de estoque'),
            ),
            RadioListTile<ProductListShow>(
              visualDensity: VisualDensity.compact,
              value: ProductListShow.notStockControlled,
              groupValue: filter.show,
              onChanged: _updateFilterShow,
              title: const Text('Sem controle de estoque'),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DropdownMenu(
                    width: 180,
                    initialSelection: filter.sortBy,
                    label: const Text('Ordenar por'),
                    dropdownMenuEntries: const [
                      DropdownMenuEntry(
                        value: ProductListSort.description,
                        label: 'Descrição',
                      ),
                      DropdownMenuEntry(
                        value: ProductListSort.price,
                        label: 'Preço',
                      ),
                      DropdownMenuEntry(
                        value: ProductListSort.stock,
                        label: 'Estoque',
                      ),
                      DropdownMenuEntry(
                        value: ProductListSort.createdAt,
                        label: 'Data de criação',
                      ),
                    ],
                    onSelected: (value) {
                      setState(
                        () => filter.sortBy =
                            value ?? ProductListSort.description,
                      );
                    },
                  ),
                  TextButton.icon(
                    label: const Text('Direção'),
                    onPressed: () =>
                        setState(() => filter.sortDesc = !filter.sortDesc),
                    icon: Icon(
                      filter.sortDesc
                          ? Icons.arrow_upward
                          : Icons.arrow_downward,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        TextButton(
          onPressed: () => context.pop(ProductListFilter()),
          child: const Text('Limpar filtros'),
        ),
        TextButton(
          onPressed: () => context.pop(filter),
          child: const Text('Aplicar'),
        )
      ],
    );
  }
}
