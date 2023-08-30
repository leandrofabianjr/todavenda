part of 'product_bloc.dart';

sealed class ProductEvent extends Equatable {
  const ProductEvent();
}

class ProductStarted extends ProductEvent {
  const ProductStarted();

  @override
  List<Object> get props => [];
}
