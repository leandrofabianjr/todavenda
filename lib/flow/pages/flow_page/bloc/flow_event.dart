part of 'flow_bloc.dart';

sealed class FlowEvent extends Equatable {
  const FlowEvent();
}

class FlowRefreshed extends FlowEvent {
  const FlowRefreshed({this.filter});

  final FlowFilter? filter;

  @override
  List<Object?> get props => [];
}
