part of 'cart_bloc.dart';

sealed class CartEvent extends Equatable {
  const CartEvent();
}

final class CartStarted extends CartEvent {
  const CartStarted();

  @override
  List<Object?> get props => [];
}

final class CartResumed extends CartEvent {
  const CartResumed();

  @override
  List<Object?> get props => [];
}

final class CartItemAdded extends CartEvent {
  const CartItemAdded({required this.product});

  final Product product;

  @override
  List<Object> get props => [];
}

final class CartItemRemoved extends CartEvent {
  const CartItemRemoved({required this.product});

  final Product product;

  @override
  List<Object> get props => [];
}

final class CartCheckClicked extends CartEvent {
  const CartCheckClicked();

  @override
  List<Object> get props => [];
}

final class CartCheckouted extends CartEvent {
  const CartCheckouted();

  @override
  List<Object> get props => [];
}

final class CartConfirmed extends CartEvent {
  const CartConfirmed();

  @override
  List<Object> get props => [];
}

final class CartPaid extends CartEvent {
  const CartPaid({required this.type, required this.value});

  final PaymentType type;
  final double value;

  @override
  List<Object> get props => [type, value];
}

final class CartCleaned extends CartEvent {
  const CartCleaned();

  @override
  List<Object?> get props => [];
}
