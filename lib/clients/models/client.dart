import 'package:equatable/equatable.dart';

class Client extends Equatable {
  const Client({
    required this.companyUuid,
    this.uuid,
    required this.name,
    this.phone,
    this.address,
    this.observation,
  });

  final String companyUuid;
  final String? uuid;
  final String name;
  final String? phone;
  final String? address;
  final String? observation;

  @override
  List<Object?> get props => [uuid];

  Map<String, dynamic> toJson() {
    return {
      if (uuid != null) 'uuid': uuid,
      'companyUuid': companyUuid,
      'name': name,
      if (phone != null) 'phone': phone,
      if (address != null) 'address': address,
      if (observation != null) 'observation': observation,
    };
  }

  static Client? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    return Client(
      companyUuid: json['companyUuid'],
      uuid: json['uuid'],
      name: json['name'],
      phone: json['phone'],
      address: json['address'],
      observation: json['observation'],
    );
  }
}
