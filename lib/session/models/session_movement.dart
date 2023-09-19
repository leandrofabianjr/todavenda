import 'package:equatable/equatable.dart';
import 'package:todavenda/sales/sales.dart';
import 'package:todavenda/session/models/models.dart';

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
    this.createdAt,
  });

  final String? uuid;
  final SessionMovementType type;
  final String sessionUuid;
  final DateTime? createdAt;

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'type': type.value,
      'sessionUuid': sessionUuid,
      'createdAt': createdAt.toString(),
    };
  }

  static SessionMovement fromJson(Map<String, dynamic> json) {
    final type = SessionMovementTypeX.fromValue(json['type']);
    switch (type) {
      case SessionMovementType.payment:
        return Payment.fromJson(json);
      case SessionMovementType.supply:
        return SessionSupply.fromJson(json);
      case SessionMovementType.pickUp:
        return SessionPickUp.fromJson(json);
    }
  }

  @override
  List<Object?> get props => [uuid];
}
