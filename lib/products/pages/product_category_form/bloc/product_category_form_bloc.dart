import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:todavenda/commons/validators.dart';

import '../../../services/product_categories_repository.dart';

part 'product_category_form_event.dart';
part 'product_category_form_state.dart';

class ProductCategoryFormBloc
    extends Bloc<ProductCategoryFormEvent, ProductCategoryFormState> {
  ProductCategoryFormBloc(this.productCategoriesRepository, {this.uuid})
      : super(const ProductCategoryFormEditing()) {
    on<ProductCategoryFormStarted>(_onStarted);
    on<ProductCategoryFormSubmitted>(_onFormSubmitted);
  }

  final ProductCategoriesRepository productCategoriesRepository;
  final String? uuid;

  Future<void> _onStarted(
    ProductCategoryFormStarted event,
    Emitter<ProductCategoryFormState> emit,
  ) async {
    if (event.uuid == null) {
      return emit(const ProductCategoryFormEditing());
    }

    try {
      final product = await productCategoriesRepository.loadByUuid(event.uuid!);
      emit(ProductCategoryFormEditing(
        uuid: product.uuid,
        name: product.name,
        description: product.description,
      ));
    } catch (ex) {
      emit(ProductCategoryFormException(ex));
    }
  }

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
