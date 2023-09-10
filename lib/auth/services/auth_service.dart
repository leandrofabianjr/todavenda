import '../models/user.dart';

abstract class AuthService {
  Future<bool> get isAuthenticated;

  Stream<AuthUser?> currentUser();

  Future<AuthUser> loginWithGoogle();

  Future<void> logout();

  Future<AuthUser> loginWithEmail({
    required String email,
    required String password,
  });
}

class AuthServiceException {
  const AuthServiceException(this.message);

  final String message;
}
