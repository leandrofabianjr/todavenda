part of 'flow_account_bloc.dart';

sealed class FlowAccountEvent extends Equatable {
  const FlowAccountEvent();
}

class FlowAccountStarted extends FlowAccountEvent {
  const FlowAccountStarted();

  @override
  List<Object> get props => [];
}
