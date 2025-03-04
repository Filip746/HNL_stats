import 'package:equatable/equatable.dart';

abstract class ProbabilityEvent extends Equatable {
  const ProbabilityEvent();

  @override
  List<Object> get props => [];
}

class FetchProbabilities extends ProbabilityEvent {}
