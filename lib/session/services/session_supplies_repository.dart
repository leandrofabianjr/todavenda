import '../models/models.dart';

abstract interface class SessionSuppliesRepository {
  Future<SessionSupply> create({
    required String sessionUuid,
    required double amount,
  });

  Future<List<SessionSupply>> list({
    String? sessionUuid,
  });

  Future<SessionSupply?> getByUuid(String uuid);

  Future<void> remove(String? uuid);
}
