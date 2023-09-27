part of 'client_form_bloc.dart';

sealed class ClientFormState extends Equatable {
  const ClientFormState();
}

final class ClientFormEditing extends ClientFormState {
  const ClientFormEditing({
    this.uuid,
    this.name = '',
    this.nameError,
    this.phone,
    this.address,
    this.observation,
  });

  final String? uuid;
  final String name;
  final String? phone;
  final String? address;
  final String? observation;
  final String? nameError;

  @override
  List<Object?> get props => [name];

  ClientFormEditing copyWith({
    String? uuid,
    String? name,
    String? phone,
    String? address,
    String? observation,
    String? nameError,
  }) {
    return ClientFormEditing(
      uuid: uuid ?? this.uuid,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      observation: observation ?? this.observation,
      nameError: nameError ?? this.nameError,
    );
  }
}

final class ClientFormSubmitting extends ClientFormState {
  @override
  List<Object> get props => [];
}

final class ClientFormSuccessfullySubmitted extends ClientFormState {
  @override
  List<Object> get props => [];
}

final class ClientFormException extends ClientFormState {
  const ClientFormException(this.ex);

  final Object ex;

  @override
  List<Object> get props => [ex];
}
