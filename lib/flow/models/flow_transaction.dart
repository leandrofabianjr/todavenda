import 'package:equatable/equatable.dart';

class FlowTransaction extends Equatable {
  final String? uuid;
  final String description;
  final String? observation;
  final double amount;
  final DateTime createdAt;

  const FlowTransaction(
      {this.uuid,
      required this.description,
      this.observation,
      required this.amount,
      required this.createdAt});

  @override
  List<Object?> get props => [uuid];
}
