import 'package:equatable/equatable.dart';
import 'package:todavenda/commons/commons.dart';

class Session extends Equatable {
  const Session({
    required this.uuid,
    this.openingAmount = 0,
    this.closingAmount,
    this.currentAmount = 0,
    this.supplyAmount = 0,
    this.pickUpAmount = 0,
    this.createdAt,
    this.closedAt,
  });

  final String uuid;
  final double openingAmount;
  final double? closingAmount;
  final double currentAmount;
  final double supplyAmount;
  final double pickUpAmount;
  final DateTime? createdAt;
  final DateTime? closedAt;

  @override
  List<Object?> get props => [uuid];

  String get formattedCurrentAmount =>
      CurrencyFormatter().formatPtBr(currentAmount);

  String get formattedSupplyAmount =>
      CurrencyFormatter().formatPtBr(supplyAmount);

  String get formattedPickUpAmount =>
      CurrencyFormatter().formatPtBr(pickUpAmount);

  String get formattedCreatedAt => DateTimeFormatter.shortDateTime(createdAt);

  Session copyWith({
    final String? uuid,
    final double? currentAmount,
    final double? supplyAmount,
    final double? pickUpAmount,
    final double? closingAmount,
    final DateTime? createdAt,
    final DateTime? closedAt,
  }) {
    return Session(
      uuid: uuid ?? this.uuid,
      currentAmount: currentAmount ?? this.currentAmount,
      supplyAmount: supplyAmount ?? this.supplyAmount,
      pickUpAmount: pickUpAmount ?? this.pickUpAmount,
      closingAmount: closingAmount ?? this.closingAmount,
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
      'closingAmount': closingAmount,
      'createdAt': createdAt?.toString(),
      'closedAt': closedAt?.toString(),
    };
  }

  static Session fromJson(Map<String, dynamic> json) {
    return Session(
      uuid: json['uuid'],
      currentAmount: double.tryParse(json['currentAmount'].toString()) ?? 0,
      supplyAmount: double.tryParse(json['supplyAmount'].toString()) ?? 0,
      pickUpAmount: double.tryParse(json['pickUpAmount'].toString()) ?? 0,
      closingAmount: double.tryParse(json['closingAmount'].toString()) ?? 0,
      createdAt: DateTime.tryParse(json['createdAt'] ?? ''),
      closedAt: DateTime.tryParse(json['closedAt'] ?? ''),
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

  afterCashPayment(double amount) {
    return copyWith(
      currentAmount: currentAmount + amount,
    );
  }
}
