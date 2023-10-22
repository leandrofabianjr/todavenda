import 'package:equatable/equatable.dart';
import 'package:todavenda/commons/commons.dart';

import 'product_category.dart';

class Product extends Equatable {
  const Product({
    required this.uuid,
    required this.description,
    required this.price,
    this.categories,
    this.active = true,
    required this.currentStock,
    required this.hasStockControl,
    required this.createdAt,
  });

  final String uuid;
  final String description;
  final double price;
  final List<ProductCategory>? categories;
  final bool active;
  final int currentStock;
  final bool hasStockControl;
  final DateTime createdAt;

  get formattedPrice => CurrencyFormatter().formatPtBr(price);

  @override
  List<Object?> get props => [uuid];

  Map<String, dynamic> toJson(DateTimeConverterType dateTimeType) {
    return {
      'uuid': uuid,
      'description': description,
      'price': price,
      'categoriesUuids': (categories ?? []).map((e) => e.uuid).toList(),
      'categories': (categories ?? []).map((e) => e.toJson()).toList(),
      'active': active,
      'currentStock': currentStock,
      'hasStockControl': hasStockControl,
      'createdAt': DateTimeConverter.to(dateTimeType, createdAt),
    };
  }

  static Product fromJson(
    Map<String, dynamic> json,
    DateTimeConverterType dateTimeType,
  ) {
    return Product(
      uuid: json['uuid'],
      description: json['description'],
      price: json['price'],
      categories: (json['categories'] as List)
          .map((e) => ProductCategory.fromJson(e))
          .toList(),
      active: json['active'],
      currentStock: json['currentStock'] ?? 0,
      hasStockControl: json['hasStockControl'] ?? false,
      createdAt: DateTimeConverter.tryParse(dateTimeType, json['createdAt']) ??
          DateTime.now(),
    );
  }

  Product copyWith({
    String? uuid,
    String? description,
    double? price,
    List<ProductCategory>? categories,
    bool? active,
    int? currentStock,
    bool? hasStockControl,
    DateTime? createdAt,
  }) {
    return Product(
      uuid: uuid ?? this.uuid,
      description: description ?? this.description,
      price: price ?? this.price,
      currentStock: currentStock ?? this.currentStock,
      active: active ?? this.active,
      categories: categories ?? this.categories,
      hasStockControl: hasStockControl ?? this.hasStockControl,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
