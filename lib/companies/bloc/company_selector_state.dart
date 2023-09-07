part of 'company_selector_bloc.dart';

sealed class CompanySelectorState extends Equatable {
  const CompanySelectorState();

  @override
  List<Object> get props => [];
}

final class CompanySelectorInitial extends CompanySelectorState {}

final class CompanySelectorSuccess extends CompanySelectorState {
  const CompanySelectorSuccess({
    required this.companies,
    required this.company,
  });

  final List<Company> companies;
  final Company company;
}

final class CompanySelectorException extends CompanySelectorState {
  const CompanySelectorException({required this.ex});

  final Object ex;
}
