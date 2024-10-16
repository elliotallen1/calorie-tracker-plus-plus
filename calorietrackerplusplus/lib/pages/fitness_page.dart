import 'package:calorietrackerplusplus/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider; 
import 'package:provider/provider.dart';
import 'package:calorietrackerplusplus/app_state.dart';      
import 'package:flutter/material.dart';  
import 'package:go_router/go_router.dart';    
import 'package:calorietrackerplusplus/src/authentication.dart';
import 'package:calorietrackerplusplus/src/widgets.dart';
import 'friends_page.dart';



class FitnessPage extends StatelessWidget {
  const FitnessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  title: const Text('Fitness'),
  actions: [
    Consumer<ApplicationState>(
      builder: (context, appState, _) => AuthFunc(
        loggedIn: appState.loggedIn,
        signOut: () {
          FirebaseAuth.instance.signOut();
        },
      ),
    ),
  ],
),
      body: Column(
        children: <Widget>[
          Expanded(child: Text("stuff")),
          Consumer<ApplicationState>(
            builder: (context, appState, _) => Column(
              children: [
                if (appState.loggedIn) ...[
                  StyledButton(
                    onPressed: () {
                      _showSetGoalDialog(context, appState);
                    },
                    child: const Text('Set Goal'),
                  ),
                  StyledButton(
                    onPressed: () => context.push('/friends'),
                    child: const Text('Friends'),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showSetGoalDialog(BuildContext context, ApplicationState appState) {
    final _goalController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
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
      ),
    );
  }
}