import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:todavenda/session/models/models.dart';
import 'package:todavenda/session/services/sessions_repository.dart';

part 'session_event.dart';
part 'session_state.dart';

class SessionBloc extends Bloc<SessionEvent, SessionState> {
  SessionBloc(this.sessionRepository, {required this.uuid})
      : super(SessionLoading()) {
    on<SessionStarted>(_onSessionStarted);
  }

  final SessionsRepository sessionRepository;
  final String uuid;

  Future<void> _onSessionStarted(
    SessionStarted event,
    Emitter<SessionState> emit,
  ) async {
    emit(SessionLoading());
    try {
      final session = await sessionRepository.getByUuid(uuid);
      emit(SessionLoaded(session: session!));
    } catch (ex) {
      emit(SessionException(ex));
    }
  }
}
