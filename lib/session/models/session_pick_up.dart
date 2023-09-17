import 'package:todavenda/session/models/models.dart';

class SessionPickUp extends SessionMovement {
  const SessionPickUp({
    super.uuid,
    required super.type,
    required super.sessionUuid,
    super.createdAt,
    required this.amount,
  });

  final double amount;

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'amount': amount,
    };
  }

  static SessionPickUp fromJson(Map<String, dynamic> json) {
    return SessionPickUp(
      uuid: json['uuid'],
      type: SessionMovementType.pickUp,
      sessionUuid: json['sessionUuid'],
      createdAt: DateTime.tryParse(json['createdAt']),
      amount: json['amount'],
    );
  }
}
