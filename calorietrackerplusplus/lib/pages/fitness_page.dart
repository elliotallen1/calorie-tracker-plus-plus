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
        shape: Border(
          bottom: BorderSide(color: Colors.black, width: 1.5),
        ),
        title: const Text('CalorieTracker++', style: TextStyle(fontSize: 16),), backgroundColor: Color.fromARGB(255, 165, 244, 20),
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
          // Display progress as a fraction and goal status
          Expanded(
            child: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(userId)
                  .snapshots(),
              builder: (context, userSnapshot) {
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

                    // Determine if goal is completed
                    final goalCompleted = caloriesConsumed >= calorieGoal;

                    // Update goalCompleted in Firestore if it's not already set
                    if (progressData?['goalCompleted'] != goalCompleted) {
                      FirebaseFirestore.instance
                          .collection('users')
                          .doc(userId)
                          .collection('progress')
                          .doc(today)
                          .set(
                            {'goalCompleted': goalCompleted},
                            SetOptions(merge: true),
                          );
                    }

                    // Display progress and goal status
                    return Container(decoration: BoxDecoration(color: Color.fromARGB(255, 255, 255, 255)), child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [   
                        Column(children: [
                          Text(
                          'Calories: $caloriesConsumed / $calorieGoal',
                          style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 26),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          goalCompleted
                              ? 'Goal completed!'
                              : 'Goal not yet completed.',
                          style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 20),
                          textAlign: TextAlign.center,
                        ),
                        ],)
                        
                      ],
                    )
                    );
                  },
                );
              },
            ),
          ),
          
          Consumer<ApplicationState>(
            builder: (context, appState, _) => Container(decoration: BoxDecoration(border: Border.all(color: Colors.black, width: 1.5), color: Color.fromARGB(255, 165, 244, 20)), child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => LogCaloriesDialog(),
                      );
                    },
                    child: const Text('Log Calories'),
                  ),
                  StyledButton(
                    onPressed: () => context.push('/friends'),
                    child: const Text('Friends'),
                  ),
                ],
              ],
            ),
            )
          ),
        ],
      ),
    );
  }
}
