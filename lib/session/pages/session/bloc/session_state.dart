part of 'session_bloc.dart';

sealed class SessionState extends Equatable {
  const SessionState();
}

final class SessionLoading extends SessionState {
  @override
  List<Object> get props => [];
}

final class SessionLoaded extends SessionState {
  const SessionLoaded({required this.session});

  final Session session;

  @override
  List<Object> get props => [session];
}

final class SessionException extends SessionState {
  const SessionException(this.ex);

  final Object? ex;
  @override
  List<Object?> get props => [ex];
}
