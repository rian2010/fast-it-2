import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile Page',
          style: TextStyle(color: Colors.black),
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
                // backgroundImage: AssetImage(
                //     'assets/profile_image.jpg'), // You should replace this with the path to the user's profile image.
              ),
            ),
            const Text(
              'John Doe', // Replace with the user's name
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            const Text(
              'johndoe@example.com', // Replace with the user's email
              style: TextStyle(
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
