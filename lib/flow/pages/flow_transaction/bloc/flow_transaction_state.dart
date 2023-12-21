part of 'flow_transaction_bloc.dart';

sealed class FlowTransactionState extends Equatable {
  const FlowTransactionState();
}

final class FlowTransactionLoading extends FlowTransactionState {
  @override
  List<Object> get props => [];
}

final class FlowTransactionReady extends FlowTransactionState {
  const FlowTransactionReady({required this.transaction});

  final FlowTransaction transaction;

  @override
  List<Object> get props => [FlowTransaction];
}

final class FlowTransactionException extends FlowTransactionState {
  const FlowTransactionException(this.ex);

  final Object? ex;
  @override
  List<Object?> get props => [ex];
}
