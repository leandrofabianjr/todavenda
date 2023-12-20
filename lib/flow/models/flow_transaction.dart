import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum FlowTransactionType {
  incoming,
  outgoing,
}

extension FlowTransactionTypeX on FlowTransactionType {
  String get label => switch (this) {
        FlowTransactionType.incoming => 'Entrada',
        FlowTransactionType.outgoing => 'Despesa',
      };

  Color get color => switch (this) {
        FlowTransactionType.incoming => Colors.green,
        FlowTransactionType.outgoing => Colors.red,
      };

  IconData get icon => switch (this) {
        FlowTransactionType.incoming => Icons.input,
        FlowTransactionType.outgoing => Icons.output,
      };

  String get value => name.toString();

  static FlowTransactionType parse(String value) =>
      FlowTransactionType.values.firstWhere(
        (e) => e.name == value,
      );
}

class FlowTransaction extends Equatable {
  final String? uuid;
  final FlowTransactionType type;
  final String description;
  final String? observation;
  final double amount;
  final DateTime createdAt;

  const FlowTransaction({
    this.uuid,
    required this.type,
    required this.description,
    this.observation,
    required this.amount,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [uuid];
}
