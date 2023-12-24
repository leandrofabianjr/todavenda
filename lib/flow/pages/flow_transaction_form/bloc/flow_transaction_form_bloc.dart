import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:todavenda/commons/validators.dart';
import 'package:todavenda/flow/models/flow_account.dart';
import 'package:todavenda/flow/models/flow_transaction.dart';
import 'package:todavenda/flow/services/flow_accounts_repository.dart';
import 'package:todavenda/flow/services/flow_transactions_repository.dart';

part 'flow_transaction_form_event.dart';
part 'flow_transaction_form_state.dart';

class FlowTransactionFormBloc
    extends Bloc<FlowTransactionFormEvent, FlowTransactionFormState> {
  FlowTransactionFormBloc({
    this.uuid,
    required this.flowTransactionsRepository,
    required this.flowAccountsRepository,
  }) : super(const FlowTransactionFormEditing()) {
    on<FlowTransactionFormStarted>(_onStarted);
    on<FlowTransactionFormSubmitted>(_onFormSubmitted);
  }

  final String? uuid;
  final FlowTransactionsRepository flowTransactionsRepository;
  final FlowAccountsRepository flowAccountsRepository;

  Future<void> _onStarted(
    FlowTransactionFormStarted event,
    Emitter<FlowTransactionFormState> emit,
  ) async {
    final accounts = await flowAccountsRepository.load();

    if (event.uuid == null) {
      return emit(FlowTransactionFormEditing(accounts: accounts));
    }

    try {
      final transaction =
          await flowTransactionsRepository.loadByUuid(event.uuid!);
      emit(FlowTransactionFormEditing(
        uuid: transaction.uuid,
        account: transaction.account,
        type: transaction.type,
        description: transaction.description,
        observation: transaction.observation,
        amount: transaction.amount,
        createdAt: transaction.createdAt,
        accounts: accounts,
      ));
    } catch (ex) {
      emit(FlowTransactionFormException(ex));
    }
  }

  void _onFormSubmitted(
    FlowTransactionFormSubmitted event,
    Emitter<FlowTransactionFormState> emit,
  ) async {
    var newState = (state as FlowTransactionFormEditing).copyWith(
      account: event.account,
      description: event.description,
      amount: event.amount,
      observation: event.observation,
      type: event.type,
      createdAt: event.createdAt,
      accountError: event.account == null ? 'Informe a conta' : null,
      descriptionError: Validators.stringNotEmpty(event.description),
      amountError: Validators.greaterThanZero(event.amount),
    );

    if (newState.descriptionError != null ||
        newState.amountError != null ||
        newState.accountError != null) {
      return emit(newState);
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
        account: event.account!,
      );
      emit(FlowTransactionFormSuccessfullySubmitted());
    } catch (ex) {
      emit(FlowTransactionFormException(ex));
    }
  }
}
