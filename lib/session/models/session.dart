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
    required this.createdAt,
    this.closedAt,
  });

  final String uuid;
  final double openingAmount;
  final double? closingAmount;
  final double currentAmount;
  final double supplyAmount;
  final double pickUpAmount;
  final DateTime createdAt;
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
    final double? openingAmount,
    final double? closingAmount,
    final double? currentAmount,
    final double? supplyAmount,
    final double? pickUpAmount,
    final DateTime? createdAt,
    final DateTime? closedAt,
  }) {
    return Session(
      uuid: uuid ?? this.uuid,
      openingAmount: openingAmount ?? this.openingAmount,
      closingAmount: closingAmount ?? this.closingAmount,
      currentAmount: currentAmount ?? this.currentAmount,
      supplyAmount: supplyAmount ?? this.supplyAmount,
      pickUpAmount: pickUpAmount ?? this.pickUpAmount,
      createdAt: createdAt ?? this.createdAt,
      closedAt: closedAt ?? this.closedAt,
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
