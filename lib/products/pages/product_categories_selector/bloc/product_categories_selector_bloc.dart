import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../products.dart';

part 'product_categories_selector_event.dart';
part 'product_categories_selector_state.dart';

class ProductCategoriesSelectorBloc extends Bloc<ProductCategoriesSelectorEvent,
    ProductCategoriesSelectorState> {
  ProductCategoriesSelectorBloc(
    this.productRepository,
  ) : super(ProductCategoriesSelectorLoading()) {
    on<ProductCategoriesSelectorStarted>(_onStarted);
    on<ProductCategoriesSelectorSubmitted>(_onSubmitted);
    on<ProductCategoriesSelectorSelected>(_onSelected);
  }

  final ProductRepository productRepository;

  Future<void> _onStarted(
    ProductCategoriesSelectorStarted event,
    Emitter<ProductCategoriesSelectorState> emit,
  ) async {
    emit(ProductCategoriesSelectorLoading());
    try {
      final categories = await productRepository.loadProductCategories();

      var selecteds = (state is ProductCategoriesSelectorLoaded)
          ? (state as ProductCategoriesSelectorLoaded).selectedCategories
          : event.initialSelectedCategories;

      final mappedCategories = {
        for (var category in categories) category: selecteds.contains(category)
      };

      emit(ProductCategoriesSelectorLoaded(mappedCategories));
    } catch (ex) {
      emit(ProductCategoriesSelectorException(ex));
    }
  }

  _onSubmitted(
    ProductCategoriesSelectorSubmitted event,
    Emitter<ProductCategoriesSelectorState> emit,
  ) async {
    if (state is ProductCategoriesSelectorLoaded) {
      emit(ProductCategoriesSelectorSubmitting(
          (state as ProductCategoriesSelectorLoaded).selectedCategories));
    }
  }

  _onSelected(
    ProductCategoriesSelectorSelected event,
    Emitter<ProductCategoriesSelectorState> emit,
  ) async {
    if (state is ProductCategoriesSelectorLoaded) {
      final mappedCategories =
          (state as ProductCategoriesSelectorLoaded).categories;
      mappedCategories[event.selectedCategory] =
          !mappedCategories[event.selectedCategory]!;
      emit(ProductCategoriesSelectorLoaded(Map.from(mappedCategories)));
    }
  }
}
