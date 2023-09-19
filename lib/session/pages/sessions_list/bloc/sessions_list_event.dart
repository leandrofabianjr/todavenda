part of 'sessions_list_bloc.dart';

sealed class SessionsListEvent extends Equatable {
  const SessionsListEvent();
}

class SessionsListRefreshed extends SessionsListEvent {
  const SessionsListRefreshed();

  @override
  List<Object?> get props => [];
}
