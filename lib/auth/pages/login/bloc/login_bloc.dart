import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:todavenda/auth/services/services.dart';

import '../../../models/user.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({
    required this.authService,
    required this.usersRepository,
  }) : super(LoginInitial()) {
    on<LoginWithGoogleRequested>(_onLoginWithGoogleRequested);
  }

  final AuthService authService;
  final UsersRepository usersRepository;

  _onLoginWithGoogleRequested(
    LoginWithGoogleRequested event,
    Emitter<LoginState> emit,
  ) async {
    try {
      emit(LoginLoading());
      final googleUser = await authService.loginWithGoogle();
      final user = await usersRepository.createOrUpdateByEmail(googleUser);
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
