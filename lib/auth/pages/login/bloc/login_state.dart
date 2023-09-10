part of 'login_bloc.dart';

enum LoginStatus {
  initial,
  loading,
  failure,
  success,
}

final class LoginState extends Equatable {
  const LoginState({
    this.status = LoginStatus.initial,
    this.email = '',
    this.password = '',
    this.errorMessage,
    this.user,
  });

  final LoginStatus status;
  final String email;
  final String password;
  final String? errorMessage;
  final AuthUser? user;

  LoginState copyWith({
    LoginStatus? status,
    String? email,
    String? password,
    String? errorMessage,
    AuthUser? user,
  }) {
    return LoginState(
      status: status ?? this.status,
      email: email ?? this.email,
      password: password ?? this.password,
      errorMessage: errorMessage ?? this.errorMessage,
      user: user ?? this.user,
    );
  }

  @override
  List<Object?> get props => [status, email, password, errorMessage, user];
}
