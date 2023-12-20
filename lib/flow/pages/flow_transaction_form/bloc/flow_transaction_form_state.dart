part of 'flow_transaction_form_bloc.dart';

sealed class FlowTransactionFormState extends Equatable {
  const FlowTransactionFormState();
}

final class FlowTransactionFormEditing extends FlowTransactionFormState {
  const FlowTransactionFormEditing({
    this.uuid,
    this.type = FlowTransactionType.outgoing,
    this.description = '',
    this.observation,
    this.amount = 0,
    this.createdAt,
    this.descriptionError,
    this.amountError,
  });

  final String? uuid;
  final FlowTransactionType type;
  final String description;
  final String? observation;
  final double amount;
  final DateTime? createdAt;
  final String? descriptionError;
  final String? amountError;

  @override
  List<Object?> get props => [
        uuid,
        type,
        description,
        observation,
        amount,
        createdAt,
        descriptionError,
        amountError,
      ];

  FlowTransactionFormEditing copyWith({
    String? uuid,
    FlowTransactionType? type,
    String? name,
    String? description,
    String? observation,
    double? amount,
    DateTime? createdAt,
    String? descriptionError,
    String? amountError,
  }) {
    return FlowTransactionFormEditing(
      uuid: uuid ?? this.uuid,
      type: type ?? this.type,
      description: description ?? this.description,
      observation: observation ?? this.observation,
      amount: amount ?? this.amount,
      createdAt: createdAt ?? this.createdAt,
      descriptionError: descriptionError ?? this.descriptionError,
      amountError: amountError ?? this.amountError,
    );
  }
}

final class FlowTransactionFormSubmitting extends FlowTransactionFormState {
  @override
  List<Object> get props => [];
}

final class FlowTransactionFormSuccessfullySubmitted
    extends FlowTransactionFormState {
  @override
  List<Object> get props => [];
}

final class FlowTransactionFormException extends FlowTransactionFormState {
  const FlowTransactionFormException(this.ex);

  final Object ex;

  @override
  List<Object> get props => [ex];
}
