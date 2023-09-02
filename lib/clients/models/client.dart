import 'package:equatable/equatable.dart';

class Client extends Equatable {
  final String? uuid;
  final String name;

  const Client({
    this.uuid,
    required this.name,
  });

  @override
  List<Object?> get props => [uuid];

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'name': name,
    };
  }
}
