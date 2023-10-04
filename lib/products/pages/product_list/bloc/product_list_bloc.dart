import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../models/product.dart';
import '../../../services/products_repository.dart';
import '../product_list_filter.dart';

part 'product_list_event.dart';
part 'product_list_state.dart';

class ProductListBloc extends Bloc<ProductListEvent, ProductListState> {
  ProductListBloc(this.productRepository) : super(ProductListLoading()) {
    on<ProductListStarted>(_onStarted);
  }

  final ProductsRepository productRepository;

  Future<void> _onStarted(
    ProductListStarted event,
    Emitter<ProductListState> emit,
  ) async {
    emit(ProductListLoading());
    try {
      final filter = event.filter ?? ProductListFilter();
      var products =
          await productRepository.loadProducts(term: filter.searchTerm);

      switch (filter.show) {
        case ProductListShow.all:
          break;
        case ProductListShow.onlyStockControlled:
          products = products.where((p) => p.hasStockControl).toList();
        case ProductListShow.notStockControlled:
          products = products.where((p) => !p.hasStockControl).toList();
      }

      final direction = filter.sortDesc ? -1 : 1;

      products.sort(
        (p1, p2) => switch (filter.sortBy) {
          ProductListSort.description =>
            p1.description.compareTo(p2.description) * direction,
          ProductListSort.price => p1.price.compareTo(p2.price) * direction,
          ProductListSort.stock =>
            p1.currentStock.compareTo(p2.currentStock) * direction,
          ProductListSort.createdAt =>
            p1.createdAt.compareTo(p2.createdAt) * direction,
        },
      );

      emit(ProductListLoaded(products: products, filter: filter));
    } catch (ex) {
      emit(ProductListException(ex));
    }
  }
}
