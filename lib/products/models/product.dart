import 'package:equatable/equatable.dart';
import 'package:todavenda/commons/commons.dart';

import 'product_category.dart';

class Product extends Equatable {
  const Product({
    required this.companyUuid,
    this.uuid,
    required this.description,
    required this.price,
    this.categories,
    this.active = true,
  });

  final String companyUuid;
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
      'companyUuid': companyUuid,
      if (uuid != null) 'uuid': uuid,
      'description': description,
      'price': price,
      if (categories != null && categories!.isNotEmpty)
        'categories': (categories ?? []).map((e) => e.uuid).toList(),
      'active': active,
    };
  }

  static Product? fromJson(
      Map<String, dynamic>? json, List<ProductCategory> categories) {
    if (json == null) return null;
    return Product(
      companyUuid: json['companyUuid'],
      uuid: json['uuid'],
      description: json['description'],
      price: json['price'],
      categories: json['categories'] == null
          ? null
          : (json['categories'] as List)
              .map((e) => categories.firstWhere((c) => c.uuid == e))
              .toList(),
      active: json['active'],
    );
  }
}
