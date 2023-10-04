part of 'product_form_bloc.dart';

sealed class ProductFormState extends Equatable {
  const ProductFormState();
}

final class ProductFormEditing extends ProductFormState {
  const ProductFormEditing({
    this.uuid,
    this.description = '',
    this.price = 0,
    this.categories = const [],
    this.currentStock = 0,
    this.descriptionError,
    this.hasStockControl = false,
    this.createdAt,
  });

  final String? uuid;
  final String description;
  final double price;
  final List<ProductCategory> categories;
  final int currentStock;
  final String? descriptionError;
  final bool hasStockControl;
  final DateTime? createdAt;

  @override
  List<Object?> get props => [
        uuid,
        description,
        price,
        categories,
        currentStock,
        descriptionError,
      ];

  ProductFormEditing copyWith({
    String? uuid,
    String? description,
    double? price,
    List<ProductCategory>? categories,
    int? currentStock,
    String? descriptionError,
    bool? hasStockControl,
  }) {
    return ProductFormEditing(
      uuid: uuid ?? this.uuid,
      description: description ?? this.description,
      price: price ?? this.price,
      categories: categories ?? this.categories,
      descriptionError: descriptionError ?? this.descriptionError,
      currentStock: currentStock ?? this.currentStock,
      hasStockControl: hasStockControl ?? this.hasStockControl,
    );
  }
}

final class ProductFormLoading extends ProductFormState {
  const ProductFormLoading();
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
