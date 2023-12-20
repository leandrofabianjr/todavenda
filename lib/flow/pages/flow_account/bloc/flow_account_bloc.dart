import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:todavenda/flow/models/flow_account.dart';
import 'package:todavenda/flow/services/flow_accounts_repository.dart';

part 'flow_account_event.dart';
part 'flow_account_state.dart';

class FlowAccountBloc extends Bloc<FlowAccountEvent, FlowAccountState> {
  FlowAccountBloc(this.flowAccountsRepository, {required this.uuid})
      : super(FlowAccountLoading()) {
    on<FlowAccountStarted>(_onFlowAccountStarted);
  }

  final FlowAccountsRepository flowAccountsRepository;
  final String uuid;

  Future<void> _onFlowAccountStarted(
    FlowAccountStarted event,
    Emitter<FlowAccountState> emit,
  ) async {
    emit(FlowAccountLoading());
    try {
      final account = await flowAccountsRepository.loadByUuid(uuid);
      emit(FlowAccountReady(account: account));
    } catch (ex) {
      emit(FlowAccountException(ex));
    }
  }
}
