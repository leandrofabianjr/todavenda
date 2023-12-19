import 'package:todavenda/commons/commons.dart';
import 'package:todavenda/session/models/models.dart';

class SessionPickUp extends SessionMovement {
  const SessionPickUp({
    required super.uuid,
    required super.sessionUuid,
    required super.createdAt,
    required this.amount,
  }) : super(type: SessionMovementType.pickUp);

  final double amount;

  static SessionPickUp fromJson(
    Map<String, dynamic> json,
    DateTimeConverterType dateTimeType,
  ) =>
      SessionPickUp(
        uuid: json['uuid'],
        sessionUuid: json['sessionUuid'],
        createdAt: DateTimeConverter.parse(dateTimeType, json['createdAt']),
        amount: json['amount'],
      );

  @override
  Map<String, dynamic> toJson(DateTimeConverterType dateTimeType) => {
        ...super.toJson(dateTimeType),
        'amount': amount,
      };
}
