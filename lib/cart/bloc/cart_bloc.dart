import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:todavenda/commons/commons.dart';
import 'package:todavenda/products/products.dart';
import 'package:todavenda/sales/models/payment.dart';
import 'package:todavenda/sales/sales.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc({required this.productRepository, required this.salesRepository})
      : super(const CartState()) {
    on<CartResumed>(_onResumed);
    on<CartStarted>(_onStarted);
    on<CartItemAdded>(_onItemAdded);
    on<CartItemRemoved>(_onItemRemoved);
    on<CartCheckouted>(_onCheckouted);
    on<CartConfirmed>(_onConfirmed);
  }

  final ProductRepository productRepository;
  final SalesRepository salesRepository;

  Future<void> _onResumed(
    CartResumed event,
    Emitter<CartState> emit,
  ) async {
    emit(state.copyWith());
  }

  Future<void> _onStarted(
    CartStarted event,
    Emitter<CartState> emit,
  ) async {
    try {
      emit(state.copyWith(status: CartStatus.loading));

      final products = await productRepository.loadProducts();
      final initialItems = state.items;
      final items = {
        for (var product in products)
          product:
              initialItems.containsKey(product) ? initialItems[product]! : 0
      };
      emit(state.copyWith(status: CartStatus.initial, items: items));
    } catch (ex) {
      emit(state.copyWith(status: CartStatus.failure, exception: ex));
    }
  }

  Future<void> _onCheckouted(
    CartCheckouted event,
    Emitter<CartState> emit,
  ) async {
    final items = state.items;
    items.removeWhere((key, value) => value < 1);
    emit(state.copyWith(status: CartStatus.checkout, items: items));
  }

  void _onItemAdded(CartItemAdded event, Emitter<CartState> emit) {
    final items = state.items;
    final itemQuantity = (items[event.product] ?? 0);
    items[event.product] = itemQuantity + 1;
    emit(state.copyWith(items: items));
  }

  void _onItemRemoved(CartItemRemoved event, Emitter<CartState> emit) {
    final items = state.items;
    final itemQuantity = (items[event.product] ?? 0);
    if (itemQuantity > 0) {
      items[event.product] = itemQuantity - 1;
    }
    emit(state.copyWith(items: items));
  }

  Future<void> _onConfirmed(
    CartConfirmed event,
    Emitter<CartState> emit,
  ) async {
    try {
      emit(state.copyWith(status: CartStatus.loading));
      final sale = await salesRepository.createSale(items: state.items);
      emit(state.copyWith(status: CartStatus.payment, sale: sale));
    } catch (ex) {
      emit(state.copyWith(status: CartStatus.failure, exception: ex));
    }
  }
}
