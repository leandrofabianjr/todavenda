import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:todavenda/sales/models/payment.dart';

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
      final owings = await clientsRepository.loadOwings(client);
      emit(ClientReady(client: client, owings: owings));
    } catch (ex) {
      emit(ClientException(ex));
    }
  }
}
