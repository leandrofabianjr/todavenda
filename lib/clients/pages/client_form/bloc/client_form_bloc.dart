import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:todavenda/commons/validators.dart';

import '../../../services/clients_repository.dart';

part 'client_form_event.dart';
part 'client_form_state.dart';

class ClientFormBloc extends Bloc<ClientFormEvent, ClientFormState> {
  ClientFormBloc(this.clientsRepository) : super(const ClientFormEditing()) {
    on<ClientFormStarted>(_onStarted);
    on<ClientFormSubmitted>(_onSubmitted);
  }

  final ClientsRepository clientsRepository;

  Future<void> _onStarted(
    ClientFormStarted event,
    Emitter<ClientFormState> emit,
  ) async {
    if (event.uuid == null) {
      return emit(const ClientFormEditing());
    }

    try {
      final client = await clientsRepository.loadClientByUuid(event.uuid!);
      emit(ClientFormEditing(
        uuid: client.uuid,
        name: client.name,
        phone: client.phone,
        address: client.address,
        observation: client.observation,
      ));
    } catch (ex) {
      emit(ClientFormException(ex));
    }
  }

  void _onSubmitted(
    ClientFormSubmitted event,
    Emitter<ClientFormState> emit,
  ) async {
    final nameError = Validators.stringNotEmpty(event.name);

    if (nameError != null) {
      return emit(
        (state as ClientFormEditing).copyWith(nameError: nameError),
      );
    }

    emit(ClientFormSubmitting());

    try {
      await clientsRepository.saveClient(
        uuid: event.uuid,
        name: event.name,
        phone: event.phone,
        address: event.address,
        observation: event.observation,
      );
      emit(ClientFormSuccessfullySubmitted());
    } catch (ex) {
      emit(ClientFormException(ex));
    }
  }
}
