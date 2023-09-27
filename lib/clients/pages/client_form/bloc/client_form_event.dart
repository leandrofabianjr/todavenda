part of 'client_form_bloc.dart';

sealed class ClientFormEvent extends Equatable {
  const ClientFormEvent();
}

class ClientFormStarted extends ClientFormEvent {
  const ClientFormStarted({this.uuid});

  final String? uuid;

  @override
  List<Object?> get props => [uuid];
}

final class ClientFormSubmitted extends ClientFormEvent {
  const ClientFormSubmitted({
    this.uuid,
    required this.name,
    this.phone,
    this.address,
    this.observation,
  });

  final String? uuid;
  final String name;
  final String? phone;
  final String? address;
  final String? observation;

  @override
  List<Object?> get props => [uuid, name, phone, address, observation];
}
