import 'package:calorietrackerplusplus/main.dart';
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
      appBar: AppBar(title: const Text('Fitness'), actions: <Widget>[
        Consumer<ApplicationState>(
            builder: (context, appState, _) => AuthFunc(
                loggedIn: appState.loggedIn,
                signOut: () {
                  FirebaseAuth.instance.signOut();
                }),
        ),
      ],),
      body: Column(children: <Widget>[
        Expanded(child: Text("stuff")),
        
        Consumer<ApplicationState>(
        builder: (context, appState, _) => Column(
        children: [
          if (appState.loggedIn) ...[
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: <Widget>[ 
            StyledButton(
              onPressed: () {},
              child: const Text('Set Goal'),
            ), 
            StyledButton(
              onPressed: () => context.push('/friends'),
              child: const Text('Friends'),
            ), 
            
          ],
          ),
        ],
        ],
        ),
      ),
      ] )
        
          
          /*
          ),*/
          
        
        
      
    );
  }
}
