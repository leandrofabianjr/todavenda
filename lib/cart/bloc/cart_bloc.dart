import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:todavenda/clients/clients.dart';
import 'package:todavenda/commons/commons.dart';
import 'package:todavenda/products/products.dart';
import 'package:todavenda/sales/sales.dart';
import 'package:todavenda/session/models/models.dart';
import 'package:todavenda/session/services/sessions_repository.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends HydratedBloc<CartEvent, CartState> {
  CartBloc({
    required this.sessionsRepository,
    required this.productRepository,
    required this.salesRepository,
  }) : super(const CartState()) {
    on<CartResumed>(_onResumed);
    on<CartRestarted>(_onStarted);
    on<CartRefreshed>(_onRefreshed);
    on<CartItemAdded>(_onItemAdded);
    on<CartItemRemoved>(_onItemRemoved);
    on<CartClientChanged>(_onClientChanged);
    on<CartCheckouted>(_onCheckouted);
    on<CartConfirmed>(_onConfirmed);
    on<CartPaymentAdded>(_onPaymentAdded);
    on<CartPaymentRemoved>(_onPaymentRemoved);
    on<CartPaymentsFinalized>(_onPaymentsFinalized);
    on<CartCleaned>(_onCleaned);
    on<CartSaleRemoved>(_onSaleRemoved);
  }

  final SessionsRepository sessionsRepository;
  final ProductsRepository productRepository;
  final SalesRepository salesRepository;

  Future<void> _onResumed(
    CartResumed event,
    Emitter<CartState> emit,
  ) async {
    emit(state.copyWith());
  }

  Future<void> _onStarted(
    CartRestarted event,
    Emitter<CartState> emit,
  ) async {
    emit(state.copyWith(status: CartStatus.initial));
  }

  Future<void> _onRefreshed(
    CartRefreshed event,
    Emitter<CartState> emit,
  ) async {
    try {
      final previousStatus = state.status == CartStatus.loading
          ? CartStatus.initial
          : state.status;

      emit(state.copyWith(status: CartStatus.loading));

      final session = await sessionsRepository.current;
      if (session == null) {
        return emit(state.copyWith(status: CartStatus.closedSession));
      }

      final products =
          await productRepository.loadProducts(term: event.filterterm);

      emit(state.copyWith(
        status: previousStatus,
        products: products,
        session: session,
        filterTerm: event.filterterm ?? '',
      ));
    } catch (ex) {
      emit(state.copyWith(status: CartStatus.failure, exception: ex));
    }
  }

  Future<void> _onCheckouted(
    CartCheckouted event,
    Emitter<CartState> emit,
  ) async {
    emit(state.copyWith(status: CartStatus.checkout));
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
    if (items[event.product] == 0 && items.containsKey(event.product)) {
      items.remove(event.product);
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
        session: state.session!,
        items: state.items,
        client: state.client,
      );
      await _updateStockOfItems(state.items);

      emit(state.copyWith(status: CartStatus.payment, sale: sale));
    } catch (ex) {
      emit(state.copyWith(status: CartStatus.failure, exception: ex));
    }
  }

  Future<void> _onPaymentAdded(
    CartPaymentAdded event,
    Emitter<CartState> emit,
  ) async {
    try {
      emit(state.copyWith(status: CartStatus.loading));
      final sale = await salesRepository.addPayment(
        sale: state.sale!,
        type: event.type,
        amount: event.value,
      );
      emit(state.copyWith(status: CartStatus.payment, sale: sale));
    } catch (ex) {
      emit(state.copyWith(status: CartStatus.failure, exception: ex));
    }
  }

  Future<void> _onPaymentRemoved(
    CartPaymentRemoved event,
    Emitter<CartState> emit,
  ) async {
    try {
      emit(state.copyWith(status: CartStatus.loading));
      final sale = await salesRepository.removePayment(
        sale: state.sale!,
        payment: event.payment,
      );
      emit(state.copyWith(status: CartStatus.payment, sale: sale));
    } catch (ex) {
      emit(state.copyWith(status: CartStatus.failure, exception: ex));
    }
  }

  void _onPaymentsFinalized(
    CartPaymentsFinalized event,
    Emitter<CartState> emit,
  ) {
    if (state.sale!.isFullyPaid) {
      emit(state.copyWith(status: CartStatus.finalizing));
    } else {
      emit(state.copyWith(
        status: CartStatus.payment,
        errorMessage: 'A venda ainda não foi totalmente paga',
      ));
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
        await salesRepository.remove(state.sale!);
        final items = {for (var e in state.sale!.items) e.product: e.quantity};
        await _updateStockOfItems(items);

        emit(state.copyWith(status: CartStatus.checkout));
      }
    } catch (ex) {
      emit(state.copyWith(status: CartStatus.failure, exception: ex));
    }
  }

  Future<void> _updateStockOfItems(Map<Product, int> items) async {
    for (final item in items.entries) {
      await productRepository.updateStock(
        product: item.key,
        quantity: -item.value,
      );
    }
  }

  @override
  CartState? fromJson(Map<String, dynamic> json) {
    try {
      if (kDebugMode) print('======= Recuperando:\n$json');
      return json.isEmpty ? null : CartState.fromJson(json);
    } catch (e) {
      if (kDebugMode) print('Erro: $e');
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(CartState state) {
    try {
      final json = state.toJson();
      if (kDebugMode) {
        print('======= Salvando:\n$json');
      }
      return json;
    } catch (e) {
      if (kDebugMode) print('Erro: $e');
      return null;
    }
  }
}
