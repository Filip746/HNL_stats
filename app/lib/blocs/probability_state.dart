import 'package:equatable/equatable.dart';
import '../models/team_probability.dart';

abstract class ProbabilityState extends Equatable {
  const ProbabilityState();

  @override
  List<Object> get props => [];
}

class ProbabilityInitial extends ProbabilityState {}

class ProbabilityLoading extends ProbabilityState {}

class ProbabilityLoaded extends ProbabilityState {
  final List<TeamProbability> probabilities;

  const ProbabilityLoaded(this.probabilities);

  @override
  List<Object> get props => [probabilities];
}

class ProbabilityError extends ProbabilityState {
  final String message;

  const ProbabilityError(this.message);

  @override
  List<Object> get props => [message];
}
