import 'package:equatable/equatable.dart';

class ProductCategory extends Equatable {
  final String companyUuid;
  final String? uuid;
  final String name;
  final String? description;

  const ProductCategory({
    required this.companyUuid,
    this.uuid,
    required this.name,
    this.description,
  });

  @override
  List<Object?> get props => [uuid];

  Map<String, dynamic> toJson() {
    return {
      'companyUuid': companyUuid,
      'uuid': uuid,
      'name': name,
      'description': description,
    };
  }

  static ProductCategory? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;

    return ProductCategory(
      companyUuid: json['companyUuid'],
      uuid: json['uuid'],
      name: json['name'],
      description: json['description'],
    );
  }
}
