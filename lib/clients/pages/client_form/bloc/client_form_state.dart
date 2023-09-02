part of 'client_form_bloc.dart';

sealed class ClientFormState extends Equatable {
  const ClientFormState();
}

final class ClientFormEditing extends ClientFormState {
  const ClientFormEditing({
    this.name = '',
    this.nameError,
  });

  final String name;
  final String? nameError;

  @override
  List<Object?> get props => [name];

  ClientFormEditing copyWith({
    String? name,
    String? nameError,
  }) {
    return ClientFormEditing(
      name: name ?? this.name,
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
