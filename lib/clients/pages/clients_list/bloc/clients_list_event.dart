part of 'clients_list_bloc.dart';

sealed class ClientListEvent extends Equatable {
  const ClientListEvent();
}

class ClientListStarted extends ClientListEvent {
  const ClientListStarted({required this.companyUuid});

  final String companyUuid;

  @override
  List<Object> get props => [];
}
