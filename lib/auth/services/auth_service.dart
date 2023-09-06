import '../models/user.dart';

abstract class AuthService {
  Future<bool> get isAuthenticated;

  Stream<AuthUser?> currentUser();

  Future<AuthUser> loginWithGoogle();

  Future<void> logout();
}
