import 'package:equatable/equatable.dart';

class AuthUser extends Equatable {
  const AuthUser({
    this.uuid,
    this.googleUid,
    required this.email,
    required this.name,
    this.picture,
  });

  final String? uuid;
  final String? googleUid;
  final String email;
  final String name;
  final String? picture;

  @override
  List<Object?> get props => [uuid, googleUid, email, name, picture];
}
