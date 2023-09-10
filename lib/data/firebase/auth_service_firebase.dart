import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:todavenda/auth/services/google_sign_in.dart';
import 'package:todavenda/auth/services/services.dart';

import '../../auth/models/user.dart';

extension on User {
  AuthUser get authUser {
    return AuthUser(
      uuid: uid,
      email: email ?? '',
      name: displayName ?? '',
      picture: photoURL,
      googleUserData: jsonEncode({
        'uid': uid,
        'displayName': displayName,
        'email': email,
        'isEmailVerified': emailVerified,
        'isAnonymous': isAnonymous,
        'metadata': {
          'creationTime': metadata.creationTime?.toString(),
          'lastSignInTime': metadata.lastSignInTime?.toString(),
        },
        'phoneNumber': phoneNumber,
        'photoURL': photoURL,
        // 'providerData': providerData
        //     .map(
        //       (e) => {
        //         'displayName': e.displayName,
        //         'email': e.email,
        //         'phoneNumber': e.phoneNumber,
        //         'photoURL': e.photoURL,
        //         'providerId': e.providerId,
        //         'uid': e.uid,
        //       },
        //     )
        //     .toList(),
        'refreshToken': refreshToken,
        'tenantId': tenantId,
      }),
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
  Future<AuthUser> loginWithGoogle() async {
    final UserCredential userCredential = await googleSignIn();
    return userCredential.user!.authUser;
  }

  @override
  Future<void> logout() {
    return FirebaseAuth.instance.signOut();
  }

  @override
  Future<AuthUser> loginWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user!.authUser;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        throw const AuthServiceException('E-mail ou senha inválidos');
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }
}
