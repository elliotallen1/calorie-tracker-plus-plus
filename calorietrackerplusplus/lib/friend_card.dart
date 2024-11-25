
import 'package:flutter/material.dart';

class FriendCard extends StatelessWidget {
  final String friendEmail;
  final bool goalCompleted;

  const FriendCard({
    super.key,
    required this.friendEmail,
    required this.goalCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0), 
      //color: Color.fromARGB(255, 165, 244, 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0),
      side: const BorderSide(color: Colors.black)),
      child: Column(
          children: [
            Text(
              friendEmail, 
            ),
            Text(
              goalCompleted ? 'Goal Completed' : 'Goal Incomplete',
            ),
          ],
        ),
    );
  }
}
