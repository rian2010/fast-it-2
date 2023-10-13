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
  bool _isButtonPressed = false; // Track button press
  String _emailError = '';
  String _passwordError = '';
  String _authError = '';

  void _togglePasswordVisibility() {
    setState(() {
      _isObscure = !_isObscure;
    });
  }

  Future<void> _signInWithEmailAndPassword() async {
    if (_isButtonPressed) return;

    setState(() {
      _isButtonPressed = true;
      _emailError = '';
      _passwordError = '';
      _authError = '';
    });

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    bool hasError = false;

    if (email.isEmpty) {
      setState(() {
        _emailError = 'Email cannot be empty';
        hasError = true;
      });
    }

    if (password.isEmpty) {
      setState(() {
        _passwordError = 'Password cannot be empty';
        hasError = true;
      });
    }

    if (hasError) {
      setState(() {
        _isButtonPressed = false;
      });
      return;
    }

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .get();

        if (userSnapshot.exists) {
          String userRole = userSnapshot.get('role');

          switch (userRole) {
            case 'Siswa':
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Dashboard(),
                ),
              );
              break;
            case 'Staff':
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const StaffHomePage(),
                ),
              );
              break;
            case 'Dinas':
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DinasPage(),
                ),
              );
              break;
            default:
              print("Unknown role: $userRole");
          }
        } else {
          print("User role not found");
        }
      } else {
        setState(() {
          _authError = 'Authentication failed. Wrong email or password.';
          _isButtonPressed = false; // Reset it to false in case of failure
        });
      }
    } catch (e) {
      setState(() {
        _authError = 'Authentication failed. Wrong email or password.';
        _isButtonPressed = false; // Reset it to false in case of failure
      });
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          hintText: "Email",
                          labelText: 'Email',
                          contentPadding: EdgeInsets.all(10),
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: const Color(0xFF1CC2CD),
                            ),
                          ),
                          errorText:
                              _emailError.isNotEmpty ? _emailError : null,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  width: 300,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        obscureText: _isObscure,
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          hintText: "Password",
                          contentPadding: const EdgeInsets.all(10),
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isObscure
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                _isObscure = !_isObscure;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: const Color(0xFF1CC2CD),
                            ),
                          ),
                          errorText:
                              _passwordError.isNotEmpty ? _passwordError : null,
                        ),
                      ),
                    ],
                  ),
                ),
                if (_authError.isNotEmpty)
                  Text(
                    _authError,
                    style: TextStyle(color: Colors.red),
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
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: _isButtonPressed
                          ? CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            )
                          : const Text(
                              "Login",
                              style: TextStyle(color: Colors.white),
                            ),
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
