import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:todavenda/session/models/models.dart';
import 'package:todavenda/session/services/sessions_repository.dart';

part 'session_event.dart';
part 'session_state.dart';

class SessionBloc extends Bloc<SessionEvent, SessionState> {
  SessionBloc(this.sessionsRepository) : super(const SessionState()) {
    on<SessionCreated>(_onCreated);
    on<SessionInitiated>(_onInitiated);
  }

  final SessionsRepository sessionsRepository;

  _onInitiated(
    SessionInitiated event,
    Emitter<SessionState> emit,
  ) async {
    try {
      emit(state.copyWith(status: SessionStatus.loading));
      final session = await sessionsRepository.current;
      if (session == null) {
        emit(state.copyWith(status: SessionStatus.closed));
      } else {
        emit(state.copyWith(status: SessionStatus.open, session: session));
      }
    } catch (ex) {
      emit(state.copyWith(exception: ex));
    }
  }

  _onCreated(
    SessionCreated event,
    Emitter<SessionState> emit,
  ) async {
    try {
      emit(state.copyWith(status: SessionStatus.loading));
      if (await sessionsRepository.hasCurrentSession) {
        throw Exception('Já existe uma sessão aberta');
      }
      final session = await sessionsRepository.create(
        openingAmount: event.openingAmount,
      );
      emit(state.copyWith(status: SessionStatus.open, session: session));
    } catch (ex) {
      emit(state.copyWith(exception: ex));
    }
  }
}
