import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:todavenda/commons/commons.dart';
import 'package:todavenda/products/products.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc(this.productRepository) : super(const CartLoading()) {
    on<CartStarted>(_onStarted);
    on<CartItemAdded>(_onItemAdded);
    on<CartItemRemoved>(_onItemRemoved);
    on<CartFinalized>(_onFinalized);
  }

  final ProductRepository productRepository;

  Future<void> _onStarted(
    CartStarted event,
    Emitter<CartState> emit,
  ) async {
    emit(const CartLoading());
    try {
      final products = await productRepository.loadProducts();
      final initialItems = event.initialItems ?? {};
      final items = {
        for (var product in products)
          product:
              initialItems.containsKey(product) ? initialItems[product]! : 0
      };
      emit(CartLoaded(items: items));
    } catch (ex) {
      emit(CartException(ex));
    }
  }

  Future<void> _onFinalized(
    CartFinalized event,
    Emitter<CartState> emit,
  ) async {
    if (state is CartLoaded) {
      final items = (state as CartLoaded).items;
      emit(CartConfirmation(items: Map.from(items)));
    }
  }

  void _onItemAdded(CartItemAdded event, Emitter<CartState> emit) {
    if (state is CartLoaded) {
      final items = (state as CartLoaded).items;
      final itemQuantity = (items[event.product] ?? 0);
      items[event.product] = itemQuantity + 1;
      emit(CartLoaded(items: Map.from(items)));
    }
  }

  void _onItemRemoved(CartItemRemoved event, Emitter<CartState> emit) {
    if (state is CartLoaded) {
      final items = (state as CartLoaded).items;
      final itemQuantity = (items[event.product] ?? 0);
      if (itemQuantity > 0) {
        items[event.product] = itemQuantity - 1;
      }
      emit(CartLoaded(items: Map.from(items)));
    }
  }
}
