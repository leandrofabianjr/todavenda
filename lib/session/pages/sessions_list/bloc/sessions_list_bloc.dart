import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:todavenda/session/models/models.dart';
import 'package:todavenda/session/services/sessions_repository.dart';

part 'sessions_list_event.dart';
part 'sessions_list_state.dart';

class SessionsListBloc extends Bloc<SessionsListEvent, SessionsListState> {
  SessionsListBloc(this.sessionsRepository)
      : super(const SessionsListLoading()) {
    on<SessionsListRefreshed>(_onRefreshed);
  }

  final SessionsRepository sessionsRepository;

  _onRefreshed(
    SessionsListRefreshed event,
    Emitter<SessionsListState> emit,
  ) async {
    emit(const SessionsListLoading());
    try {
      final sessions = await sessionsRepository.list();
      sessions.sortByCompare(
        (element) => element.createdAt!,
        (a, b) => b.microsecondsSinceEpoch - a.microsecondsSinceEpoch,
      );
      emit(SessionsListLoaded(sessions: sessions));
    } catch (ex) {
      emit(SessionsListException(ex));
    }
  }
}
