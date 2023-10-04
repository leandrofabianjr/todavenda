import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:todavenda/products/products.dart';

part 'product_stock_list_event.dart';
part 'product_stock_list_state.dart';

class ProductStockListBloc
    extends Bloc<ProductStockListEvent, ProductStockListState> {
  ProductStockListBloc(this.productStockRepository)
      : super(ProductStockListLoading()) {
    on<ProductStockListStarted>(_onStarted);
  }

  final ProductStockRepository productStockRepository;

  Future<void> _onStarted(
    ProductStockListStarted event,
    Emitter<ProductStockListState> emit,
  ) async {
    emit(ProductStockListLoading());
    try {
      final productStockList = await productStockRepository.load();
      emit(ProductStockListLoaded(productStockList));
    } catch (ex) {
      emit(ProductStockListException(ex));
    }
  }
}
