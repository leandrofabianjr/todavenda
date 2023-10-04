import 'package:equatable/equatable.dart';

class Company extends Equatable {
  const Company({required this.name, required this.pixKey});

  final String name;
  final String? pixKey;

  @override
  List<Object?> get props => [];

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'pixKey': pixKey,
    };
  }

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      name: json['name'],
      pixKey: json['pixKey'],
    );
  }
}
