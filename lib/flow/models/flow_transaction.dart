import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:todavenda/flow/models/flow_account.dart';

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
  final FlowAccount account;

  const FlowTransaction({
    this.uuid,
    required this.type,
    required this.description,
    this.observation,
    required this.amount,
    required this.createdAt,
    required this.account,
  });

  @override
  List<Object?> get props => [uuid];

  FlowTransaction copyWith({
    String? uuid,
    FlowTransactionType? type,
    String? description,
    String? observation,
    double? amount,
    DateTime? createdAt,
    FlowAccount? account,
  }) {
    return FlowTransaction(
      uuid: uuid ?? this.uuid,
      type: type ?? this.type,
      description: description ?? this.description,
      observation: observation ?? this.observation,
      amount: amount ?? this.amount,
      createdAt: createdAt ?? this.createdAt,
      account: account ?? this.account,
    );
  }
}
