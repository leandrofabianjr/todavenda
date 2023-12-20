import 'package:equatable/equatable.dart';

class FlowAccount extends Equatable {
  final String? uuid;
  final String name;
  final String? description;
  final double currentAmount;

  const FlowAccount({
    this.uuid,
    required this.name,
    this.description,
    required this.currentAmount,
  });

  @override
  List<Object?> get props => [uuid];

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'name': name,
      if (description != null && description!.isNotEmpty)
        'description': description,
      'currentAmount': currentAmount,
    };
  }

  static FlowAccount fromJson(Map<String, dynamic> json) {
    return FlowAccount(
      uuid: json['uuid'],
      name: json['name'],
      description: json['description'],
      currentAmount: json['currentAmount'],
    );
  }
}
