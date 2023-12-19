part of 'flow_account_form_bloc.dart';

sealed class FlowAccountFormEvent extends Equatable {
  const FlowAccountFormEvent();
}

class FlowAccountFormStarted extends FlowAccountFormEvent {
  const FlowAccountFormStarted({this.uuid});

  final String? uuid;

  @override
  List<Object?> get props => [uuid];
}

final class FlowAccountFormSubmitted extends FlowAccountFormEvent {
  const FlowAccountFormSubmitted({
    this.uuid,
    required this.name,
    required this.description,
    required this.currentAmount,
  });

  final String? uuid;
  final String name;
  final String? description;
  final double currentAmount;

  @override
  List<Object?> get props => [uuid, name, description, currentAmount];
}
