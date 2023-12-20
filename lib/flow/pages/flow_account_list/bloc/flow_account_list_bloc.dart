import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:todavenda/flow/models/flow_account.dart';
import 'package:todavenda/flow/services/flow_accounts_repository.dart';

part 'flow_account_list_event.dart';
part 'flow_account_list_state.dart';

class FlowAccountListBloc
    extends Bloc<FlowAccountListEvent, FlowAccountListState> {
  FlowAccountListBloc(this.flowAccountsRepository)
      : super(FlowAccountListLoading()) {
    on<FlowAccountListStarted>(_onFlowAccountListStarted);
  }

  final FlowAccountsRepository flowAccountsRepository;

  Future<void> _onFlowAccountListStarted(
    FlowAccountListStarted event,
    Emitter<FlowAccountListState> emit,
  ) async {
    emit(FlowAccountListLoading());
    try {
      final accounts = await flowAccountsRepository.load();
      emit(FlowAccountListReady(accounts: accounts));
    } catch (ex) {
      emit(FlowAccountListException(ex));
    }
  }
}
