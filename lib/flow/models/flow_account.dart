import 'package:equatable/equatable.dart';

class FlowAccount extends Equatable {
  final String? uuid;
  final String name;
  final String? description;
  final double? currentValue;

  const FlowAccount({
    this.uuid,
    required this.name,
    this.description,
    required this.currentValue,
  });

  @override
  List<Object?> get props => [uuid];

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'name': name,
      'description': description,
      'currentValue': currentValue,
    };
  }

  static FlowAccount fromJson(Map<String, dynamic> json) {
    return FlowAccount(
      uuid: json['uuid'],
      name: json['name'],
      description: json['description'],
      currentValue: json['currentValue'],
    );
  }
}
