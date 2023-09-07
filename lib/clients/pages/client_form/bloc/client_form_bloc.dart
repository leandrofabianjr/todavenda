import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:todavenda/commons/validators.dart';

import '../../../services/clients_repository.dart';

part 'client_form_event.dart';
part 'client_form_state.dart';

class ClientFormBloc extends Bloc<ClientFormEvent, ClientFormState> {
  ClientFormBloc(this.clientsRepository) : super(const ClientFormEditing()) {
    on<ClientFormSubmitted>(_onFormSubmitted);
  }

  final ClientsRepository clientsRepository;

  void _onFormSubmitted(
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
      await clientsRepository.createClient(
        companyUuid: event.companyUuid,
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
