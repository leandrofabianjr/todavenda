part of 'client_form_bloc.dart';

sealed class ClientFormEvent extends Equatable {
  const ClientFormEvent();
}

final class ClientFormSubmitted extends ClientFormEvent {
  const ClientFormSubmitted({
    required this.name,
  });

  final String name;

  @override
  List<Object?> get props => [name];
}
