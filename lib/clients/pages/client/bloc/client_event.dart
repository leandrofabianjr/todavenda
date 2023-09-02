part of 'client_bloc.dart';

sealed class ClientEvent extends Equatable {
  const ClientEvent();
}

class ClientStarted extends ClientEvent {
  const ClientStarted();

  @override
  List<Object> get props => [];
}
