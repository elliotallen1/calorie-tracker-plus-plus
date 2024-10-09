import 'package:flutter/material.dart';
import 'friends_page.dart';

class FitnessPage extends StatelessWidget {
  const FitnessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fitness')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FriendsPage()),
            );
          },
          child: const Text('Go to Friends'),
        ),
      ),
    );
  }
}
