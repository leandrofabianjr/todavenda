part of 'product_category_list_bloc.dart';

sealed class ProductCategoryListState extends Equatable {
  const ProductCategoryListState();
}

final class ProductCategoryListLoading extends ProductCategoryListState {
  @override
  List<Object?> get props => [];
}

final class ProductCategoryListLoaded extends ProductCategoryListState {
  const ProductCategoryListLoaded(this.productCategories);

  final List<ProductCategory> productCategories;

  @override
  List<Object> get props => [productCategories];
}

final class ProductCategoryListException extends ProductCategoryListState {
  const ProductCategoryListException(this.ex);

  final Object? ex;

  @override
  List<Object?> get props => [ex];
}
