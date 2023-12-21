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

  FlowAccount copyWith({
    String? uuid,
    String? name,
    String? description,
    double? currentAmount,
  }) {
    return FlowAccount(
      uuid: uuid ?? this.uuid,
      name: name ?? this.name,
      description: description ?? this.description,
      currentAmount: currentAmount ?? this.currentAmount,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'name': name,
      if (description != null && description!.isNotEmpty)
        'description': description,
      'currentAmount': currentAmount,
    };
  }
}
