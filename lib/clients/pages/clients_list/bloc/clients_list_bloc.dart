import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../models/client.dart';
import '../../../services/clients_repository.dart';

part 'clients_list_event.dart';
part 'clients_list_state.dart';

class ClientListBloc extends Bloc<ClientListEvent, ClientListState> {
  ClientListBloc(this.clientsRepository) : super(ClientListLoading()) {
    on<ClientListStarted>(_onStarted);
  }

  final ClientsRepository clientsRepository;

  Future<void> _onStarted(
    ClientListStarted event,
    Emitter<ClientListState> emit,
  ) async {
    emit(ClientListLoading());
    try {
      final clientList = await clientsRepository.loadClients();
      emit(ClientListLoaded(clientList));
    } catch (ex) {
      emit(ClientListException(ex));
    }
  }
}
