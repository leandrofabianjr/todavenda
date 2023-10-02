import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:todavenda/products/models/product_category.dart';

import '../../../services/product_categories_repository.dart';

part 'product_category_list_event.dart';
part 'product_category_list_state.dart';

class ProductCategoryListBloc
    extends Bloc<ProductCategoryListEvent, ProductCategoryListState> {
  ProductCategoryListBloc(this.productCategoryRepository)
      : super(ProductCategoryListLoading()) {
    on<ProductCategoryListStarted>(_onStarted);
  }

  final ProductCategoriesRepository productCategoryRepository;

  Future<void> _onStarted(
    ProductCategoryListStarted event,
    Emitter<ProductCategoryListState> emit,
  ) async {
    emit(ProductCategoryListLoading());
    try {
      final productCategoryList = await productCategoryRepository.load();
      emit(ProductCategoryListLoaded(productCategoryList));
    } catch (ex) {
      emit(ProductCategoryListException(ex));
    }
  }
}
