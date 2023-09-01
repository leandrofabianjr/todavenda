part of 'cart_bloc.dart';

enum CartStatus { initial, loading, failure, finalizing }

extension CartStatusX on CartStatus {
  bool get isLoading => this == CartStatus.initial;
}

final class CartState extends Equatable {
  const CartState({
    this.status = CartStatus.initial,
    this.items = const {},
    this.exception,
  });

  final CartStatus status;
  final Map<Product, int> items;

  final Object? exception;

  int get totalQuantity => items.values.fold(0, (total, qtt) => total + qtt);
  bool get isNotEmpty => totalQuantity > 0;
  double get totalPrice => items.entries.fold(
        0,
        (total, item) {
          final unitPrice = item.key.price;
          final quantity = item.value;
          final itemPrice = unitPrice * quantity;
          return total + itemPrice;
        },
      );
  String get formattedTotalPrice => CurrencyFormatter().formatPtBr(totalPrice);
  String get formattedTotalQuantity {
    final qtt = totalQuantity;
    return "$qtt ite${qtt == 1 ? 'm' : 'ns'}";
  }

  CartState copyWith({
    CartStatus? status,
    Map<Product, int>? items,
    Object? exception,
  }) {
    return CartState(
      status: status ?? this.status,
      items: Map.from(items ?? this.items),
      exception: exception ?? this.exception,
    );
  }

  @override
  List<Object> get props => [status, items.hashCode];
}
