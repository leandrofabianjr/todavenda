part of 'product_category_bloc.dart';

sealed class ProductCategoryState extends Equatable {
  const ProductCategoryState();
}

final class ProductCategoryLoading extends ProductCategoryState {
  @override
  List<Object> get props => [];
}

final class ProductCategoryReady extends ProductCategoryState {
  const ProductCategoryReady({required this.productCategory});

  final ProductCategory productCategory;

  @override
  List<Object> get props => [productCategory];
}

final class ProductCategoryException extends ProductCategoryState {
  const ProductCategoryException(this.ex);

  final Object? ex;
  @override
  List<Object?> get props => [ex];
}
