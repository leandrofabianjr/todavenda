import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:todavenda/auth/services/services.dart';

import '../../../models/user.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({required this.authService}) : super(const LoginState()) {
    on<LoginSubmitted>(_onLoginWithEmail);
  }

  final AuthService authService;

  _onLoginWithEmail(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    try {
      emit(state.copyWith(status: LoginStatus.loading));
      final user = await authService.loginWithEmail(
        email: event.email,
        password: event.password,
      );
      emit(state.copyWith(status: LoginStatus.success, user: user));
      return;
    } on AuthServiceException catch (ex) {
      emit(state.copyWith(
        status: LoginStatus.failure,
        errorMessage: ex.message,
      ));
    } catch (ex) {
      emit(state.copyWith(
        status: LoginStatus.failure,
        errorMessage: 'Desculpe! Algo deu errado',
      ));
    }
  }
}
