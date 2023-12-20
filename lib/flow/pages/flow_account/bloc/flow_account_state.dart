part of 'flow_account_bloc.dart';

sealed class FlowAccountState extends Equatable {
  const FlowAccountState();
}

final class FlowAccountLoading extends FlowAccountState {
  @override
  List<Object> get props => [];
}

final class FlowAccountReady extends FlowAccountState {
  const FlowAccountReady({required this.account});

  final FlowAccount account;

  @override
  List<Object> get props => [FlowAccount];
}

final class FlowAccountException extends FlowAccountState {
  const FlowAccountException(this.ex);

  final Object? ex;
  @override
  List<Object?> get props => [ex];
}
