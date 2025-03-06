import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/probability_data.dart';
import 'probability_event.dart';
import 'probability_state.dart';

class ProbabilityBloc extends Bloc<ProbabilityEvent, ProbabilityState> {
  ProbabilityBloc() : super(ProbabilityInitial()) {
    on<FetchProbabilities>((event, emit) async {
      emit(ProbabilityLoading());
      try {
        final probabilities = await ProbabilityData.getProbabilities();
        emit(ProbabilityLoaded(probabilities));
      } catch (e) {
        emit(ProbabilityError(e.toString()));
      }
    });
  }
}
