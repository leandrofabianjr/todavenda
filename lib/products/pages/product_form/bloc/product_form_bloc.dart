import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:todavenda/commons/validators.dart';

import '../../../models/product_category.dart';
import '../../../services/products_repository.dart';

part 'product_form_event.dart';
part 'product_form_state.dart';

class ProductFormBloc extends Bloc<ProductFormEvent, ProductFormState> {
  ProductFormBloc(this.productRepository) : super(const ProductFormEditing()) {
    on<ProductFormSubmitted>(_onFormSubmitted);
  }

  final ProductsRepository productRepository;

  void _onFormSubmitted(
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

    emit(ProductFormSubmitting());

    try {
      await productRepository.createProduct(
        description: event.description,
        price: event.price,
        categories: event.categories,
      );
      emit(ProductFormSuccessfullySubmitted());
    } catch (ex) {
      emit(ProductFormException(ex));
    }
  }
}
