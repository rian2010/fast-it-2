import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fast_it_2/screens/dinas/main_dinas.dart';
import 'package:fast_it_2/screens/staff/main_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fast_it_2/screens/siswa/mainpage.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isObscure = true; // Initially, the password is obscured

  void _togglePasswordVisibility() {
    setState(() {
      _isObscure = !_isObscure;
    });
  }

  void _signInWithEmailAndPassword() async {
    try {
      final String email = _emailController.text.trim();
      final String password = _passwordController.text.trim();

      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        // Retrieve the user's role from Firestore or Firebase Authentication
        // You should have a way to store and retrieve the user's role.
        // For this example, let's assume you have a "role" field in Firestore.

        // Replace 'yourFirestoreCollection' with the actual collection where user roles are stored.
        DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .get();

        if (userSnapshot.exists) {
          String userRole = userSnapshot.get('role');

          // Now, based on the user's role, you can navigate to the appropriate screen.
          switch (userRole) {
            case 'Siswa':
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        const Dashboard()), // Replace with your SiswaDashboard widget.
              );
              break;
            case 'Staff':
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        const StaffHomePage()), // Replace with your StaffDashboard widget.
              );
            case 'Dinas':
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        const DinasPage()), // Replace with your StaffDashboard widget.
              );
              break;
            default:
              // Handle unknown roles or other cases.
              print("Unknown role: $userRole");
          }
        } else {
          // Handle the case where the user's role data is not found.
          print("User role not found");
        }
      } else {
        // Handle the case where authentication failed.
        // You can display an error message to the user.
        print("Authentication failed");
      }
    } catch (e) {
      // Handle any exceptions that occur during the sign-in process.
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 300,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color:
                          const Color(0xFF1CC2CD), // Set the outline color here
                    ),
                  ),
                  child: TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      hintText: "Email",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(10),
                      prefixIcon: Icon(Icons.person), // Email icon
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  width: 300,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    // border: Border.all(
                    //   color:
                    //       const Color(0xFF1CC2CD), // Set the outline color here
                    // ),
                  ),
                  child: TextFormField(
                    obscureText: _isObscure,
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      hintText: "Password",
                      border: const OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF1CC2CD))),
                      contentPadding: const EdgeInsets.all(10),
                      prefixIcon: const Icon(Icons.lock), // Password icon
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isObscure ? Icons.visibility : Icons.visibility_off,
                          color: Colors.grey,
                        ),
                        onPressed: _togglePasswordVisibility,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 300,
                  child: ElevatedButton(
                    onPressed: _signInWithEmailAndPassword,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color(0xFF1CC2CD),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "Login",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
