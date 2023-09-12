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
  });

  final String? uuid;
  final String description;
  final double price;
  final List<ProductCategory>? categories;
  final bool active;

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
    );
  }
}
