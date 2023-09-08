part of 'sales_list_bloc.dart';

sealed class SalesListEvent extends Equatable {
  const SalesListEvent();
}

class SalesListRefreshed extends SalesListEvent {
  const SalesListRefreshed({required this.companyUuid});

  final String companyUuid;

  @override
  List<Object?> get props => [];
}
