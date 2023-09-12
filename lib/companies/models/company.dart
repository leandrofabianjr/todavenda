import 'package:equatable/equatable.dart';

class Company extends Equatable {
  const Company({required this.name});

  final String name;

  @override
  List<Object?> get props => [];

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      name: json['name'],
    );
  }
}
