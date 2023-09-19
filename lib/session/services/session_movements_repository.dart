import '../models/models.dart';

abstract interface class SessionMovementsRepository {
  Future<List<SessionMovement>> list({
    String? sessionUuid,
    SessionMovementType? type,
    String? saleUuid,
  });

  Future<SessionMovement?> getByUuid(String uuid);

  Future<void> remove(String? uuid);
}
