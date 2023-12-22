import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:todavenda/flow/models/flow_account.dart';
import 'package:todavenda/flow/models/flow_transaction.dart';
import 'package:todavenda/flow/services/flow_accounts_repository.dart';
import 'package:todavenda/flow/services/flow_transactions_repository.dart';

part 'flow_event.dart';
part 'flow_state.dart';

class FlowBloc extends Bloc<FlowEvent, FlowState> {
  FlowBloc({
    required this.flowAccountsRepository,
    required this.flowTransactionsRepository,
  }) : super(const FlowState()) {
    on<FlowRefreshed>(_onRefreshed);
  }

  final FlowAccountsRepository flowAccountsRepository;
  final FlowTransactionsRepository flowTransactionsRepository;

  void _onRefreshed(
    FlowRefreshed event,
    Emitter<FlowState> emit,
  ) async {
    emit(state.copyWith(status: FlowStatus.loading));

    try {
      final accounts = await flowAccountsRepository.load();
      final transactions = await flowTransactionsRepository.load();

      emit(state.copyWith(
        status: FlowStatus.loaded,
        accounts: accounts,
        transactionsReport: FlowTransactionReport(transactions: transactions),
      ));
    } catch (ex) {
      emit(state.copyWith(status: FlowStatus.failure, ex: ex));
    }
  }
}
