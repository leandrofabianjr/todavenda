import 'package:equatable/equatable.dart';

class AuthUser extends Equatable {
  const AuthUser({
    this.uuid,
    required this.email,
    required this.name,
    this.picture,
    this.googleUserData,
    this.active,
  });

  final String? uuid;
  final String email;
  final String name;
  final String? picture;
  final String? googleUserData;
  final bool? active;

  @override
  List<Object?> get props => [uuid];

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'email': email,
      'name': name,
      'picture': picture,
      'googleUserData': googleUserData,
      'active': active,
    };
  }

  static AuthUser? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    return AuthUser(
      uuid: json['uuid'],
      email: json['email'],
      name: json['name'],
      picture: json['picture'],
      googleUserData: json['googleUserData'],
      active: json['active'],
    );
  }

  AuthUser copyWith({
    String? uuid,
    String? email,
    String? name,
    String? picture,
    String? googleUid,
    String? googleUserData,
    List<dynamic>? companies,
  }) {
    return AuthUser(
      uuid: uuid ?? this.uuid,
      email: email ?? this.email,
      name: name ?? this.name,
      picture: picture ?? this.picture,
      googleUserData: googleUserData ?? this.googleUserData,
    );
  }
}
