import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:todavenda/commons/validators.dart';
import 'package:todavenda/products/products.dart';

part 'product_stock_form_event.dart';
part 'product_stock_form_state.dart';

class ProductStockFormBloc
    extends Bloc<ProductStockFormEvent, ProductStockFormState> {
  ProductStockFormBloc({
    required this.productRepository,
    required this.productUuid,
  }) : super(const ProductStockFormState()) {
    on<ProductStockFormStarted>(_onStarted);
    on<ProductStockFormSubmitted>(_onSubmitted);
  }

  final ProductsRepository productRepository;
  final String productUuid;

  Future<void> _onStarted(
    ProductStockFormStarted event,
    Emitter<ProductStockFormState> emit,
  ) async {
    try {
      final product = await productRepository.loadProductByUuid(productUuid);
      final repository = productRepository.stockRepository(product);
      emit(state.copyWith(
        status: ProductStockFormStatus.editing,
        createdAt: DateTime.now(),
        repository: repository,
        product: product,
      ));
    } catch (ex) {
      emit(state.copyWith(
        status: ProductStockFormStatus.exception,
        exception: ex,
      ));
    }
  }

  void _onSubmitted(
    ProductStockFormSubmitted event,
    Emitter<ProductStockFormState> emit,
  ) async {
    final quantityError = Validators.greaterThanZero(event.quantity);

    if (quantityError != null) {
      return emit(
        state.copyWith(
            status: ProductStockFormStatus.editing,
            quantityError: quantityError),
      );
    }

    emit(state.copyWith(status: ProductStockFormStatus.loading));

    try {
      await state.repository!.save(
        quantity: event.quantity!,
        createdAt: event.createdAt!,
        observation: event.observation,
      );
      final product = await productRepository.updateStock(
        product: state.product!,
        quantity: event.quantity!,
      );
      emit(state.copyWith(
        status: ProductStockFormStatus.success,
        product: product,
      ));
    } catch (ex) {
      emit(state.copyWith(
        status: ProductStockFormStatus.exception,
        exception: ex,
      ));
    }
  }
}
