import 'package:equatable/equatable.dart';
import 'package:todavenda/commons/commons.dart';

enum PaymentType {
  cash,
  pix,
  credit,
  debit,
}

extension PaymentYpeX on PaymentType {
  String get label => switch (this) {
        PaymentType.cash => 'Dinheiro',
        PaymentType.pix => 'PIX',
        PaymentType.credit => 'Crédito',
        PaymentType.debit => 'Débito',
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

  @override
  List<Object?> get props => [uuid];

  String get formattedValue => CurrencyFormatter().formatPtBr(value);

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'type': type.toString(),
      'value': value,
      'createdAt': createdAt.toString(),
    };
  }
}
