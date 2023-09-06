import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todavenda/auth/models/user.dart';
import 'package:todavenda/auth/services/services.dart';

class UsersRepositoryFirestore implements UsersRepository {
  UsersRepositoryFirestore(this.authService);

  final AuthService authService;

  static const userCollectionPath = 'users';

  CollectionReference<AuthUser?> get userCollection =>
      FirebaseFirestore.instance.collection(userCollectionPath).withConverter(
            fromFirestore: (snapshot, _) => AuthUser.fromJson(snapshot.data()),
            toFirestore: (value, _) => value?.toJson() ?? {},
          );

  @override
  Future<AuthUser> createUser(AuthUser user) async {
    await userCollection.doc(user.uuid).set(user);
    return user;
  }

  @override
  Future<AuthUser?> getByEmail(String email) async {
    final user =
        await userCollection.where('email', isEqualTo: email).limit(1).get();
    return user.docs.isEmpty ? null : user.docs[0].data();
  }

  @override
  Future<AuthUser> login() async {
    final googleUser = await authService.loginWithGoogle();
    final user = await getByEmail(googleUser.email);
    if (user != null) {
      return user;
    }
    return await createUser(googleUser);
  }
}
