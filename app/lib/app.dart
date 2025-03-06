import 'package:flutter/material.dart';
import 'screens/probability_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Football Probability App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ProbabilityScreen(),
    );
  }
}
