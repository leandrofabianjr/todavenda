import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:todavenda/sales/sales.dart';

part 'sales_list_event.dart';
part 'sales_list_state.dart';

class SalesListBloc extends Bloc<SalesListEvent, SalesListState> {
  SalesListBloc(this.salesRepository) : super(const SalesListLoading()) {
    on<SalesListRefreshed>(_onRefreshed);
  }

  final SalesRepository salesRepository;

  _onRefreshed(
    SalesListRefreshed event,
    Emitter<SalesListState> emit,
  ) async {
    emit(const SalesListLoading());
    try {
      final sales = await salesRepository.list();
      sales.sortByCompare(
        (element) => element.createdAt!,
        (a, b) => b.microsecondsSinceEpoch - a.microsecondsSinceEpoch,
      );
      emit(SalesListLoaded(sales: sales));
    } catch (ex) {
      emit(SalesListException(ex));
    }
  }
}
