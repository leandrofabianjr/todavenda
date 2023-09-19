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

class SessionSupplied extends SessionEvent {
  const SessionSupplied({required this.amount});

  final double amount;

  @override
  List<Object> get props => [amount];
}

class SessionPickedUp extends SessionEvent {
  const SessionPickedUp({required this.amount});

  final double amount;

  @override
  List<Object> get props => [amount];
}

class SessionClosed extends SessionEvent {
  const SessionClosed({this.closingAmount});

  final double? closingAmount;

  @override
  List<Object?> get props => [closingAmount];
}
