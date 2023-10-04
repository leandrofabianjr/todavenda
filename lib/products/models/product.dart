import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:todavenda/commons/commons.dart';

import 'product_category.dart';

class Product extends Equatable {
  const Product({
    this.uuid,
    required this.description,
    required this.price,
    this.categories,
    this.active = true,
    required this.currentStock,
    required this.hasStockControl,
    required this.createdAt,
  });

  final String? uuid;
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

  Map<String, dynamic> toJson() {
    return {
      if (uuid != null) 'uuid': uuid,
      'description': description,
      'price': price,
      if (categories != null && categories!.isNotEmpty)
        'categoriesUuids': (categories ?? []).map((e) => e.uuid).toList(),
      'active': active,
      'currentStock': currentStock,
      'hasStockControl': hasStockControl,
      'createdAt': createdAt,
    };
  }

  static Product fromJson(
      Map<String, dynamic> json, List<ProductCategory> categories) {
    return Product(
      uuid: json['uuid'],
      description: json['description'],
      price: json['price'],
      categories: json['categoriesUuids'] == null
          ? null
          : (json['categoriesUuids'] as List)
              .map((e) => categories.firstWhere((c) => c.uuid == e))
              .toList(),
      active: json['active'],
      currentStock: json['currentStock'] ?? 0,
      hasStockControl: json['hasStockControl'] ?? false,
      createdAt: (json['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
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
