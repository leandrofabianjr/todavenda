import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/models.dart';
import '../services/services.dart';

part 'company_selector_event.dart';
part 'company_selector_state.dart';

class CompanySelectorBloc
    extends Bloc<CompanySelectorEvent, CompanySelectorState> {
  CompanySelectorBloc(this.companiesRepository)
      : super(CompanySelectorInitial()) {
    on<CompanySelectorStarted>(_onCompanySelectorStarted);
  }

  final CompaniesRepository companiesRepository;

  _onCompanySelectorStarted(
    CompanySelectorStarted event,
    Emitter<CompanySelectorState> emit,
  ) async {
    try {
      final company = await companiesRepository.load();
      emit(CompanySelectorSuccess(company: company));
    } catch (ex) {
      emit(CompanySelectorException(ex: ex));
    }
  }
}
