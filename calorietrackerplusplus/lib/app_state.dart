import 'dart:async';     

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:calorietrackerplusplus/days_calories.dart';
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

  StreamSubscription<QuerySnapshot>? _caloriesSubscription;
  List<DaysCalories> _daysCalories = [];
  List<DaysCalories> get daysCalories => _daysCalories;

  Future<void> init() async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);

    FirebaseUIAuth.configureProviders([
      EmailAuthProvider(),
    ]);
    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        _loggedIn = true;
      } else {
        _loggedIn = false;
      }
      notifyListeners();
    });

    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        _loggedIn = true;
        _caloriesSubscription = FirebaseFirestore.instance
            .collection('calories')
            .orderBy('day', descending: true)
            .snapshots()
            .listen((snapshot) {
          _daysCalories = [];
          for (final document in snapshot.docs) {
            _daysCalories.add(
              DaysCalories(
                calories: document.data()['calories'] as int,
                day: document.data()['day'] as DateTime,
                goal: 0,
              ),
            );
          }
          notifyListeners();
        });
      } else {
        _loggedIn = false;
        _daysCalories = [];
        _caloriesSubscription?.cancel();
      }
      notifyListeners();
    });
  }


  Future<DocumentReference> addCaloriesToDay(int c, DateTime day) {
    if (!_loggedIn) {
      throw Exception('Must be logged in');
    }

    return FirebaseFirestore.instance
        .collection('calories')
        .add(<String, dynamic>{
      'calories': 10,
      'day': day,
      'name': FirebaseAuth.instance.currentUser!.displayName,
      'userId': FirebaseAuth.instance.currentUser!.uid,
      'goal': 0,
    });
  }

}