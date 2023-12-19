import 'package:equatable/equatable.dart';

class Client extends Equatable {
  const Client({
    required this.uuid,
    required this.name,
    this.phone,
    this.address,
    this.observation,
    this.owing,
  });

  final String uuid;
  final String name;
  final String? phone;
  final String? address;
  final String? observation;
  final List<String>? owing;

  @override
  List<Object> get props => [uuid];

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'name': name,
      if (phone != null) 'phone': phone,
      if (address != null) 'address': address,
      if (observation != null) 'observation': observation,
      if (owing != null) 'owing': owing,
    };
  }

  static Client fromJson(Map<String, dynamic> json) {
    return Client(
      uuid: json['uuid'],
      name: json['name'],
      phone: json['phone'],
      address: json['address'],
      observation: json['observation'],
      owing: json['owing'],
    );
  }

  Client copyWith({
    String? uuid,
    String? name,
    String? phone,
    String? address,
    String? observation,
    List<String>? owing,
  }) {
    return Client(
      uuid: uuid ?? this.uuid,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      observation: observation ?? this.observation,
      owing: owing ?? this.owing,
    );
  }
}
