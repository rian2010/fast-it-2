import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fast_it_2/screens/dinas/add_user.dart';
import 'package:firebase_auth/firebase_auth.dart' as FirebaseAuth;
import 'package:flutter/material.dart';

class UserList extends StatelessWidget {
  const UserList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void addUser() {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => NambahUser()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('User List'),
        backgroundColor: const Color(0xFF0C356A),
        actions: [
          IconButton(
            onPressed: addUser,
            icon: Icon(Icons.person_add),
          )
        ],
      ),
      body: FutureBuilder<User?>(
        future: getCurrentUser(),
        builder: (context, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (userSnapshot.hasData && isUserDinas(userSnapshot.data!)) {
            // User has the "Dinas" role, proceed with displaying the list
            return _buildUserList();
          } else {
            // User does not have the "Dinas" role
            return const Center(
              child: Text('You do not have permission to access this page.'),
            );
          }
        },
      ),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text('Error loading user data'));
        }

        if (!snapshot.hasData ||
            snapshot.data == null ||
            snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No users available.'));
        }

        List<User> userList =
            snapshot.data!.docs.map((doc) => User.fromDocument(doc)).toList();

        return ListView.builder(
          itemCount: userList.length,
          itemBuilder: (context, index) {
            User user = userList[index];
            return ListTile(
              leading: CircleAvatar(
                child: const Icon(Icons.person),
              ),
              title: Text(user.name),
              subtitle: Text(user.isOnline ? 'Online' : 'Offline'),
              trailing: _buildOnlineIndicator(user.isOnline),
            );
          },
        );
      },
    );
  }

  Widget _buildOnlineIndicator(bool isOnline) {
    return Container(
      width: 12,
      height: 12,
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isOnline ? Colors.green : Colors.red,
      ),
    );
  }

  Future<User?> getCurrentUser() async {
    final FirebaseAuth.User? firebaseUser =
        FirebaseAuth.FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      User? user = await getUserFromFirestore(firebaseUser.uid);
      print('Current User: ${user?.name}, Role: ${user?.role}');
      return user;
    }
    return null;
  }

  bool isUserDinas(User user) {
    // Replace this with your actual logic to check if the user has the "Dinas" role.
    // For example, you might have a field 'role' in your user data.
    print('Checking role for user: ${user.name}, Role: ${user.role}');
    return user.role == 'Dinas';
  }

  String getCurrentUserId() {
    final FirebaseAuth.User? user =
        FirebaseAuth.FirebaseAuth.instance.currentUser;
    return user?.uid ?? '';
  }
}

class User {
  final String uid;
  final String name;
  final bool isOnline;
  final String role; // Assuming you have a 'role' field in your user data

  User({
    required this.uid,
    required this.name,
    required this.isOnline,
    required this.role,
  });

  factory User.fromDocument(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return User(
      uid: document.id,
      name: data['username'] ?? '',
      isOnline: data['isOnline'] ?? false,
      role: data['role'] ?? '', // Replace 'role' with your actual field name
    );
  }
}

Future<User?> getUserFromFirestore(String userId) async {
  try {
    DocumentSnapshot<Map<String, dynamic>> userDocument =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (userDocument.exists) {
      // If the document exists, return a User object
      return User.fromDocument(userDocument);
    } else {
      // If the document does not exist, handle it accordingly (return null or throw an exception)
      return null;
    }
  } catch (e) {
    print('Error fetching user data: $e');
    return null;
  }
}
