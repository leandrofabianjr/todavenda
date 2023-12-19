part of 'client_bloc.dart';

sealed class ClientState extends Equatable {
  const ClientState();
}

final class ClientLoading extends ClientState {
  @override
  List<Object> get props => [];
}

final class ClientReady extends ClientState {
  const ClientReady({
    required this.client,
    required this.owings,
  });

  final Client client;
  final List<Payment> owings;

  @override
  List<Object> get props => [client, owings];
}

final class ClientException extends ClientState {
  const ClientException(this.ex);

  final Object? ex;
  @override
  List<Object?> get props => [ex];
}
