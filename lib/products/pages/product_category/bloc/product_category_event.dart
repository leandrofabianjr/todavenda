part of 'product_category_bloc.dart';

sealed class ProductCategoryEvent extends Equatable {
  const ProductCategoryEvent();
}

class ProductCategoryStarted extends ProductCategoryEvent {
  const ProductCategoryStarted();

  @override
  List<Object> get props => [];
}
