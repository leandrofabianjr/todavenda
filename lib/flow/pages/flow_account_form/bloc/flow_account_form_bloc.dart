import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:todavenda/commons/validators.dart';
import 'package:todavenda/flow/services/flow_accounts_repository.dart';

part 'flow_account_form_event.dart';
part 'flow_account_form_state.dart';

class FlowAccountFormBloc
    extends Bloc<FlowAccountFormEvent, FlowAccountFormState> {
  FlowAccountFormBloc(this.flowAccountsRepository, {this.uuid})
      : super(const FlowAccountFormEditing()) {
    on<FlowAccountFormStarted>(_onStarted);
    on<FlowAccountFormSubmitted>(_onFormSubmitted);
  }

  final FlowAccountsRepository flowAccountsRepository;
  final String? uuid;

  Future<void> _onStarted(
    FlowAccountFormStarted event,
    Emitter<FlowAccountFormState> emit,
  ) async {
    if (event.uuid == null) {
      return emit(const FlowAccountFormEditing());
    }

    try {
      final account = await flowAccountsRepository.loadByUuid(event.uuid!);
      emit(FlowAccountFormEditing(
        uuid: account.uuid,
        name: account.name,
        description: account.description,
        currentAmount: account.currentAmount,
      ));
    } catch (ex) {
      emit(FlowAccountFormException(ex));
    }
  }

  void _onFormSubmitted(
    FlowAccountFormSubmitted event,
    Emitter<FlowAccountFormState> emit,
  ) async {
    final nameError = Validators.stringNotEmpty(event.name);

    if (nameError != null) {
      return emit(
        (state as FlowAccountFormEditing).copyWith(
          nameError: nameError,
        ),
      );
    }

    emit(FlowAccountFormSubmitting());

    try {
      await flowAccountsRepository.save(
        uuid: event.uuid,
        name: event.name,
        description: event.description,
        currentAmount: event.currentAmount,
      );
      emit(FlowAccountFormSuccessfullySubmitted());
    } catch (ex) {
      emit(FlowAccountFormException(ex));
    }
  }
}
