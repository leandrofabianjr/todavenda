import 'package:flutter/material.dart';
import 'package:todavenda/commons/commons.dart';
import 'package:todavenda/session/models/models.dart';

enum PaymentType {
  cash,
  pix,
  credit,
  debit,
}

extension PaymenTypeX on PaymentType {
  String get label => switch (this) {
        PaymentType.cash => 'Dinheiro',
        PaymentType.pix => 'PIX',
        PaymentType.credit => 'Crédito',
        PaymentType.debit => 'Débito',
      };

  String get value => switch (this) {
        PaymentType.cash => 'cash',
        PaymentType.pix => 'pix',
        PaymentType.credit => 'credit',
        PaymentType.debit => 'debit',
      };

  static PaymentType fromValue(String value) => switch (value) {
        'cash' => PaymentType.cash,
        'pix' => PaymentType.pix,
        'credit' => PaymentType.credit,
        'debit' => PaymentType.debit,
        _ => PaymentType.cash,
      };

  Widget get icon => switch (this) {
        PaymentType.cash => const Icon(Icons.money),
        PaymentType.credit => const Icon(Icons.credit_card),
        PaymentType.debit => const Icon(Icons.credit_card),
        PaymentType.pix => const Icon(Icons.pix),
      };
}

class Payment extends SessionMovement {
  const Payment({
    super.uuid,
    required super.type,
    required super.sessionUuid,
    required super.createdAt,
    required this.saleUuid,
    required this.paymentType,
    required this.amount,
  });

  final String saleUuid;
  final PaymentType paymentType;
  final double amount;

  String get formattedValue => CurrencyFormatter().formatPtBr(amount);

  static Payment fromJson(
    Map<String, dynamic> json,
    DateTimeConverterType dateTimeType,
  ) =>
      Payment(
        uuid: json['uuid'],
        type: SessionMovementType.payment,
        sessionUuid: json['sessionUuid'],
        createdAt: DateTimeConverter.parse(dateTimeType, json['createdAt']),
        saleUuid: json['saleUuid'],
        paymentType: PaymenTypeX.fromValue(json['paymentType']),
        amount: json['amount'],
      );

  @override
  Map<String, dynamic> toJson(DateTimeConverterType dateTimeType) => {
        ...super.toJson(dateTimeType),
        'saleUuid': saleUuid,
        'paymentType': paymentType.value,
        'amount': amount,
      };
}
