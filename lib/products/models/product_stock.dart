import 'package:equatable/equatable.dart';

class ProductStock extends Equatable {
  final String? uuid;
  final int quantity;
  final DateTime createdAt;
  final String? observation;

  const ProductStock({
    this.uuid,
    required this.quantity,
    required this.createdAt,
    this.observation,
  });

  @override
  List<Object?> get props => [uuid, quantity, createdAt, observation];
}
