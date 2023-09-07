import 'package:equatable/equatable.dart';

class Company extends Equatable {
  const Company({required this.uuid, required this.name});

  final String uuid;
  final String name;

  @override
  List<Object?> get props => [];

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'name': name,
    };
  }

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      uuid: json['uuid'],
      name: json['name'],
    );
  }
}
