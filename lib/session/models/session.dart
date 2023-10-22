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

  double get closingDifference => (closingAmount ?? 0) - currentAmount;

  String get formattedCurrentAmount =>
      CurrencyFormatter().formatPtBr(currentAmount);

  String get formattedSupplyAmount =>
      CurrencyFormatter().formatPtBr(supplyAmount);

  String get formattedPickUpAmount =>
      CurrencyFormatter().formatPtBr(pickUpAmount);

  String get formattedCreatedAt => DateTimeFormatter.shortDateTime(createdAt);

  String get formattedClosingAmount =>
      CurrencyFormatter().formatPtBr(closingAmount ?? 0);

  String get formattedOpeningAmount =>
      CurrencyFormatter().formatPtBr(openingAmount);

  String get formattedClosingDifference =>
      CurrencyFormatter().formatPtBr(closingDifference);

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

  Map<String, dynamic> toJson(DateTimeConverterType dateTimeType) => {
        'uuid': uuid,
        'openingAmount': openingAmount,
        'closingAmount': closingAmount,
        'currentAmount': currentAmount,
        'supplyAmount': supplyAmount,
        'pickUpAmount': pickUpAmount,
        'createdAt': DateTimeConverter.to(dateTimeType, createdAt),
        'closedAt': DateTimeConverter.to(dateTimeType, closedAt),
      };

  static Session fromJson(
    Map<String, dynamic> json,
    DateTimeConverterType dateTimeType,
  ) =>
      Session(
        uuid: json['uuid'],
        currentAmount: double.tryParse(json['currentAmount'].toString()) ?? 0,
        supplyAmount: double.tryParse(json['supplyAmount'].toString()) ?? 0,
        pickUpAmount: double.tryParse(json['pickUpAmount'].toString()) ?? 0,
        closingAmount: double.tryParse(json['closingAmount'].toString()) ?? 0,
        createdAt: DateTimeConverter.parse(dateTimeType, json['createdAt']),
        closedAt: DateTimeConverter.tryParse(dateTimeType, json['closedAt']),
      );
}
