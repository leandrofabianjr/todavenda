part of 'product_stock_list_bloc.dart';

sealed class ProductStockListEvent extends Equatable {
  const ProductStockListEvent();
}

class ProductStockListStarted extends ProductStockListEvent {
  const ProductStockListStarted();

  @override
  List<Object> get props => [];
}
