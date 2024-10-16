import 'package:calorietrackerplusplus/pages/fitness_page.dart';
import 'package:calorietrackerplusplus/pages/friends_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart'; 
import 'package:flutter/material.dart';      
import 'package:go_router/go_router.dart';     
import 'package:provider/provider.dart';                
import 'package:google_fonts/google_fonts.dart'; 
import 'app_state.dart';                         



void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(ChangeNotifierProvider(
    create: (context) => ApplicationState(),
    builder: ((context, child) => const App()),
  ));
}


final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const FitnessPage(),
      routes: [
        GoRoute(
          path: 'sign-in',
          builder: (context, state) {
            return SignInScreen(
              actions: [
                ForgotPasswordAction(((context, email) {
                  final uri = Uri(
                    path: '/sign-in/forgot-password',
                    queryParameters: <String, String?>{
                      'email': email,
                    },
                  );
                  context.push(uri.toString());
                })),
                AuthStateChangeAction(((context, state) {
                  final user = switch (state) {
                    SignedIn state => state.user,
                    UserCreated state => state.credential.user,
                    _ => null
                  };
                  if (user == null) {
                    return;
                  }
                  if (state is UserCreated) {
                    user.updateDisplayName(user.email!.split('@')[0]);
                  }
                  if (!user.emailVerified) {
                    user.sendEmailVerification();
                    const snackBar = SnackBar(
                        content: Text(
                            'Please check your email to verify your email address'));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                  context.pushReplacement('/');
                })),
              ],
            );
            
          },
          routes: [
            GoRoute(
              path: 'forgot-password',
              builder: (context, state) {
                final arguments = state.uri.queryParameters;
                return ForgotPasswordScreen(
                  email: arguments['email'],
                  headerMaxExtent: 200,
                );
              },
            ),
          ],
        ),
        GoRoute(
          path: 'profile',
          builder: (context, state) {
            return ProfileScreen(
              providers: const [],
              actions: [
                SignedOutAction((context) {
                  context.pushReplacement('/');
                }),
              ],
            );
          },
        ),
        GoRoute(path: 'friends',
        builder: (context, state){
          return const FriendsPage();
        }),
        GoRoute(path: 'fitness',
        builder: (context, state){
          return const FitnessPage();
        }),
      ],
    ),
  ],
);



class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'CalorieTracker++',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 165, 244, 20)),
        useMaterial3: true,
      ),
      routerConfig: _router,
    );
  }
}


