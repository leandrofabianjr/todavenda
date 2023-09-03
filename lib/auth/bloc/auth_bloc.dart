import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:todavenda/auth/models/user.dart';
import 'package:todavenda/auth/services/auth_service.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(this.authService) : super(AuthInitial()) {
    on<AuthStarted>(_onStarted);
    on<AuthLogged>(_onLogged);
  }

  final AuthService authService;

  _onStarted(AuthStarted event, Emitter<AuthState> emit) async {
    final user = await authService.currentUser().first;
    if (user != null) {
      emit(AuthSuccess(user: user));
    } else {
      emit(AuthFailure());
    }
  }

  _onLogged(AuthLogged event, Emitter<AuthState> emit) {
    emit(AuthSuccess(user: event.user));
  }
}
