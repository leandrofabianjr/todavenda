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
    this.account,
    this.descriptionError,
    this.amountError,
    this.accounts,
    this.accountError,
  });

  final String? uuid;
  final FlowTransactionType type;
  final String description;
  final String? observation;
  final double amount;
  final DateTime? createdAt;
  final FlowAccount? account;
  final String? descriptionError;
  final String? amountError;
  final List<FlowAccount>? accounts;
  final String? accountError;

  @override
  List<Object?> get props => [
        uuid,
        type,
        description,
        observation,
        amount,
        createdAt,
        account,
        descriptionError,
        amountError,
        accountError,
        accounts,
      ];

  FlowTransactionFormEditing copyWith({
    String? uuid,
    FlowTransactionType? type,
    String? name,
    String? description,
    String? observation,
    double? amount,
    DateTime? createdAt,
    FlowAccount? account,
    String? descriptionError,
    String? amountError,
    String? accountError,
    List<FlowAccount>? accounts,
  }) {
    return FlowTransactionFormEditing(
      uuid: uuid ?? this.uuid,
      type: type ?? this.type,
      description: description ?? this.description,
      observation: observation ?? this.observation,
      amount: amount ?? this.amount,
      createdAt: createdAt ?? this.createdAt,
      account: account ?? this.account,
      descriptionError: descriptionError,
      amountError: amountError,
      accountError: accountError,
      accounts: accounts ?? this.accounts,
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
