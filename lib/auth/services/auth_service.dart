import 'package:firebase_auth/firebase_auth.dart';
import 'package:todavenda/auth/services/google_sign_in.dart';

import '../models/user.dart';

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

class AuthService {
  Future<bool> get isAuthenticated async => (await currentUser().first) != null;

  Stream<AuthUser?> currentUser() {
    return FirebaseAuth.instance.authStateChanges().map((User? user) {
      if (user != null) {
        return user.authUser;
      } else {
        return null;
      }
    });
  }

  Future<AuthUser?> loginWithGoogle() async {
    final UserCredential userCredential = await googleSignIn();
    return userCredential.user?.authUser;
  }

  Future<void> logout() {
    return FirebaseAuth.instance.signOut();
  }
}
