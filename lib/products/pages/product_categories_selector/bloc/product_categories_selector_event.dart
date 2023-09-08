part of 'product_categories_selector_bloc.dart';

sealed class ProductCategoriesSelectorEvent extends Equatable {
  const ProductCategoriesSelectorEvent();
}

final class ProductCategoriesSelectorStarted
    extends ProductCategoriesSelectorEvent {
  const ProductCategoriesSelectorStarted({
    required this.companyUuid,
    required this.initialSelectedCategories,
  });

  final String companyUuid;
  final List<ProductCategory> initialSelectedCategories;

  @override
  List<Object> get props => [];
}

final class ProductCategoriesSelectorSelected
    extends ProductCategoriesSelectorEvent {
  const ProductCategoriesSelectorSelected({
    required this.selectedCategory,
  });

  final ProductCategory selectedCategory;

  @override
  List<Object> get props => [selectedCategory];
}

final class ProductCategoriesSelectorSubmitted
    extends ProductCategoriesSelectorEvent {
  @override
  List<Object> get props => [];
}
