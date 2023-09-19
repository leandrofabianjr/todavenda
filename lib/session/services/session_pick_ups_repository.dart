import '../models/models.dart';

abstract interface class SessionPickUpsRepository {
  Future<SessionPickUp> create({
    required String sessionUuid,
    required double amount,
  });

  Future<List<SessionPickUp>> list({
    String? sessionUuid,
  });

  Future<SessionPickUp?> getByUuid(String uuid);

  Future<void> remove(String? uuid);
}
