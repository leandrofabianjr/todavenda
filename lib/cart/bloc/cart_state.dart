part of 'cart_bloc.dart';

sealed class CartState extends Equatable {
  const CartState();
}

final class CartLoading extends CartState {
  const CartLoading();
  @override
  List<Object?> get props => [];
}

final class CartLoaded extends CartState {
  const CartLoaded({required this.items});

  final Map<Product, int> items;
  int get totalQuantity => items.values.reduce((total, qtt) => total + qtt);
  double get totalPrice => items.entries.fold(
        0,
        (total, item) {
          final unitPrice = item.key.price;
          final quantity = item.value;
          final itemPrice = unitPrice * quantity;
          return total + itemPrice;
        },
      );
  get formattedTotalPrice => CurrencyFormatter().formatPtBr(totalPrice);
  get formattedTotalQuantity {
    final qtt = totalQuantity;
    return "$qtt ite${qtt == 1 ? 'm' : 'ns'}";
  }

  @override
  List<Object> get props => [items.hashCode];
}

final class CartConfirmation extends CartLoaded {
  const CartConfirmation({required super.items});
}

final class CartException extends CartState {
  const CartException(this.ex);

  final Object? ex;

  @override
  List<Object?> get props => [ex];
}
