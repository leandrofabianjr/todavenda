import 'package:equatable/equatable.dart';

class AuthUser extends Equatable {
  const AuthUser({
    this.uuid,
    this.googleUid,
    required this.email,
    required this.name,
    this.picture,
    this.googleUserData,
  });

  final String? uuid;
  final String email;
  final String name;
  final String? picture;
  final String? googleUid;
  final String? googleUserData;

  @override
  List<Object?> get props => [uuid, googleUid, email, name, picture];

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'googleUid': googleUid,
      'email': email,
      'name': name,
      'picture': picture,
      'googleUserData': googleUserData,
    };
  }

  static AuthUser? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    return AuthUser(
      uuid: json['uuid'],
      email: json['email'],
      name: json['name'],
      googleUid: json['googleUid'],
      picture: json['picture'],
      googleUserData: json['googleUserData'],
    );
  }

  AuthUser copyWith({
    String? uuid,
    String? email,
    String? name,
    String? picture,
    String? googleUid,
    String? googleUserData,
  }) {
    return AuthUser(
      uuid: uuid ?? this.uuid,
      email: email ?? this.email,
      name: name ?? this.name,
      googleUid: googleUid ?? this.googleUid,
      picture: picture ?? this.picture,
      googleUserData: googleUserData ?? this.googleUserData,
    );
  }
}
