import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:todavenda/clients/clients.dart';
import 'package:todavenda/commons/commons.dart';
import 'package:todavenda/products/products.dart';
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
    on<CartClientChanged>(_onClientChanged);
    on<CartCheckouted>(_onCheckouted);
    on<CartConfirmed>(_onConfirmed);
    on<CartPaid>(_onPaid);
    on<CartCleaned>(_onCleaned);
    on<CartSaleRemoved>(_onSaleRemoved);
  }

  final ProductsRepository productRepository;
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
    final items = state.selectedItems;
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

  void _onClientChanged(CartClientChanged event, Emitter<CartState> emit) {
    emit(state.copyWith(client: event.client));
  }

  Future<void> _onConfirmed(
    CartConfirmed event,
    Emitter<CartState> emit,
  ) async {
    try {
      emit(state.copyWith(status: CartStatus.loading));

      final sale = await salesRepository.createSale(
        items: state.selectedItems,
        client: state.client,
      );
      emit(state.copyWith(status: CartStatus.payment, sale: sale));
    } catch (ex) {
      emit(state.copyWith(status: CartStatus.failure, exception: ex));
    }
  }

  Future<void> _onPaid(
    CartPaid event,
    Emitter<CartState> emit,
  ) async {
    try {
      emit(state.copyWith(status: CartStatus.loading));
      final sale = await salesRepository.newPayment(
        sale: state.sale!,
        type: event.type,
        value: event.value,
      );
      if (sale.isFullyPaid) {
        emit(state.copyWith(status: CartStatus.finalizing, sale: sale));
      } else {
        emit(state.copyWith(status: CartStatus.payment, sale: sale));
      }
    } catch (ex) {
      emit(state.copyWith(status: CartStatus.failure, exception: ex));
    }
  }

  Future<void> _onCleaned(
    CartCleaned event,
    Emitter<CartState> emit,
  ) async {
    emit(const CartState());
  }

  Future<void> _onSaleRemoved(
    CartSaleRemoved event,
    Emitter<CartState> emit,
  ) async {
    try {
      emit(state.copyWith(status: CartStatus.loading));
      if (state.sale!.calculateAmountPaid() > 0) {
        emit(state.copyWith(
          status: CartStatus.payment,
          errorMessage: 'A venda já recebeu pagamentos e não pode ser excluída',
        ));
      } else {
        await salesRepository.removeSale(state.sale!.uuid!);
        emit(state.copyWith(status: CartStatus.checkout));
      }
    } catch (ex) {
      emit(state.copyWith(status: CartStatus.failure, exception: ex));
    }
  }
}
