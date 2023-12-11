import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // String? _selectedRole;
  final _defaultRole = 'Siswa';

  Future<User?> signUp(String email, String password, String username) async {
    try {
      // Hash the password using SHA-256
      String hashedPassword = sha256.convert(utf8.encode(password)).toString();

      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: hashedPassword, // Use the hashed password here
      );

      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'email': email,
        'username': username,
        'password': hashedPassword, // Store the hashed password in the database
        'role': _defaultRole,
        // Add other user data as needed
      });

      // Return the signed-in user
      return userCredential.user;
    } catch (e) {
      // Handle registration error
      return null;
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  // Add other Firebase-related methods like signIn, signOut, etc.
}
