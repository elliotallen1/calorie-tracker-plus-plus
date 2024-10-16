import 'package:calorietrackerplusplus/log_calories_dialog.dart';
import 'package:calorietrackerplusplus/set_goal_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider; 
import 'package:provider/provider.dart';
import 'package:calorietrackerplusplus/app_state.dart';      
import 'package:flutter/material.dart';  
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';    
import 'package:calorietrackerplusplus/src/authentication.dart';
import 'package:calorietrackerplusplus/src/widgets.dart';

class FitnessPage extends StatelessWidget {
  const FitnessPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final today = DateTime.now().toIso8601String().split('T')[0]; // YYYY-MM-DD

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
          // Display progress as a fraction
          Expanded(
            child: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(userId)
                  .snapshots(),
              builder: (context, userSnapshot) {
                if (userSnapshot.hasError) {
                  return const Text('Error fetching data');
                }

                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  return const Text('Loading...');
                }

                // Fetch user data (calorie goal)
                final userData = userSnapshot.data?.data() as Map<String, dynamic>?;
                final calorieGoal = userData?['calorieGoal'] ?? 2000; // Default to 2000 if no goal is set

                return StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(userId)
                      .collection('progress')
                      .doc(today)
                      .snapshots(),
                  builder: (context, progressSnapshot) {
                    // Fetch progress data (calories consumed)
                    final progressData = progressSnapshot.data?.data() as Map<String, dynamic>?;
                    final caloriesConsumed = progressData?['caloriesConsumed'] ?? 0;

                    // Display progress as a fraction
                    return Text(
                      'Calories: $caloriesConsumed / $calorieGoal',
                      style: const TextStyle(fontSize: 18),
                    );
                  },
                );
              },
            ),
          ),
          
          Consumer<ApplicationState>(
            builder: (context, appState, _) => Column(
              children: [
                if (appState.loggedIn) ...[
                  StyledButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => SetGoalDialog(),
                      );
                    },
                    child: const Text('Set Goal'),
                  ),
                  StyledButton(
                    onPressed: () => context.push('/friends'),
                    child: const Text('Friends'),
                  ),
                  StyledButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => LogCaloriesDialog(),
                      );
                    },
                    child: const Text('Log Calories'),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
