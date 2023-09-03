import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:todavenda/auth/models/user.dart';
import 'package:todavenda/auth/services/auth_service.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({required this.authService}) : super(LoginInitial()) {
    on<LoginWithGoogleRequested>(_onLoginWithGoogleRequested);
  }

  final AuthService authService;

  _onLoginWithGoogleRequested(
    LoginWithGoogleRequested event,
    Emitter<LoginState> emit,
  ) async {
    try {
      final user = await authService.loginWithGoogle();
      if (user != null) {
        emit(LoginSuccess(user: user));
      } else {
        emit(const LoginException());
      }
    } catch (ex) {
      emit(LoginException(ex: ex));
    }
  }
}
