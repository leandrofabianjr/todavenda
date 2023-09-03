part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();
}

class AuthStarted extends AuthEvent {
  const AuthStarted();

  @override
  List<Object?> get props => [];
}

class AuthLogged extends AuthEvent {
  const AuthLogged({required this.user});

  final AuthUser user;

  @override
  List<Object> get props => [user];
}
