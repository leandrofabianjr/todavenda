part of 'product_form_bloc.dart';

sealed class ProductFormEvent extends Equatable {
  const ProductFormEvent();
}

final class ProductFormSubmitted extends ProductFormEvent {
  const ProductFormSubmitted({
    required this.companyUuid,
    required this.description,
    required this.price,
    required this.categories,
  });

  final String companyUuid;
  final String description;
  final double price;
  final List<ProductCategory> categories;

  @override
  List<Object?> get props => [description, price, categories];
}
