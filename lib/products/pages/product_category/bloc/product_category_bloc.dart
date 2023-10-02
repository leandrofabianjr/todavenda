import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../models/product_category.dart';
import '../../../services/product_categories_repository.dart';

part 'product_category_event.dart';
part 'product_category_state.dart';

class ProductCategoryBloc
    extends Bloc<ProductCategoryEvent, ProductCategoryState> {
  ProductCategoryBloc(this.productCategoryRepository, {required this.uuid})
      : super(ProductCategoryLoading()) {
    on<ProductCategoryStarted>(_onProductCategoryStarted);
  }

  final ProductCategoriesRepository productCategoryRepository;
  final String uuid;

  Future<void> _onProductCategoryStarted(
    ProductCategoryStarted event,
    Emitter<ProductCategoryState> emit,
  ) async {
    emit(ProductCategoryLoading());
    try {
      final productCategory = await productCategoryRepository.loadByUuid(uuid);
      emit(ProductCategoryReady(productCategory: productCategory));
    } catch (ex) {
      emit(ProductCategoryException(ex));
    }
  }
}
