import 'package:todavenda/session/models/models.dart';

class SessionPickUp extends SessionMovement {
  const SessionPickUp({
    super.uuid,
    required super.sessionUuid,
    super.createdAt,
    required this.amount,
  }) : super(type: SessionMovementType.pickUp);

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
      sessionUuid: json['sessionUuid'],
      createdAt: DateTime.tryParse(json['createdAt']),
      amount: json['amount'],
    );
  }
}
