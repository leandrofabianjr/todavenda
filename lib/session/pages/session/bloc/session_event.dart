part of 'session_bloc.dart';

sealed class SessionEvent extends Equatable {
  const SessionEvent();
}

class SessionStarted extends SessionEvent {
  const SessionStarted();

  @override
  List<Object> get props => [];
}
