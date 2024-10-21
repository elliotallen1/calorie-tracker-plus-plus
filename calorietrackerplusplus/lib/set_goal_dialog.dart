import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SetGoalDialog extends StatelessWidget {
  final TextEditingController _goalController = TextEditingController();

  SetGoalDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Set Daily Calorie Goal'),
      content: TextField(
        controller: _goalController,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(hintText: 'Enter new calorie goal'),
      ),
      actions: [
        TextButton(
          onPressed: () async {
            if (_goalController.text.isNotEmpty) {
              final newGoal = int.parse(_goalController.text);
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .set({'calorieGoal': newGoal}, SetOptions(merge: true));
            }
            Navigator.of(context).pop();
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
