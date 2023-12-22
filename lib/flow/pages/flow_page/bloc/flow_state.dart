part of 'flow_bloc.dart';

enum FlowStatus {
  loading,
  loaded,
  failure,
}

class FlowState extends Equatable {
  const FlowState({
    this.status = FlowStatus.loading,
    this.accounts = const [],
    this.transactionsReport,
    this.filter = const FlowFilter(),
    this.ex,
  });

  final FlowStatus status;
  final List<FlowAccount> accounts;
  final FlowTransactionReport? transactionsReport;
  final FlowFilter filter;
  final Object? ex;

  @override
  List<Object?> get props => [status, accounts, transactionsReport, ex];

  FlowState copyWith({
    FlowStatus? status,
    List<FlowAccount>? accounts,
    FlowTransactionReport? transactionsReport,
    Object? ex,
  }) {
    return FlowState(
      status: status ?? this.status,
      accounts: accounts ?? this.accounts,
      transactionsReport: transactionsReport ?? this.transactionsReport,
      ex: ex ?? this.ex,
    );
  }
}
