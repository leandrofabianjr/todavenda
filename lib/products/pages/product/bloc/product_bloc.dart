import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../products.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc(this.productRepository, {required this.uuid})
      : super(ProductLoading()) {
    on<ProductStarted>(_onProductStarted);
  }

  final ProductsRepository productRepository;
  final String uuid;

  Future<void> _onProductStarted(
    ProductStarted event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    try {
      final product = await productRepository.loadProductByUuid(uuid);
      emit(ProductLoaded(product: product));
    } catch (ex) {
      emit(ProductException(ex));
    }
  }
}
