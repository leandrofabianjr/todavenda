import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:todavenda/flow/models/flow_transaction.dart';
import 'package:todavenda/flow/services/flow_transactions_repository.dart';

part 'flow_transaction_event.dart';
part 'flow_transaction_state.dart';

class FlowTransactionBloc
    extends Bloc<FlowTransactionEvent, FlowTransactionState> {
  FlowTransactionBloc(this.flowTransactionsRepository, {required this.uuid})
      : super(FlowTransactionLoading()) {
    on<FlowTransactionStarted>(_onFlowTransactionStarted);
  }

  final FlowTransactionsRepository flowTransactionsRepository;
  final String uuid;

  Future<void> _onFlowTransactionStarted(
    FlowTransactionStarted event,
    Emitter<FlowTransactionState> emit,
  ) async {
    emit(FlowTransactionLoading());
    try {
      final transaction = await flowTransactionsRepository.loadByUuid(uuid);
      emit(FlowTransactionReady(transaction: transaction));
    } catch (ex) {
      emit(FlowTransactionException(ex));
    }
  }
}
