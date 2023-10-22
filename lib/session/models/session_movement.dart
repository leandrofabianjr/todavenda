import 'package:equatable/equatable.dart';
import 'package:todavenda/commons/commons.dart';

enum SessionMovementType {
  payment,
  supply,
  pickUp,
}

extension SessionMovementTypeX on SessionMovementType {
  String get label => switch (this) {
        SessionMovementType.payment => 'Pagamento',
        SessionMovementType.supply => 'Suprimento',
        SessionMovementType.pickUp => 'Sangria',
      };

  String get value => switch (this) {
        SessionMovementType.payment => 'payment',
        SessionMovementType.supply => 'supply',
        SessionMovementType.pickUp => 'pickUp',
      };

  static SessionMovementType fromValue(String value) => switch (value) {
        'payment' => SessionMovementType.payment,
        'supply' => SessionMovementType.supply,
        'pickUp' => SessionMovementType.pickUp,
        _ => throw Exception('Tipo inválido de movimentação de caixa'),
      };
}

abstract class SessionMovement extends Equatable {
  const SessionMovement({
    this.uuid,
    required this.type,
    required this.sessionUuid,
    required this.createdAt,
  });

  final String? uuid;
  final SessionMovementType type;
  final String sessionUuid;
  final DateTime createdAt;

  Map<String, dynamic> toJson(DateTimeConverterType dateTimeType) {
    return {
      'uuid': uuid,
      'type': type.value,
      'sessionUuid': sessionUuid,
      'createdAt': DateTimeConverter.to(dateTimeType, createdAt),
    };
  }

  @override
  List<Object?> get props => [uuid];
}
