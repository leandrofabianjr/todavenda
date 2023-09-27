import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../sales.dart';

part 'sale_event.dart';
part 'sale_state.dart';

class SaleBloc extends Bloc<SaleEvent, SaleState> {
  SaleBloc(this.salesRepository, {required this.uuid}) : super(SaleLoading()) {
    on<SaleStarted>(_onStarted);
    on<SaleRemoved>(_onRemoved);
  }

  final SalesRepository salesRepository;
  final String uuid;

  Future<void> _onStarted(
    SaleStarted event,
    Emitter<SaleState> emit,
  ) async {
    emit(SaleLoading());
    try {
      final sale = await salesRepository.loadSaleByUuid(uuid);
      emit(SaleLoaded(sale: sale));
    } catch (ex) {
      emit(SaleException(ex));
    }
  }

  Future<void> _onRemoved(
    SaleRemoved event,
    Emitter<SaleState> emit,
  ) async {
    try {
      emit(SaleLoading());
      await salesRepository.remove(event.sale);
      emit(SaleRemoveSuccess());
    } catch (ex) {
      emit(SaleException(ex));
    }
  }
}
