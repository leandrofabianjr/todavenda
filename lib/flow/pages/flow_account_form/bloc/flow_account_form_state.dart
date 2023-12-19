part of 'flow_account_form_bloc.dart';

sealed class FlowAccountFormState extends Equatable {
  const FlowAccountFormState();
}

final class FlowAccountFormEditing extends FlowAccountFormState {
  const FlowAccountFormEditing({
    this.uuid,
    this.name = '',
    this.description = '',
    this.nameError,
    this.currentAmount = 0,
  });

  final String? uuid;
  final String name;
  final String? description;
  final double currentAmount;
  final String? nameError;

  @override
  List<Object?> get props => [uuid, name, description, nameError];

  FlowAccountFormEditing copyWith({
    String? uuid,
    String? name,
    String? description,
    String? nameError,
    double? currentAmount,
  }) {
    return FlowAccountFormEditing(
      uuid: uuid ?? this.uuid,
      name: name ?? this.name,
      description: description ?? this.description,
      nameError: nameError ?? this.nameError,
      currentAmount: currentAmount ?? this.currentAmount,
    );
  }
}

final class FlowAccountFormSubmitting extends FlowAccountFormState {
  @override
  List<Object> get props => [];
}

final class FlowAccountFormSuccessfullySubmitted extends FlowAccountFormState {
  @override
  List<Object> get props => [];
}

final class FlowAccountFormException extends FlowAccountFormState {
  const FlowAccountFormException(this.ex);

  final Object ex;

  @override
  List<Object> get props => [ex];
}
