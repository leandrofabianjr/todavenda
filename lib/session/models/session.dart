import 'package:equatable/equatable.dart';

class Session extends Equatable {
  const Session({
    required this.uuid,
    this.currentAmount = 0,
    this.supplyAmount = 0,
    this.pickUpAmount = 0,
    this.createdAt,
    this.closedAt,
  });

  final String uuid;
  final double currentAmount;
  final double supplyAmount;
  final double pickUpAmount;
  final DateTime? createdAt;
  final DateTime? closedAt;

  @override
  List<Object?> get props => [uuid];

  Session copyWith({
    final String? uuid,
    final double? currentAmount,
    final double? supplyAmount,
    final double? pickUpAmount,
    final DateTime? createdAt,
    final DateTime? closedAt,
  }) {
    return Session(
      uuid: uuid ?? this.uuid,
      currentAmount: currentAmount ?? this.currentAmount,
      supplyAmount: supplyAmount ?? this.supplyAmount,
      pickUpAmount: pickUpAmount ?? this.pickUpAmount,
      createdAt: createdAt ?? this.createdAt,
      closedAt: closedAt ?? this.closedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'currentAmount': currentAmount,
      'supplyAmount': supplyAmount,
      'pickUpAmount': pickUpAmount,
      'createdAt': createdAt?.toString(),
      'closedAt': closedAt?.toString(),
    };
  }

  static Session fromJson(Map<String, dynamic> json) {
    return Session(
      uuid: json['uuid'],
      currentAmount: json['currentAmount'],
      supplyAmount: json['supplyAmount'],
      pickUpAmount: json['pickUpAmount'],
      closedAt: DateTime.tryParse(json['closedAt']),
    );
  }

  afterPickUp(double amount) {
    return copyWith(
      pickUpAmount: pickUpAmount + amount,
      currentAmount: currentAmount - amount,
    );
  }

  afterSupply(double amount) {
    return copyWith(
      supplyAmount: supplyAmount + amount,
      currentAmount: currentAmount + amount,
    );
  }
}
