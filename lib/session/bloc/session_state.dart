part of 'session_bloc.dart';

enum SessionStatus {
  closed,
  open,
  exception,
  loading,
}

class SessionState extends Equatable {
  const SessionState({
    this.status = SessionStatus.closed,
    Session? session,
    this.exception,
  }) : _session = session;

  final SessionStatus status;
  final Session? _session;
  final Object? exception;

  Session get session => _session!;

  SessionState copyWith({
    SessionStatus? status,
    Session? session,
    Object? exception,
  }) {
    return SessionState(
      status: status ?? this.status,
      session: session ?? _session,
      exception: exception ?? this.exception,
    );
  }

  @override
  List<Object?> get props => [status, _session, exception];
}
