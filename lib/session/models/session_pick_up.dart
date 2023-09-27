import 'package:todavenda/session/models/models.dart';

class SessionPickUp extends SessionMovement {
  const SessionPickUp({
    super.uuid,
    required super.sessionUuid,
    required super.createdAt,
    required this.amount,
  }) : super(type: SessionMovementType.pickUp);

  final double amount;
}
