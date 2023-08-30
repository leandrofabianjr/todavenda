part of 'product_category_form_bloc.dart';

sealed class ProductCategoryFormState extends Equatable {
  const ProductCategoryFormState();
}

final class ProductCategoryFormEditing extends ProductCategoryFormState {
  const ProductCategoryFormEditing({
    this.name = '',
    this.description = '',
    this.nameError,
  });

  final String name;
  final String? description;
  final String? nameError;

  @override
  List<Object?> get props => [name, description, nameError];

  ProductCategoryFormEditing copyWith({
    String? name,
    String? description,
    String? nameError,
  }) {
    return ProductCategoryFormEditing(
      name: name ?? this.name,
      description: description ?? this.description,
      nameError: nameError ?? this.nameError,
    );
  }
}

final class ProductCategoryFormSubmitting extends ProductCategoryFormState {
  @override
  List<Object> get props => [];
}

final class ProductCategoryFormSuccessfullySubmitted
    extends ProductCategoryFormState {
  @override
  List<Object> get props => [];
}

final class ProductCategoryFormException extends ProductCategoryFormState {
  const ProductCategoryFormException(this.ex);

  final Object ex;

  @override
  List<Object> get props => [ex];
}
