import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/probability_bloc.dart';
import 'app.dart';

void main() {
  runApp(
    BlocProvider(
      create: (context) => ProbabilityBloc(),
      child: const MyApp(),
    ),
  );
}
