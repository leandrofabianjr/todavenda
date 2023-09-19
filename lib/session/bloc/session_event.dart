part of 'session_bloc.dart';

sealed class SessionEvent extends Equatable {
  const SessionEvent();

  @override
  List<Object?> get props => [];
}

class SessionInitiated extends SessionEvent {
  const SessionInitiated();
}

class SessionCreated extends SessionEvent {
  const SessionCreated({this.openingAmount});

  final double? openingAmount;

  @override
  List<Object?> get props => [openingAmount];
}
