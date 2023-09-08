part of 'product_category_form_bloc.dart';

sealed class ProductCategoryFormEvent extends Equatable {
  const ProductCategoryFormEvent();
}

final class ProductCategoryFormSubmitted extends ProductCategoryFormEvent {
  const ProductCategoryFormSubmitted({
    required this.companyUuid,
    required this.name,
    required this.description,
  });

  final String companyUuid;
  final String name;
  final String? description;

  @override
  List<Object?> get props => [companyUuid, name, description];
}
