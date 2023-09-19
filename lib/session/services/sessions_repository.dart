import '../models/models.dart';

abstract interface class SessionsRepository {
  Future<Session?> get current;

  Future<bool> get hasCurrentSession;

  Future<List<Session>> list();

  Future<Session?> getByUuid(String uuid);

  Future<Session> create({double? openingAmount});

  Future<Session> createSupply(double amount);

  Future<Session> createPickUp(double amount);

  Future<Session> update(Session updatedSession);

  Future<Session> close({double? closingAmount});
}
