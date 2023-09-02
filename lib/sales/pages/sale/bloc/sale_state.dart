part of 'sale_bloc.dart';

sealed class SaleState extends Equatable {
  const SaleState();
}

final class SaleLoading extends SaleState {
  @override
  List<Object> get props => [];
}

final class SaleLoaded extends SaleState {
  const SaleLoaded({required this.sale});

  final Sale sale;

  @override
  List<Object> get props => [sale];
}

final class SaleException extends SaleState {
  const SaleException(this.ex);

  final Object? ex;
  @override
  List<Object?> get props => [ex];
}
