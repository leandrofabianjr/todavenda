part of 'login_bloc.dart';

sealed class LoginState extends Equatable {
  const LoginState();
}

final class LoginInitial extends LoginState {
  @override
  List<Object> get props => [];
}

final class LoginLoading extends LoginState {
  @override
  List<Object> get props => [];
}

final class LoginSuccess extends LoginState {
  const LoginSuccess({required this.user});

  final AuthUser user;

  @override
  List<Object> get props => [user];
}

final class LoginException extends LoginState {
  const LoginException({this.ex});
  final Object? ex;

  @override
  List<Object?> get props => [ex];
}
