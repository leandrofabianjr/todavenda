part of 'flow_transaction_list_bloc.dart';

sealed class FlowTransactionListEvent extends Equatable {
  const FlowTransactionListEvent();
}

class FlowTransactionListStarted extends FlowTransactionListEvent {
  const FlowTransactionListStarted();

  @override
  List<Object> get props => [];
}
