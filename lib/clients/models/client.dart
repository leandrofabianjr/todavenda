import 'package:equatable/equatable.dart';

class Client extends Equatable {
  final String? uuid;
  final String name;

  const Client({
    this.uuid,
    required this.name,
    this.phone,
    this.address,
    this.observation,
  });

  final String? phone;
  final String? address;
  final String? observation;

  @override
  List<Object?> get props => [uuid];

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'name': name,
      'phone': phone,
      'address': address,
      'observation': observation,
    };
  }
}
