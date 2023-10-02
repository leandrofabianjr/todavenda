part of 'product_category_form_bloc.dart';

sealed class ProductCategoryFormEvent extends Equatable {
  const ProductCategoryFormEvent();
}

class ProductCategoryFormStarted extends ProductCategoryFormEvent {
  const ProductCategoryFormStarted({this.uuid});

  final String? uuid;

  @override
  List<Object?> get props => [uuid];
}

final class ProductCategoryFormSubmitted extends ProductCategoryFormEvent {
  const ProductCategoryFormSubmitted({
    this.uuid,
    required this.name,
    required this.description,
  });

  final String? uuid;
  final String name;
  final String? description;

  @override
  List<Object?> get props => [name, description];
}
