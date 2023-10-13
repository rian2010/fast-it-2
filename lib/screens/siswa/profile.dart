import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String username = '';
  String email = ''; // Initialize username as an empty string

  @override
  void initState() {
    super.initState();
    // Fetch the username from Firestore when the widget is first created
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .get();

        if (userDoc.exists) {
          setState(() {
            username = userDoc['username'];
            email = userDoc['email'];
          });
        }
      } catch (e) {
        print('Error fetching user data: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: const TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: CircleAvatar(
                radius: 80.0,
                backgroundColor:
                    Colors.grey, // Background color for the circle avatar
                child: Icon(
                  Icons.person, // Replace with the icon you want to use
                  size: 100, // Adjust the size as needed
                  color: Colors.white, // Icon color
                ),
              ),
            ),
            Text(
              '$username', // Replace with the user's name
              style: const TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              '$email', // Replace with the user's email
              style: const TextStyle(
                fontSize: 16.0,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16.0),
            const ListTile(
              leading: Icon(Icons.phone),
              title: Text(
                  '+1 123-456-7890'), // Replace with the user's phone number
            ),
            const ListTile(
              leading: Icon(Icons.location_on),
              title: Text(
                  '123 Main St, City, Country'), // Replace with the user's address
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Add functionality to edit profile button
                // This could navigate to an edit profile page.
              },
              child: const Text('Edit Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
