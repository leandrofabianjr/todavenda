part of 'product_category_list_bloc.dart';

sealed class ProductCategoryListEvent extends Equatable {
  const ProductCategoryListEvent();
}

class ProductCategoryListStarted extends ProductCategoryListEvent {
  const ProductCategoryListStarted();

  @override
  List<Object> get props => [];
}
