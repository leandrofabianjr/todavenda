part of 'flow_transaction_list_bloc.dart';

sealed class FlowTransactionListState extends Equatable {
  const FlowTransactionListState();
}

final class FlowTransactionListLoading extends FlowTransactionListState {
  @override
  List<Object> get props => [];
}

final class FlowTransactionListReady extends FlowTransactionListState {
  const FlowTransactionListReady({required this.transactions});

  final List<FlowTransaction> transactions;

  @override
  List<Object> get props => [transactions];
}

final class FlowTransactionListException extends FlowTransactionListState {
  const FlowTransactionListException(this.ex);

  final Object? ex;
  @override
  List<Object?> get props => [ex];
}
