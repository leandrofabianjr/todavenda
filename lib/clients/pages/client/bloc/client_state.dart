part of 'client_bloc.dart';

sealed class ClientState extends Equatable {
  const ClientState();
}

final class ClientLoading extends ClientState {
  @override
  List<Object> get props => [];
}

final class ClientLoaded extends ClientState {
  const ClientLoaded({required this.client});

  final Client client;

  @override
  List<Object> get props => [client];
}

final class ClientException extends ClientState {
  const ClientException(this.ex);

  final Object? ex;
  @override
  List<Object?> get props => [ex];
}
