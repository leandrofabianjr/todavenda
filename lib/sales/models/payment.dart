import 'package:equatable/equatable.dart';

enum PaymentType {
  cash,
  pix,
  credit,
  debit,
}

class Payment extends Equatable {
  const Payment({
    this.uuid,
    required this.type,
    required this.value,
  });

  final String? uuid;
  final PaymentType type;
  final double value;

  @override
  List<Object?> get props => [uuid];
}
