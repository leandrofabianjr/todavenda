part of 'session_bloc.dart';

enum SessionStatus {
  closed,
  open,
  exception,
  loading,
  success,
}

class SessionState extends Equatable {
  const SessionState({
    this.status = SessionStatus.closed,
    Session? session,
    this.exception,
    this.errorMessage,
  }) : _session = session;

  final SessionStatus status;
  final Session? _session;
  final Object? exception;
  final String? errorMessage;

  Session get session => _session!;

  SessionState copyWith({
    SessionStatus? status,
    Session? session,
    Object? exception,
    String? errorMessage,
  }) {
    return SessionState(
      status: status ?? this.status,
      session: session ?? _session,
      exception: exception ?? this.exception,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, _session, exception, errorMessage];
}
