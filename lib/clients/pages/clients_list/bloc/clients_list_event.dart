part of 'clients_list_bloc.dart';

sealed class ClientListEvent extends Equatable {
  const ClientListEvent();
}

class ClientListStarted extends ClientListEvent {
  const ClientListStarted();

  @override
  List<Object> get props => [];
}
