part of 'product_categories_selector_bloc.dart';

sealed class ProductCategoriesSelectorState extends Equatable {
  const ProductCategoriesSelectorState();
  @override
  List<Object?> get props => [];
}

final class ProductCategoriesSelectorLoading
    extends ProductCategoriesSelectorState {}

final class ProductCategoriesSelectorLoaded
    extends ProductCategoriesSelectorState {
  const ProductCategoriesSelectorLoaded(this.categories);

  final Map<ProductCategory, bool> categories;

  @override
  List<Object> get props => [categories.hashCode];
}

final class ProductCategoriesSelectorSubmitting
    extends ProductCategoriesSelectorState {
  const ProductCategoriesSelectorSubmitting(this.selectedCategories);

  final List<ProductCategory> selectedCategories;

  @override
  List<Object> get props => [selectedCategories];
}

final class ProductCategoriesSelectorException
    extends ProductCategoriesSelectorState {
  const ProductCategoriesSelectorException(this.ex);

  final Object ex;

  @override
  List<Object> get props => [ex];
}
