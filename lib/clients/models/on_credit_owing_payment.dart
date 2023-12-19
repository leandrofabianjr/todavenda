import 'package:todavenda/commons/commons.dart';
import 'package:todavenda/sales/sales.dart';
import 'package:todavenda/session/models/models.dart';

import 'client.dart';

class OnCreditOwingPayment extends SessionMovement {
  const OnCreditOwingPayment({
    required super.uuid,
    required super.type,
    required super.sessionUuid,
    required super.createdAt,
    required this.client,
    required this.amount,
    required this.paymentType,
  });

  final Client client;
  final double amount;
  final PaymentType paymentType;

  String get formattedValue => CurrencyFormatter().formatPtBr(amount);

  static OnCreditOwingPayment fromJson(
    Map<String, dynamic> json,
    DateTimeConverterType dateTimeType,
  ) =>
      OnCreditOwingPayment(
        uuid: json['uuid'],
        type: SessionMovementType.payment,
        sessionUuid: json['sessionUuid'],
        createdAt: DateTimeConverter.parse(dateTimeType, json['createdAt']),
        client: Client.fromJson(json['client']),
        amount: json['amount'],
        paymentType: PaymenTypeX.fromValue(json['paymentType']),
      );

  @override
  Map<String, dynamic> toJson(DateTimeConverterType dateTimeType) => {
        ...super.toJson(dateTimeType),
        'clientUuid': client.uuid,
        'amount': amount,
        'paymentType': paymentType.value,
      };
}
