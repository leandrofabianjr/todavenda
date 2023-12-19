import 'package:todavenda/session/models/models.dart';

class SessionSupply extends SessionMovement {
  const SessionSupply({
    required super.uuid,
    required super.sessionUuid,
    required super.createdAt,
    required this.amount,
  }) : super(type: SessionMovementType.supply);

  final double amount;
}
