import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todavenda/clients/clients.dart';
import 'package:todavenda/commons/commons.dart';
import 'package:todavenda/products/products.dart';
import 'package:upgrader/upgrader.dart';

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
    final cubit = context.read<CartBloc>();
    final filterTerm = cubit.state.filterTerm;
    cubit.add(CartRefreshed(filterterm: filterTerm ?? ''));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return UpgradeAlert(
      upgrader: Upgrader(languageCode: 'pt'),
      child: Scaffold(
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
                child: BlocBuilder<CartBloc, CartState>(
                  builder: (context, state) {
                    if (state.status == CartStatus.initial) {
                      selectedClient = state.client;
                      return ClientSelector(
                        clientsRepository: context.read<ClientsRepository>(),
                        initial: selectedClient,
                        onChanged: (client) => context
                            .read<CartBloc>()
                            .add(CartClientChanged(client: client)),
                      );
                    }
                    return const SizedBox();
                  },
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
            if (state.status == CartStatus.initial) {
              setState(() {
                totalQuantity = state.totalQuantity;
                formattedTotalPrice = state.formattedTotalPrice;
              });
            }
          },
          builder: (context, state) {
            switch (state.status) {
              case CartStatus.failure:
                return ExceptionWidget(exception: state.exception);
              case CartStatus.initial:
                return SellSelectorView(
                  items: state.items,
                  products: state.products,
                  onAdded: (product) => context
                      .read<CartBloc>()
                      .add(CartItemAdded(product: product)),
                  onRemoved: (product) => context
                      .read<CartBloc>()
                      .add(CartItemRemoved(product: product)),
                  onSearchChanged: (term) => context
                      .read<CartBloc>()
                      .add(CartRefreshed(filterterm: term)),
                  initialSearchTerm: state.filterTerm,
                );
              default:
                return const LoadingWidget();
            }
          },
        ),
      ),
    );
  }
}

class SellSelectorView extends StatelessWidget {
  const SellSelectorView({
    super.key,
    required this.products,
    required this.items,
    required this.onAdded,
    required this.onRemoved,
    required this.onSearchChanged,
    this.initialSearchTerm,
  });

  final List<Product> products;
  final Map<Product, int> items;
  final void Function(Product product) onAdded;
  final void Function(Product product) onRemoved;
  final void Function(String? term) onSearchChanged;
  final String? initialSearchTerm;

  Map<ProductCategory?, List<Product>> get productsByCategory {
    Map<ProductCategory?, List<Product>> productsByCategory = {};

    for (final p in products) {
      final categories = p.categories != null && p.categories!.isNotEmpty
          ? p.categories!
          : [null];
      for (final category in categories) {
        if (!productsByCategory.containsKey(category)) {
          productsByCategory[category] = [];
        }
        productsByCategory[category]!.add(p);
      }
    }

    final sortedEntries = productsByCategory.entries
        .sortedBy((element) => element.key?.name ?? '');

    return Map.fromEntries(sortedEntries);
  }

  bool get isSearching {
    return initialSearchTerm != null && initialSearchTerm!.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async =>
          context.read<CartBloc>().add(const CartRefreshed()),
      child: CustomScrollView(
        slivers: [
          if (products.isEmpty)
            const SliverFillRemaining(
              child: Center(child: Text('Nenhum produto encontrado')),
            ),
          if (products.isNotEmpty)
            SliverList(
              delegate: SliverChildListDelegate([
                ...productsByCategory.entries
                    .toList()
                    .map(
                      (productByCategory) => ExpansionTile(
                        initiallyExpanded: isSearching,
                        title: Text(
                          productByCategory.key == null
                              ? 'Não categorizado'
                              : productByCategory.key!.name,
                        ),
                        children: productByCategory.value
                            .map(
                              (p) => SellListTile(
                                product: p,
                                quantity: items[p] ?? 0,
                                onAdded: () => onAdded(p),
                                onRemoved: () => onRemoved(p),
                              ),
                            )
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
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        return AppBarWithSearchView(
          onSearchChanged: (term) =>
              context.read<CartBloc>().add(CartRefreshed(filterterm: term)),
          initialSearchTerm: state.filterTerm,
          title: const Text('Nova venda'),
          actions: [
            IconButton(
              icon: const Icon(Icons.point_of_sale),
              color: Theme.of(context).colorScheme.primary,
              onPressed: () => context.go('/caixa'),
            ),
          ],
        );
      },
    );
  }
}
