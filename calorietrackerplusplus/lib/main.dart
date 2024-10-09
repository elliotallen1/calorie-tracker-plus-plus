import 'package:calorietrackerplusplus/pages/fitness_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FitnessTracker++',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 165, 244, 20)),
        useMaterial3: true,
      ),
      home: const FitnessPage(),
    );
  }
}
