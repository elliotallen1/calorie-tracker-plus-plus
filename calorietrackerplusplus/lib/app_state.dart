import 'dart:async';     

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';


import 'firebase_options.dart';

class ApplicationState extends ChangeNotifier {
  ApplicationState() {
    init();
  }

  bool _loggedIn = false;
  bool get loggedIn => _loggedIn;

  // Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> init() async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);

    FirebaseUIAuth.configureProviders([
      EmailAuthProvider(),
    ]);

    FirebaseAuth.instance.userChanges().listen((user) {
  if (user != null) {
    _loggedIn = true;
    _initializeUserInFirestore(user.uid);
    print("User is logged in: ${user.email}");
  } else {
    _loggedIn = false;
    print("User is not logged in");
  }
  notifyListeners();
});

  }

  Future<void> _initializeUserInFirestore(String userId) async {
    // Check if the user already exists in Firestore
    final userDoc = _firestore.collection('users').doc(userId);
    final docSnapshot = await userDoc.get();
    
    if (!docSnapshot.exists) {
      // Create user document with default values if it doesn't exist
      await userDoc.set({
        'email': FirebaseAuth.instance.currentUser!.email,
        'calorieGoal': 2000, // Default goal
        'friends': [],
      });
    }
  }
}