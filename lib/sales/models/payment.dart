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
    this.createdAt,
  });

  final String? uuid;
  final PaymentType type;
  final double value;
  final DateTime? createdAt;

  @override
  List<Object?> get props => [uuid];

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'type': type.toString(),
      'value': value,
      'createdAt': createdAt.toString(),
    };
  }
}
