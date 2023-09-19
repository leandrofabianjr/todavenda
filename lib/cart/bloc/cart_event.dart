part of 'cart_bloc.dart';

sealed class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

final class CartStarted extends CartEvent {
  const CartStarted();
}

final class CartResumed extends CartEvent {
  const CartResumed();
}

final class CartItemAdded extends CartEvent {
  const CartItemAdded({required this.product});

  final Product product;

  @override
  List<Object> get props => [product];
}

final class CartItemRemoved extends CartEvent {
  const CartItemRemoved({required this.product});

  final Product product;

  @override
  List<Object> get props => [product];
}

final class CartClientChanged extends CartEvent {
  const CartClientChanged({this.client});

  final Client? client;

  @override
  List<Object?> get props => [client];
}

final class CartCheckClicked extends CartEvent {
  const CartCheckClicked();
}

final class CartCheckouted extends CartEvent {
  const CartCheckouted();
}

final class CartConfirmed extends CartEvent {
  const CartConfirmed();
}

final class CartPaymentAdded extends CartEvent {
  const CartPaymentAdded({
    required this.type,
    required this.value,
  });
  final PaymentType type;
  final double value;

  @override
  List<Object> get props => [type, value];
}

final class CartPaymentRemoved extends CartEvent {
  const CartPaymentRemoved({required this.payment});

  final Payment payment;

  @override
  List<Object> get props => [payment];
}

final class CartPaymentsFinalized extends CartEvent {
  const CartPaymentsFinalized();
}

final class CartCleaned extends CartEvent {
  const CartCleaned();
}

final class CartSaleRemoved extends CartEvent {
  const CartSaleRemoved();
}
