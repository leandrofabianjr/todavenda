import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../clients.dart';

part 'client_event.dart';
part 'client_state.dart';

class ClientBloc extends Bloc<ClientEvent, ClientState> {
  ClientBloc(this.clientsRepository, {required this.uuid})
      : super(ClientLoading()) {
    on<ClientStarted>(_onClientStarted);
  }

  final ClientsRepository clientsRepository;
  final String uuid;

  Future<void> _onClientStarted(
    ClientStarted event,
    Emitter<ClientState> emit,
  ) async {
    emit(ClientLoading());
    try {
      final client = await clientsRepository.loadClientByUuid(uuid);
      emit(ClientReady(client: client));
    } catch (ex) {
      emit(ClientException(ex));
    }
  }
}
