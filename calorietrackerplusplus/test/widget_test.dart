// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:calorietrackerplusplus/log_calories_dialog.dart';
import 'package:calorietrackerplusplus/set_goal_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';


void main() {
    test('Counter should start at 0', () {
      final counter = LogCaloriesDialog();

      expect(counter.currentCalories, 0);

    });

  testWidgets('SetGoalDialog builds correctly', (tester) async {  
    await tester.pumpWidget(  
      MaterialApp(  
        home: Scaffold(  
        body: SetGoalDialog(),  
        ),  
      ),  
    );  
    
    expect(find.text('Set Daily Calorie Goal'), findsOneWidget);  
    expect(find.byType(TextField), findsOneWidget);  
    expect(find.text('Save'), findsOneWidget);  
    });  
    
  testWidgets('Save button is disabled when text field is empty', (tester) async {  
   await tester.pumpWidget(  
    MaterialApp(  
      home: Scaffold(  
       body: SetGoalDialog(),  
      ),  
    ),  
   );  
  
   final saveButton = find.text('Save');  
   expect(saveButton, findsOneWidget);  
  
   await tester.tap(saveButton);  
   await tester.pumpAndSettle();  
   expect(find.text('Set Daily Calorie Goal'), findsNothing);  
  });

}