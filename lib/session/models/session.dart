import 'package:equatable/equatable.dart';

import 'session_movement.dart';

class Session extends Equatable {
  const Session({
    this.uuid,
    this.currentAmount = 0,
    this.suplyAmount = 0,
    this.pickUpAmount = 0,
    this.movements = const [],
    this.createdAt,
    this.closedAt,
  });

  final String? uuid;
  final double currentAmount;
  final double suplyAmount;
  final double pickUpAmount;
  final List<SessionMovement> movements;
  final DateTime? createdAt;
  final DateTime? closedAt;

  @override
  List<Object?> get props => [uuid];

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'currentAmount': currentAmount,
      'suplyAmount': suplyAmount,
      'pickUpAmount': pickUpAmount,
      'movements': movements.map((m) => m.toJson()).toList(),
      'createdAt': createdAt?.toString(),
      'closedAt': closedAt?.toString(),
    };
  }

  static Session fromJson(Map<String, dynamic> json) {
    return Session(
      uuid: json['uuid'],
      currentAmount: json['currentAmount'],
      suplyAmount: json['suplyAmount'],
      pickUpAmount: json['pickUpAmount'],
      movements: (json['movements'] as List)
          .map((e) => SessionMovement.fromJson(e))
          .toList(),
      closedAt: DateTime.tryParse(json['closedAt']),
    );
  }
}
