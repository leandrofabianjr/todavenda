part of 'sales_list_bloc.dart';

sealed class SalesListEvent extends Equatable {
  const SalesListEvent();
}

class SalesListRefreshed extends SalesListEvent {
  const SalesListRefreshed();

  @override
  List<Object?> get props => [];
}
