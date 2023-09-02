part of 'clients_list_bloc.dart';

sealed class ClientListState extends Equatable {
  const ClientListState();
}

final class ClientListLoading extends ClientListState {
  @override
  List<Object?> get props => [];
}

final class ClientListLoaded extends ClientListState {
  const ClientListLoaded(this.clients);

  final List<Client> clients;

  @override
  List<Object> get props => [clients];
}

final class ClientListException extends ClientListState {
  const ClientListException(this.ex);

  final Object? ex;

  @override
  List<Object?> get props => [ex];
}
