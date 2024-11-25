import 'package:calorietrackerplusplus/friend_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For formatting dates

class FriendsPage extends StatelessWidget {
  const FriendsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: const Border(
          bottom: BorderSide(color: Colors.black, width: 1.5),
        ),
        title: const Text('Friends'), backgroundColor: const Color.fromARGB(255, 165, 244, 20),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error loading users'));
          }

          // Get current date in YYYY-MM-DD format
          String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

          // Get list of users and build FriendCards
          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: snapshot.data!.docs.map((userDoc) {
              String userId = userDoc.id;
              String userEmail = userDoc['email']; // Fetch the email instead of the name

              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(userId)
                    .collection('progress')
                    .doc(currentDate)
                    .get(),
                builder: (context, progressSnapshot) {
                  bool goalCompleted = false; // Default value

                  // If we have data, check the goalCompleted field
                  if (progressSnapshot.hasData && progressSnapshot.data!.exists) {
                    goalCompleted = progressSnapshot.data!['goalCompleted'] ?? false;
                  }

                  // Build the FriendCard with the user email and goal completion status
                  return FriendCard(
                    friendEmail: userEmail,
                    goalCompleted: goalCompleted,
                  );
                },
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
