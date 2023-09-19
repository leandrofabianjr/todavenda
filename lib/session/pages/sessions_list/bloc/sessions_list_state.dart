part of 'sessions_list_bloc.dart';

sealed class SessionsListState extends Equatable {
  const SessionsListState();
}

final class SessionsListLoading extends SessionsListState {
  const SessionsListLoading();

  @override
  List<Object> get props => [];
}

final class SessionsListLoaded extends SessionsListState {
  const SessionsListLoaded({required this.sessions});

  final List<Session> sessions;

  @override
  List<Object> get props => [sessions.hashCode];
}

final class SessionsListException extends SessionsListState {
  const SessionsListException(this.ex);

  final Object? ex;

  @override
  List<Object?> get props => [ex];
}
