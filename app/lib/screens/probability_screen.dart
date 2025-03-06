import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/probability_bloc.dart';
import '../blocs/probability_event.dart';
import '../blocs/probability_state.dart';
import '../widgets/probability_table.dart';

class ProbabilityScreen extends StatelessWidget {
  const ProbabilityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Team Probabilities'),
      ),
      body: BlocBuilder<ProbabilityBloc, ProbabilityState>(
        builder: (context, state) {
          if (state is ProbabilityInitial) {
            BlocProvider.of<ProbabilityBloc>(context).add(FetchProbabilities());
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProbabilityLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProbabilityLoaded) {
            return ProbabilityTable(probabilities: state.probabilities);
          } else if (state is ProbabilityError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const Center(child: Text('Unknown state'));
        },
      ),
    );
  }
}
