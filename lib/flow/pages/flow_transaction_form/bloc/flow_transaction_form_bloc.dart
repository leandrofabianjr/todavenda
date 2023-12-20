import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:todavenda/commons/validators.dart';
import 'package:todavenda/flow/models/flow_transaction.dart';
import 'package:todavenda/flow/services/flow_transactions_repository.dart';

part 'flow_transaction_form_event.dart';
part 'flow_transaction_form_state.dart';

class FlowTransactionFormBloc
    extends Bloc<FlowTransactionFormEvent, FlowTransactionFormState> {
  FlowTransactionFormBloc(this.flowTransactionsRepository, {this.uuid})
      : super(const FlowTransactionFormEditing()) {
    on<FlowTransactionFormStarted>(_onStarted);
    on<FlowTransactionFormSubmitted>(_onFormSubmitted);
  }

  final FlowTransactionsRepository flowTransactionsRepository;
  final String? uuid;

  Future<void> _onStarted(
    FlowTransactionFormStarted event,
    Emitter<FlowTransactionFormState> emit,
  ) async {
    if (event.uuid == null) {
      return emit(const FlowTransactionFormEditing());
    }

    try {
      final transaction =
          await flowTransactionsRepository.loadByUuid(event.uuid!);
      emit(FlowTransactionFormEditing(
        uuid: transaction.uuid,
        type: transaction.type,
        description: transaction.description,
        observation: transaction.observation,
        amount: transaction.amount,
        createdAt: transaction.createdAt,
      ));
    } catch (ex) {
      emit(FlowTransactionFormException(ex));
    }
  }

  void _onFormSubmitted(
    FlowTransactionFormSubmitted event,
    Emitter<FlowTransactionFormState> emit,
  ) async {
    final descriptionError = Validators.stringNotEmpty(event.description);
    final amountError = Validators.greaterThanZero(event.amount);

    if (descriptionError != null || amountError != null) {
      return emit(
        (state as FlowTransactionFormEditing).copyWith(
          descriptionError: descriptionError,
          amountError: amountError,
        ),
      );
    }

    emit(FlowTransactionFormSubmitting());

    try {
      await flowTransactionsRepository.save(
        uuid: event.uuid,
        type: event.type,
        description: event.description,
        observation: event.observation,
        amount: event.amount,
        createdAt: event.createdAt ?? DateTime.now(),
      );
      emit(FlowTransactionFormSuccessfullySubmitted());
    } catch (ex) {
      emit(FlowTransactionFormException(ex));
    }
  }
}
