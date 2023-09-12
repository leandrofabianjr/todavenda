import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:todavenda/commons/validators.dart';

import '../../../services/product_categories_repository.dart';

part 'product_category_form_event.dart';
part 'product_category_form_state.dart';

class ProductCategoryFormBloc
    extends Bloc<ProductCategoryFormEvent, ProductCategoryFormState> {
  ProductCategoryFormBloc(this.productCategoriesRepository)
      : super(const ProductCategoryFormEditing()) {
    on<ProductCategoryFormSubmitted>(_onFormSubmitted);
  }

  final ProductCategoriesRepository productCategoriesRepository;

  void _onFormSubmitted(
    ProductCategoryFormSubmitted event,
    Emitter<ProductCategoryFormState> emit,
  ) async {
    final nameError = Validators.stringNotEmpty(event.name);

    if (nameError != null) {
      return emit(
        (state as ProductCategoryFormEditing).copyWith(
          nameError: nameError,
        ),
      );
    }

    emit(ProductCategoryFormSubmitting());

    try {
      await productCategoriesRepository.create(
        name: event.name,
        description: event.description,
      );
      emit(ProductCategoryFormSuccessfullySubmitted());
    } catch (ex) {
      emit(ProductCategoryFormException(ex));
    }
  }
}
