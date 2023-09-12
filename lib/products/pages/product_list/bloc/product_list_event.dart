part of 'product_list_bloc.dart';

sealed class ProductListEvent extends Equatable {
  const ProductListEvent();
}

class ProductListStarted extends ProductListEvent {
  const ProductListStarted();

  @override
  List<Object> get props => [];
}
