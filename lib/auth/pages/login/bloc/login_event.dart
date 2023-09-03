part of 'login_bloc.dart';

sealed class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

final class LoginWithGoogleRequested extends LoginEvent {
  const LoginWithGoogleRequested();
}
