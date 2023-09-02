import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:todavenda/commons/validators.dart';

import '../../../services/client_repository.dart';

part 'client_form_event.dart';
part 'client_form_state.dart';

class ClientFormBloc extends Bloc<ClientFormEvent, ClientFormState> {
  ClientFormBloc(this.clientRepository) : super(const ClientFormEditing()) {
    on<ClientFormSubmitted>(_onFormSubmitted);
  }

  final ClientsRepository clientRepository;

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
      await clientRepository.createClient(
        name: event.name,
      );
      emit(ClientFormSuccessfullySubmitted());
    } catch (ex) {
      emit(ClientFormException(ex));
    }
  }
}
