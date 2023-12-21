part of 'flow_transaction_bloc.dart';

sealed class FlowTransactionEvent extends Equatable {
  const FlowTransactionEvent();
}

class FlowTransactionStarted extends FlowTransactionEvent {
  const FlowTransactionStarted();

  @override
  List<Object> get props => [];
}
