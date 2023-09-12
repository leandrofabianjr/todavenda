part of 'company_selector_bloc.dart';

sealed class CompanySelectorEvent extends Equatable {
  const CompanySelectorEvent();

  @override
  List<Object> get props => [];
}

class CompanySelectorStarted extends CompanySelectorEvent {
  const CompanySelectorStarted();
}
