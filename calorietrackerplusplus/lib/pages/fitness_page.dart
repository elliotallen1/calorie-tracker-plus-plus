import 'package:calorietrackerplusplus/log_calories_dialog.dart';
import 'package:calorietrackerplusplus/set_goal_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider; 
import 'package:provider/provider.dart';
import 'package:calorietrackerplusplus/app_state.dart';      
import 'package:flutter/material.dart';  
import 'package:go_router/go_router.dart';    
import 'package:calorietrackerplusplus/src/authentication.dart';
import 'package:calorietrackerplusplus/src/widgets.dart';

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
          Expanded(child: const Text("stuff")),
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