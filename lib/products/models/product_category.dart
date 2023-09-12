import 'package:equatable/equatable.dart';

class ProductCategory extends Equatable {
  final String? uuid;
  final String name;
  final String? description;

  const ProductCategory({
    this.uuid,
    required this.name,
    this.description,
  });

  @override
  List<Object?> get props => [uuid];

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'name': name,
      'description': description,
    };
  }

  static ProductCategory fromJson(Map<String, dynamic> json) {
    return ProductCategory(
      uuid: json['uuid'],
      name: json['name'],
      description: json['description'],
    );
  }
}
