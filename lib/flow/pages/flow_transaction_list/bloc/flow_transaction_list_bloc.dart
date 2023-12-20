import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:todavenda/flow/models/flow_transaction.dart';
import 'package:todavenda/flow/services/flow_transactions_repository.dart';

part 'flow_transaction_list_event.dart';
part 'flow_transaction_list_state.dart';

class FlowTransactionListBloc
    extends Bloc<FlowTransactionListEvent, FlowTransactionListState> {
  FlowTransactionListBloc(this.flowTransactionsRepository)
      : super(FlowTransactionListLoading()) {
    on<FlowTransactionListStarted>(_onFlowTransactionListStarted);
  }

  final FlowTransactionsRepository flowTransactionsRepository;

  Future<void> _onFlowTransactionListStarted(
    FlowTransactionListStarted event,
    Emitter<FlowTransactionListState> emit,
  ) async {
    emit(FlowTransactionListLoading());
    try {
      final transactions = await flowTransactionsRepository.load();
      emit(FlowTransactionListReady(transactions: transactions));
    } catch (ex) {
      emit(FlowTransactionListException(ex));
    }
  }
}
