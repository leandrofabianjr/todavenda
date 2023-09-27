part of 'sale_bloc.dart';

sealed class SaleEvent extends Equatable {
  const SaleEvent();
}

class SaleStarted extends SaleEvent {
  const SaleStarted();

  @override
  List<Object> get props => [];
}

class SaleRemoved extends SaleEvent {
  const SaleRemoved({required this.sale});

  final Sale sale;

  @override
  List<Object> get props => [sale];
}
