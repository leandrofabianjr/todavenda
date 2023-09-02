import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../sales.dart';

part 'sale_event.dart';
part 'sale_state.dart';

class SaleBloc extends Bloc<SaleEvent, SaleState> {
  SaleBloc(this.saleRepository, {required this.uuid}) : super(SaleLoading()) {
    on<SaleStarted>(_onSaleStarted);
  }

  final SalesRepository saleRepository;
  final String uuid;

  Future<void> _onSaleStarted(
    SaleStarted event,
    Emitter<SaleState> emit,
  ) async {
    emit(SaleLoading());
    try {
      final sale = await saleRepository.loadSaleByUuid(uuid);
      emit(SaleLoaded(sale: sale));
    } catch (ex) {
      emit(SaleException(ex));
    }
  }
}
