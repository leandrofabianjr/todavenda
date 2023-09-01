import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:todavenda/commons/commons.dart';
import 'package:todavenda/products/products.dart';
import 'package:todavenda/sales/models/models.dart';
import 'package:todavenda/sales/services/sales_repository.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc({required this.productRepository, required this.salesRepository})
      : super(const CartLoading()) {
    on<CartStarted>(_onStarted);
    on<CartItemAdded>(_onItemAdded);
    on<CartItemRemoved>(_onItemRemoved);
    on<CartCheckouted>(_onCheckouted);
    on<CartConfirmed>(_onConfirmed);
  }

  final ProductRepository productRepository;
  final SalesRepository salesRepository;

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

  Future<void> _onCheckouted(
    CartCheckouted event,
    Emitter<CartState> emit,
  ) async {
    if (state is CartLoaded) {
      final items = (state as CartLoaded).items;
      emit(CartCheckout(items: Map.from(items)));
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

  Future<void> _onConfirmed(
    CartConfirmed event,
    Emitter<CartState> emit,
  ) async {
    if (state is CartCheckout) {
      try {
        final items = (state as CartCheckout).items;
        emit(const CartSaleCreation());
        final sale = await salesRepository.createSale(items: items);
        emit(CartSaleConfirmation(sale));
      } catch (ex) {
        emit(CartException(ex));
      }
    }
  }
}
