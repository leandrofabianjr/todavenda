part of 'flow_account_list_bloc.dart';

sealed class FlowAccountListEvent extends Equatable {
  const FlowAccountListEvent();
}

class FlowAccountListStarted extends FlowAccountListEvent {
  const FlowAccountListStarted();

  @override
  List<Object> get props => [];
}
