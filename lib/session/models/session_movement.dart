import 'package:equatable/equatable.dart';
import 'package:todavenda/commons/commons.dart';

enum SessionMovementType {
  payment,
  supply,
  pickUp,
  onCreditOwingPayment,
}

extension SessionMovementTypeX on SessionMovementType {
  String get label => switch (this) {
        SessionMovementType.payment => 'Pagamento',
        SessionMovementType.supply => 'Suprimento',
        SessionMovementType.pickUp => 'Sangria',
        SessionMovementType.onCreditOwingPayment => 'Pagamento de venda fiada',
      };

  static SessionMovementType fromName(String value) =>
      SessionMovementType.values.firstWhere((element) => element.name == value);
}

abstract class SessionMovement extends Equatable {
  const SessionMovement({
    required this.uuid,
    required this.type,
    required this.sessionUuid,
    required this.createdAt,
  });

  final String uuid;
  final SessionMovementType type;
  final String sessionUuid;
  final DateTime createdAt;

  Map<String, dynamic> toJson(DateTimeConverterType dateTimeType) {
    return {
      'uuid': uuid,
      'type': type.name,
      'sessionUuid': sessionUuid,
      'createdAt': DateTimeConverter.to(dateTimeType, createdAt),
    };
  }

  @override
  List<Object?> get props => [uuid];
}
