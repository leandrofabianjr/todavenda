import 'package:todavenda/auth/models/user.dart';

abstract class UsersRepository {
  Future<AuthUser> createUser(AuthUser user);

  Future<AuthUser?> getByEmail(String uuid);

  Future<AuthUser?> login();
}
