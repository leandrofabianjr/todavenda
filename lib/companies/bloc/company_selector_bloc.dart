import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todavenda/auth/models/user.dart';
import 'package:todavenda/companies/companies.dart';
import 'package:todavenda/companies/models/Company.dart';

part 'company_selector_event.dart';
part 'company_selector_state.dart';

class CompanySelectorBloc
    extends Bloc<CompanySelectorEvent, CompanySelectorState> {
  CompanySelectorBloc(this.companiesRepository)
      : super(CompanySelectorInitial()) {
    on<CompanySelectorStarted>(_onCompanySelectorStarted);
  }

  static String getCompanyUuid(BuildContext context) {
    return (context.read<CompanySelectorBloc>().state as CompanySelectorSuccess)
        .company
        .uuid;
  }

  final CompaniesRepository companiesRepository;

  _onCompanySelectorStarted(
    CompanySelectorStarted event,
    Emitter<CompanySelectorState> emit,
  ) async {
    try {
      final companies = await companiesRepository.loadByUser(
        userUuid: event.user.uuid!,
      );
      emit(CompanySelectorSuccess(
        companies: companies,
        company: companies.first,
      ));
    } catch (ex) {
      emit(CompanySelectorException(ex: ex));
    }
  }
}
