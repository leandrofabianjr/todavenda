part of 'product_form_bloc.dart';

sealed class ProductFormState extends Equatable {
  const ProductFormState();
}

final class ProductFormEditing extends ProductFormState {
  const ProductFormEditing({
    this.description = '',
    this.price = 0,
    this.categories = const [],
    this.descriptionError,
  });

  final String description;
  final double price;
  final List<ProductCategory> categories;
  final String? descriptionError;

  @override
  List<Object?> get props => [description, price, categories, descriptionError];

  ProductFormEditing copyWith({
    String? description,
    double? price,
    List<ProductCategory>? categories,
    String? descriptionError,
  }) {
    return ProductFormEditing(
      description: description ?? this.description,
      price: price ?? this.price,
      categories: categories ?? this.categories,
      descriptionError: descriptionError ?? this.descriptionError,
    );
  }
}

final class ProductFormSubmitting extends ProductFormState {
  @override
  List<Object> get props => [];
}

final class ProductFormSuccessfullySubmitted extends ProductFormState {
  @override
  List<Object> get props => [];
}

final class ProductFormException extends ProductFormState {
  const ProductFormException(this.ex);

  final Object ex;

  @override
  List<Object> get props => [ex];
}
