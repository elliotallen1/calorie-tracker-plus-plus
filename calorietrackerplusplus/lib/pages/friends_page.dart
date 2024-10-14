import 'package:flutter/material.dart';
import 'fitness_page.dart';

class FriendsPage extends StatelessWidget {
  const FriendsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Friends')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FitnessPage()),
            );
          },
          child: const Text('Go to Fitness'),
        ),
      ),
    );
  }
}
