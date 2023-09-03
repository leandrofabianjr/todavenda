import 'package:todavenda/auth/services/auth_service.dart';

authMiddleware(context, state, callback) async {
  final authService = context.read<AuthService>() as AuthService;
  final isAuthenticated = await authService.isAuthenticated;
  if (isAuthenticated) {
    await callback();
  } else {
    state.redirect('/login');
  }
}
