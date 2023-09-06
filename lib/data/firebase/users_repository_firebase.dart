import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todavenda/auth/models/user.dart';
import 'package:todavenda/auth/services/services.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

class UsersRepositoryFirestore implements UsersRepository {
  static const userCollectionPath = 'users';

  CollectionReference<AuthUser?> get userCollection =>
      FirebaseFirestore.instance.collection(userCollectionPath).withConverter(
            fromFirestore: (snapshot, options) =>
                AuthUser.fromJson(snapshot.data()),
            toFirestore: (value, options) => value?.toJson() ?? {},
          );

  @override
  Future<AuthUser> createOrUpdate(AuthUser user) async {
    final newUser = user.uuid == null ? user.copyWith(uuid: _uuid.v4()) : user;

    await userCollection.doc(newUser.uuid).set(newUser);

    return newUser;
  }

  @override
  Future<AuthUser?> getByEmail(String email) async {
    final user =
        await userCollection.where('email', isEqualTo: email).limit(1).get();
    return user.docs.isEmpty ? null : user.docs[0].data();
  }

  @override
  Future<AuthUser?> createOrUpdateByEmail(AuthUser user) async {
    final foundUser = await getByEmail(user.email);
    final newUser = user.copyWith(uuid: foundUser?.uuid);
    return createOrUpdate(newUser);
  }
}
