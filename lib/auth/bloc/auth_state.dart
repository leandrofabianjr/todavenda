part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

final class AuthInitial extends AuthState {}

final class AuthSuccess extends AuthState {
  const AuthSuccess({required this.user});
  final AuthUser user;

  @override
  List<Object> get props => [user];
}

final class AuthFailure extends AuthState {}
