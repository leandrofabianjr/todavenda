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
  static fromName(String name) {
    return CartStatus.values.firstWhere((s) => s.name == name);
  }
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
    this.filterTerm,
    this.products = const [],
  });

  final CartStatus status;
  final Session? session;
  final List<Product> products;
  final Map<Product, int> items;
  final Sale? sale;
  final Client? client;
  final String? errorMessage;
  final Object? exception;
  final String? filterTerm;

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
    Session? session,
    Map<Product, int>? items,
    Object? exception,
    Sale? sale,
    Client? client,
    String? errorMessage,
    String? filterTerm,
    List<Product>? products,
  }) {
    return CartState(
      status: status ?? this.status,
      items: Map.from(items ?? this.items),
      exception: exception ?? this.exception,
      sale: sale ?? this.sale,
      client: client ?? this.client,
      errorMessage: errorMessage,
      session: session ?? this.session,
      filterTerm: filterTerm ?? this.filterTerm,
      products: products ?? this.products,
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
        filterTerm,
      ];

  static CartState fromJson(Map<String, dynamic> json) {
    final selectedProducts = (json['selectedProducts'] as List)
        .map((e) => Product.fromJson(e, DateTimeConverterType.string))
        .toList();

    ((json['sale']?['items'] ?? []) as List).forEachIndexed((index, element) {
      if ((element as Map).containsKey('productUuid')) {
        final uuid = element['productUuid'];
        final product = selectedProducts.firstWhere((p) => p.uuid == uuid);
        element['product'] = product.toJson(DateTimeConverterType.string);
        json['sale']['items'][index] = element;
      }
    });

    return CartState(
      status: CartStatusX.fromName(json['status']),
      session: Session.fromJson(json['session'], DateTimeConverterType.string),
      items: (json['items'] as Map).map(
        (key, value) => MapEntry<Product, int>(
          selectedProducts.firstWhere((p) => p.uuid == key),
          value,
        ),
      ),
      sale: json['sale'] != null
          ? Sale.fromJson(json['sale'], DateTimeConverterType.string)
          : null,
      client: json['client'] != null ? Client.fromJson(json['client']) : null,
      filterTerm: json['filterTerm'],
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status.name,
        'session': session?.toJson(DateTimeConverterType.string),
        'items': items.map(
          (key, value) => MapEntry<String, int>(key.uuid, value),
        ),
        'selectedProducts': items.keys
            .map((e) => e.toJson(DateTimeConverterType.string))
            .toList(),
        'sale': sale?.toJson(),
        'client': client?.toJson(),
        'filterTerm': filterTerm,
      };
}
