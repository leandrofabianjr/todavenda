part of 'client_form_bloc.dart';

sealed class ClientFormEvent extends Equatable {
  const ClientFormEvent();
}

final class ClientFormSubmitted extends ClientFormEvent {
  const ClientFormSubmitted({
    required this.name,
    this.phone,
    this.address,
    this.observation,
  });

  final String name;
  final String? phone;
  final String? address;
  final String? observation;

  @override
  List<Object?> get props => [name];
}
