import 'package:equatable/equatable.dart';

class AuthUser extends Equatable {
  const AuthUser({
    this.uuid,
    required this.googleUid,
    required this.email,
    required this.name,
  });

  final String? uuid;
  final String googleUid;
  final String email;
  final String name;

  @override
  List<Object?> get props => [uuid, googleUid, email, name];
}
