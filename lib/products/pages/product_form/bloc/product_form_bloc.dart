import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:todavenda/commons/validators.dart';
import 'package:todavenda/products/models/models.dart';

import '../../../models/product_category.dart';
import '../../../services/products_repository.dart';

part 'product_form_event.dart';
part 'product_form_state.dart';

class ProductFormBloc extends Bloc<ProductFormEvent, ProductFormState> {
  ProductFormBloc(this.productRepository, {this.uuid})
      : super(const ProductFormLoading()) {
    on<ProductFormStarted>(_onStarted);
    on<ProductFormSubmitted>(_onSubmitted);
  }

  final ProductsRepository productRepository;
  final String? uuid;

  Future<void> _onStarted(
    ProductFormStarted event,
    Emitter<ProductFormState> emit,
  ) async {
    if (event.uuid == null) {
      return emit(const ProductFormEditing());
    }

    try {
      final product = await productRepository.loadProductByUuid(event.uuid!);
      emit(ProductFormEditing(
        uuid: product.uuid,
        description: product.description,
        price: product.price,
        categories: product.categories ?? [],
        currentStock: product.currentStock,
      ));
    } catch (ex) {
      emit(ProductFormException(ex));
    }
  }

  void _onSubmitted(
    ProductFormSubmitted event,
    Emitter<ProductFormState> emit,
  ) async {
    final descriptionError = Validators.stringNotEmpty(event.description);

    if (descriptionError != null) {
      return emit(
        (state as ProductFormEditing).copyWith(
          descriptionError: descriptionError,
        ),
      );
    }

    emit(const ProductFormLoading());

    try {
      await productRepository.saveProduct(
        uuid: event.uuid,
        description: event.description,
        price: event.price,
        categories: event.categories,
        currentStock: event.currentStock,
      );
      emit(ProductFormSuccessfullySubmitted());
    } catch (ex) {
      emit(ProductFormException(ex));
    }
  }
}
