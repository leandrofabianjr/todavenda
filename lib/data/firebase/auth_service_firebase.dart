import 'package:firebase_auth/firebase_auth.dart';
import 'package:todavenda/auth/services/auth_service.dart';
import 'package:todavenda/auth/services/google_sign_in.dart';

import '../../auth/models/user.dart';

extension on User {
  AuthUser get authUser {
    return AuthUser(
      googleUid: uid,
      email: email ?? '',
      name: displayName ?? '',
      picture: photoURL,
    );
  }
}

class AuthServiceFirebase implements AuthService {
  @override
  Future<bool> get isAuthenticated async => (await currentUser().first) != null;

  @override
  Stream<AuthUser?> currentUser() {
    return FirebaseAuth.instance.authStateChanges().map((User? user) {
      if (user != null) {
        return user.authUser;
      } else {
        return null;
      }
    });
  }

  @override
  Future<AuthUser?> loginWithGoogle() async {
    final UserCredential userCredential = await googleSignIn();
    return userCredential.user?.authUser;
  }

  @override
  Future<void> logout() {
    return FirebaseAuth.instance.signOut();
  }
}
