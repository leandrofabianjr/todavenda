part of 'flow_bloc.dart';

sealed class FlowEvent extends Equatable {
  const FlowEvent();
}

class FlowRefreshed extends FlowEvent {
  const FlowRefreshed();

  @override
  List<Object?> get props => [];
}
