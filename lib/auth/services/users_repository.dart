import 'package:todavenda/auth/models/user.dart';

abstract class UsersRepository {
  Future<AuthUser> createOrUpdate(AuthUser user);

  Future<AuthUser?> getByEmail(String uuid);

  Future<AuthUser?> createOrUpdateByEmail(AuthUser user);
}
