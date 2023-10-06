// ignore_for_file: use_build_context_synchronously

import 'package:fast_it_2/screens/dinas/main_dinas.dart';
import 'package:fast_it_2/screens/siswa/mainpage.dart';
import 'package:fast_it_2/screens/staff/main_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(home: Registration()));
}

class Registration extends StatefulWidget {
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  bool _isObscure = true;
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _emailController = TextEditingController();
  final _usernameController =
      TextEditingController(); // Added username controller
  String _selectedRole = 'Siswa'; // Default role selection

  final List<String> _roles = [
    'Siswa',
    'Staff',
    'Dinas'
  ]; // List of available roles

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _emailController.dispose();
    _usernameController.dispose(); // Dispose of the username controller
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isObscure = !_isObscure;
    });
  }

  void _signUp(String email, String password, String confirmPassword,
      String username, String role) async {
    if (_formKey.currentState!.validate()) {
      if (password == confirmPassword) {
        try {
          UserCredential userCredential = await FirebaseAuth.instance
              .createUserWithEmailAndPassword(email: email, password: password);

          // Store additional user details in Firestore
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userCredential.user!.uid)
              .set({
            'email': email,
            'username': username, // Added username field
            'role': role,
          });
          if (role == 'Siswa') {
            // Redirect admin users to the AdminDashboard
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Dashboard()),
            );
          } else if (role == 'Staff') {
            // Redirect regular users to the UserDashboard
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => StaffHomePage()),
            );
          } else if (role == 'Dinas') {
            // Redirect Dinas users to the DinasHomePage (replace with the actual page name)
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => DinasPage()),
            );
          } else {
            // Handle unknown role or other cases
            print("Unknown role: $role");
            // You can add further handling or redirection here if needed
          }
        } catch (e) {
          // Handle registration error, e.g., display an error message
          print("Registration error: $e");
        }
      } else {
        // Handle password mismatch error, e.g., display an error message
        print("Passwords do not match");
      }
    }
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Registration Page'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey, // Added form key
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 300,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: const Color(0xFF1CC2CD),
                      ),
                    ),
                    child: TextFormField(
                      controller:
                          _usernameController, // Added username controller
                      decoration: const InputDecoration(
                        hintText: "Username",
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(10),
                        prefixIcon: Icon(Icons.person),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: 300,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: const Color(0xFF1CC2CD),
                      ),
                    ),
                    child: TextFormField(
                      controller: _emailController, // Added email controller
                      decoration: const InputDecoration(
                        hintText: "Email", // Added email field
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(10),
                        prefixIcon: Icon(Icons.email), // Email icon
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: 300,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: const Color(0xFF1CC2CD),
                      ),
                    ),
                    child: TextFormField(
                      obscureText: _isObscure,
                      controller: _passwordController,
                      decoration: InputDecoration(
                        hintText: "Password",
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(10),
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isObscure
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                          onPressed: _togglePasswordVisibility,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: 300,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: const Color(0xFF1CC2CD),
                      ),
                    ),
                    child: TextFormField(
                      obscureText: _isObscure,
                      controller: _confirmPasswordController,
                      decoration: InputDecoration(
                        hintText: "Confirm Password",
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(10),
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isObscure
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                          onPressed: _togglePasswordVisibility,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: 300,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: const Color(0xFF1CC2CD),
                      ),
                    ),
                    child: DropdownButtonFormField<String>(
                      value: _selectedRole,
                      onChanged: (value) {
                        setState(() {
                          _selectedRole = value ?? 'User';
                        });
                      },
                      items: _roles.map((role) {
                        return DropdownMenuItem<String>(
                          value: role,
                          child: Text(role),
                        );
                      }).toList(),
                      decoration: InputDecoration(
                        hintText: "Select Role",
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 300,
                    child: ElevatedButton(
                      onPressed: () async {
                        String email = _emailController.text.trim();
                        String password = _passwordController.text.trim();
                        String confirmPassword =
                            _confirmPasswordController.text.trim();
                        String username = _usernameController.text.trim();
                        String role = _selectedRole;

                        _signUp(
                            email, password, confirmPassword, username, role);
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: const Color(0xFF1CC2CD),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        "Register",
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
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
      ),
      body: Center(
        child: Text('Welcome to the Home Screen!'),
      ),
    );
  }
}
