import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:todavenda/products/models/product.dart';
import 'package:todavenda/products/services/product_repository.dart';

part 'product_list_event.dart';
part 'product_list_state.dart';

class ProductListBloc extends Bloc<ProductListEvent, ProductListState> {
  ProductListBloc({
    required this.productRepository,
  }) : super(ProductListLoading()) {
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
    } catch (_) {
      emit(ProductListException());
    }
  }
}
