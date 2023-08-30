import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../models/product.dart';
import '../../../services/product_repository.dart';

part 'product_list_event.dart';
part 'product_list_state.dart';

class ProductListBloc extends Bloc<ProductListEvent, ProductListState> {
  ProductListBloc(this.productRepository) : super(ProductListLoading()) {
    on<ProductListStarted>(_onStarted);
  }

  final ProductRepository productRepository;

  Future<void> _onStarted(
    ProductListStarted event,
    Emitter<ProductListState> emit,
  ) async {
    emit(ProductListLoading());
    try {
      final productList = await productRepository.loadProducts();
      emit(ProductListLoaded(productList));
    } catch (ex) {
      emit(ProductListException(ex));
    }
  }
}
