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
        title: const Text('Pengguna'),
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
            return GestureDetector(
              onLongPress: () {
                // Show your modal here
                showModal(context, user);
              },
              onTap: () {
                // Handle tap on the ListTile (e.g., navigate to user profile)
                // Add your logic here...
              },
              child: ListTile(
                leading: CircleAvatar(
                  child: const Icon(Icons.person),
                ),
                title: Text(user.name),
                subtitle: Text(user.isOnline ? 'Online' : 'Offline'),
                trailing: _buildOnlineIndicator(user.isOnline),
              ),
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
    print('Checking role for user: ${user.name}, Role: ${user.role}');
    return user.role == 'Dinas';
  }

  String getCurrentUserId() {
    final FirebaseAuth.User? user =
        FirebaseAuth.FirebaseAuth.instance.currentUser;
    return user?.uid ?? '';
  }

  void showModal(BuildContext context, User user) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('User: ${user.name}', style: TextStyle(fontSize: 18)),
              SizedBox(height: 8),
              Text('Role: ${user.role}',
                  style: TextStyle(fontSize: 15, color: Colors.grey)),
              ListTile(
                leading: Icon(Icons.delete, color: Colors.red),
                title: Text('Hapus Akun', style: TextStyle(color: Colors.red)),
                onTap: () {
                  // Handle "Hapus Akun" logic here
                  print('Hapus Akun');
                  Navigator.pop(context); // Close the modal
                },
              ),
              ListTile(
                leading: Icon(Icons.lock, color: Colors.blue),
                title: Text('Ganti Password',
                    style: TextStyle(color: Colors.blue)),
                onTap: () {
                  // Handle "Ganti Password" logic here
                  print('Ganti Password');
                  Navigator.pop(context); // Close the modal
                },
              ),
            ],
          ),
        );
      },
    );
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
