import 'package:todavenda/session/models/models.dart';

class SessionSupply extends SessionMovement {
  const SessionSupply({
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

  static SessionSupply fromJson(Map<String, dynamic> json) {
    return SessionSupply(
      uuid: json['uuid'],
      type: SessionMovementType.supply,
      sessionUuid: json['sessionUuid'],
      createdAt: DateTime.tryParse(json['createdAt']),
      amount: json['amount'],
    );
  }
}
