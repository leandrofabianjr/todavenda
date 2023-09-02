part of 'sales_list_bloc.dart';

sealed class SalesListState extends Equatable {
  const SalesListState();
}

final class SalesListLoading extends SalesListState {
  const SalesListLoading();

  @override
  List<Object> get props => [];
}

final class SalesListLoaded extends SalesListState {
  const SalesListLoaded({required this.sales});

  final List<Sale> sales;

  @override
  List<Object> get props => [sales.hashCode];
}

final class SalesListException extends SalesListState {
  const SalesListException(this.ex);

  final Object? ex;

  @override
  List<Object?> get props => [ex];
}
