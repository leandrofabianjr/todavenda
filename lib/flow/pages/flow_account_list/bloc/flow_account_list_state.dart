part of 'flow_account_list_bloc.dart';

sealed class FlowAccountListState extends Equatable {
  const FlowAccountListState();
}

final class FlowAccountListLoading extends FlowAccountListState {
  @override
  List<Object> get props => [];
}

final class FlowAccountListReady extends FlowAccountListState {
  const FlowAccountListReady({required this.accounts});

  final List<FlowAccount> accounts;

  @override
  List<Object> get props => [accounts];
}

final class FlowAccountListException extends FlowAccountListState {
  const FlowAccountListException(this.ex);

  final Object? ex;
  @override
  List<Object?> get props => [ex];
}
