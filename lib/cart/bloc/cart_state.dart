part of 'cart_bloc.dart';

enum CartStatus {
  closedSession,
  initial,
  loading,
  failure,
  checkout,
  payment,
  finalizing,
}

extension CartStatusX on CartStatus {
  bool get isLoading => this == CartStatus.initial;
}

final class CartState extends Equatable {
  const CartState({
    this.status = CartStatus.initial,
    this.session,
    this.items = const {},
    this.exception,
    this.sale,
    this.client,
    this.errorMessage,
  });

  final CartStatus status;
  final Session? session;
  final Map<Product, int> items;
  final Sale? sale;
  final Client? client;
  final String? errorMessage;
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

  Map<Product, int> get selectedItems {
    return {
      for (final item in items.entries)
        if (item.value > 0) item.key: item.value
    };
  }

  CartState copyWith({
    CartStatus? status,
    Session? session,
    Map<Product, int>? items,
    Object? exception,
    Sale? sale,
    Client? client,
    String? errorMessage,
  }) {
    return CartState(
      status: status ?? this.status,
      items: Map.from(items ?? this.items),
      exception: exception ?? this.exception,
      sale: sale ?? this.sale,
      client: client ?? this.client,
      errorMessage: errorMessage,
      session: session ?? this.session,
    );
  }

  @override
  List<Object?> get props => [
        status,
        items.hashCode,
        sale,
        client,
        errorMessage,
        exception,
      ];
}
