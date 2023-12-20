part of 'flow_transaction_form_bloc.dart';

sealed class FlowTransactionFormEvent extends Equatable {
  const FlowTransactionFormEvent();
}

class FlowTransactionFormStarted extends FlowTransactionFormEvent {
  const FlowTransactionFormStarted({this.uuid});

  final String? uuid;

  @override
  List<Object?> get props => [uuid];
}

final class FlowTransactionFormSubmitted extends FlowTransactionFormEvent {
  const FlowTransactionFormSubmitted({
    this.uuid,
    required this.type,
    required this.description,
    this.observation,
    required this.amount,
    required this.createdAt,
  });

  final String? uuid;
  final FlowTransactionType type;
  final String description;
  final String? observation;
  final double amount;
  final DateTime? createdAt;

  @override
  List<Object?> get props => [
        uuid,
        type,
        description,
        observation,
        amount,
        createdAt,
      ];
}
