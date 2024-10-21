import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LogCaloriesDialog extends StatelessWidget {
  final TextEditingController _calorieController = TextEditingController();

  LogCaloriesDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Log Calories Consumed'),
      content: TextField(
        controller: _calorieController,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(hintText: 'Enter calories'),
      ),
      actions: [
        TextButton(
          onPressed: () async {
            if (_calorieController.text.isNotEmpty) {
              final newCalories = int.parse(_calorieController.text);
              final userId = FirebaseAuth.instance.currentUser!.uid;
              final today = DateTime.now().toIso8601String().split('T')[0]; // YYYY-MM-DD

              final progressDoc = FirebaseFirestore.instance
                  .collection('users')
                  .doc(userId)
                  .collection('progress')
                  .doc(today);

              await FirebaseFirestore.instance.runTransaction((transaction) async {
                final snapshot = await transaction.get(progressDoc);
                if (snapshot.exists) {
                  final currentCalories = snapshot.data()?['caloriesConsumed'] ?? 0;
                  transaction.update(progressDoc, {
                    'caloriesConsumed': currentCalories + newCalories,
                  });
                } else {
                  transaction.set(progressDoc, {
                    'caloriesConsumed': newCalories,
                  });
                }
              });
            }
            Navigator.of(context).pop();
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
