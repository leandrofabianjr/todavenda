import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todavenda/clients/clients.dart';
import 'package:todavenda/clients/widgets/client_selector.dart';
import 'package:todavenda/commons/commons.dart';
import 'package:todavenda/products/products.dart';

import '../../cart.dart';
import '../../widgets/cart_list_tile.dart';

class SellPage extends StatelessWidget {
  const SellPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<CartBloc>(context),
      child: BlocConsumer<CartBloc, CartState>(
        listener: (context, state) {
          switch (state.status) {
            case CartStatus.checkout:
              return context.go('/vender/confirmacao');
            case CartStatus.payment:
              return context.go('/vender/pagamento');
            case CartStatus.finalizing:
              return context.go('/vender/finalizado');
            case CartStatus.closedSession:
              return context.go('/caixa/abrir');
            default:
              null;
          }
        },
        builder: (context, state) {
          return const SellView();
        },
      ),
    );
  }
}

class SellView extends StatefulWidget {
  const SellView({super.key});

  @override
  State<SellView> createState() => _SellViewState();
}

class _SellViewState extends State<SellView> {
  int totalQuantity = 0;
  String formattedTotalPrice = '';
  Client? selectedClient;

  @override
  void initState() {
    context.read<CartBloc>().add(const CartStarted());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SellPageAppBar(),
      floatingActionButton: totalQuantity > 0
          ? Badge(
              label: Text(totalQuantity.toString()),
              child: FloatingActionButton(
                onPressed: () =>
                    context.read<CartBloc>().add(const CartCheckouted()),
                child: const Icon(Icons.shopping_cart),
              ),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: BottomAppBar(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 160,
              child: ClientSelector(
                clientsRepository: context.read<ClientsRepository>(),
                initial: selectedClient,
                onChanged: (client) => context
                    .read<CartBloc>()
                    .add(CartClientChanged(client: client)),
              ),
            ),
            if (totalQuantity > 0)
              Padding(
                padding: const EdgeInsets.only(right: 64),
                child: Text(
                  formattedTotalPrice,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
          ],
        ),
      ),
      body: BlocConsumer<CartBloc, CartState>(
        listener: (context, state) {
          setState(() {
            totalQuantity = state.totalQuantity;
            formattedTotalPrice = state.formattedTotalPrice;
            selectedClient = state.client;
          });
        },
        builder: (context, state) {
          switch (state.status) {
            case CartStatus.failure:
              return ExceptionWidget(exception: state.exception);
            case CartStatus.initial:
              return SellSelectorView(
                items: state.items,
                onAdded: (product) => context
                    .read<CartBloc>()
                    .add(CartItemAdded(product: product)),
                onRemoved: (product) => context
                    .read<CartBloc>()
                    .add(CartItemRemoved(product: product)),
                onSearchChanged: (term) =>
                    context.read<CartBloc>().add(CartStarted(filterterm: term)),
                initialSearchTerm: state.filterTerm,
              );
            default:
              return const LoadingWidget();
          }
        },
      ),
    );
  }
}

class SellSelectorView extends StatelessWidget {
  const SellSelectorView({
    super.key,
    required this.items,
    required this.onAdded,
    required this.onRemoved,
    required this.onSearchChanged,
    this.initialSearchTerm,
  });

  final Map<Product, int> items;
  final void Function(Product product) onAdded;
  final void Function(Product product) onRemoved;
  final void Function(String? term) onSearchChanged;
  final String? initialSearchTerm;

  Map<ProductCategory?, Map<Product, int>> get itemsByCategory {
    Map<ProductCategory?, Map<Product, int>> itemsByCategory = {};

    for (final item in items.entries) {
      final categories =
          item.key.categories != null && item.key.categories!.isNotEmpty
              ? item.key.categories!
              : [null];
      for (final category in categories) {
        if (!itemsByCategory.containsKey(category)) {
          itemsByCategory[category] = {};
        }
        itemsByCategory[category]!.addEntries([item]);
      }
    }

    final sortedEntries =
        itemsByCategory.entries.sortedBy((element) => element.key?.name ?? '');

    return Map.fromEntries(sortedEntries);
  }

  bool get isSearching {
    return initialSearchTerm != null && initialSearchTerm!.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => context.read<CartBloc>().add(const CartStarted()),
      child: CustomScrollView(
        slivers: [
          if (items.isEmpty)
            const SliverFillRemaining(
              child: Center(child: Text('Nenhum produto encontrado')),
            ),
          if (items.isNotEmpty)
            SliverList(
              delegate: SliverChildListDelegate([
                ...itemsByCategory.entries
                    .toList()
                    .map(
                      (itemByCategory) => ExpansionTile(
                        initiallyExpanded: isSearching,
                        title: Text(
                          itemByCategory.key == null
                              ? 'Não categorizado'
                              : itemByCategory.key!.name,
                        ),
                        children: itemByCategory.value.entries
                            .map((item) => SellListTile(
                                  product: item.key,
                                  quantity: item.value,
                                  onAdded: () => onAdded(item.key),
                                  onRemoved: () => onRemoved(item.key),
                                ))
                            .toList(),
                      ),
                    )
                    .toList(),
              ]),
            ),
          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
    );
  }
}

class SellPageAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SellPageAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(110.0);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        return SellPageAppBarView(
          onSearchChanged: (term) =>
              context.read<CartBloc>().add(CartStarted(filterterm: term)),
          initialSearchTerm: state.filterTerm,
        );
      },
    );
  }
}

class SellPageAppBarView extends StatefulWidget {
  const SellPageAppBarView({
    super.key,
    required this.onSearchChanged,
    this.initialSearchTerm,
  });

  final void Function(String? term) onSearchChanged;
  final String? initialSearchTerm;

  @override
  State<SellPageAppBarView> createState() => _SellPageAppBarViewState();
}

class _SellPageAppBarViewState extends State<SellPageAppBarView> {
  late TextEditingController searchTextController;
  Timer? _debounce;

  @override
  void initState() {
    searchTextController =
        TextEditingController(text: widget.initialSearchTerm);
    super.initState();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  _onSearchChanged(String term) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(
      const Duration(milliseconds: 500),
      () => widget.onSearchChanged(term),
    );
  }

  _clearSearch() {
    searchTextController.clear();
    widget.onSearchChanged(null);
  }

  bool get searchIsEmpty => searchTextController.text.isEmpty;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Nova venda'),
      actions: [
        IconButton(
          icon: const Icon(Icons.point_of_sale),
          color: Theme.of(context).colorScheme.primary,
          onPressed: () => context.go('/caixa'),
        ),
      ],
      bottom: AppBar(
        title: TextField(
          controller: searchTextController,
          decoration: InputDecoration(
            label: const Text('Pesquisar'),
            prefixIcon: const Icon(Icons.search),
            suffixIcon: searchIsEmpty
                ? null
                : IconButton(
                    onPressed: _clearSearch,
                    icon: const Icon(Icons.backspace),
                  ),
          ),
          keyboardType: TextInputType.name,
          onChanged: _onSearchChanged,
        ),
      ),
    );
  }
}
