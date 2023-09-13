import 'package:equatable/equatable.dart';
import 'package:todavenda/commons/commons.dart';

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
}

class Payment extends Equatable {
  const Payment({
    this.uuid,
    required this.type,
    required this.value,
    this.createdAt,
  });

  final String? uuid;
  final PaymentType type;
  final double value;
  final DateTime? createdAt;

  String get formattedValue => CurrencyFormatter().formatPtBr(value);

  @override
  List<Object?> get props => [uuid];

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'paymentType': type.value,
      'value': value,
      'createdAt': createdAt.toString(),
    };
  }

  static Payment fromJson(Map<String, dynamic> json) {
    return Payment(
      uuid: json['uuid'],
      type: PaymenTypeX.fromValue(json['paymentType']),
      value: json['value'],
      createdAt: DateTime.tryParse(json['createdAt']),
    );
  }
}
