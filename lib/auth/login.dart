import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:fast_it_2/auth/register.dart';
import 'package:fast_it_2/screens/dinas/main_dinas.dart';
import 'package:fast_it_2/screens/siswa/mainpage.dart';
import 'package:fast_it_2/screens/staff/main_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isObscure = true;
  bool _isButtonPressed = false;
  String _emailError = '';
  String _passwordError = '';
  String _authError = '';
  bool _rememberMe = false;
  OverlayEntry? _overlayEntry;

  void _togglePasswordVisibility() {
    setState(() {
      _isObscure = !_isObscure;
    });
  }

  void _showLoadingOverlay() {
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned.fill(
        child: Container(
          color: Colors.black.withOpacity(0.5),
          child: const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hideLoadingOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  Future<void> _signInWithEmailAndPassword() async {
    if (_isButtonPressed) return;

    setState(() {
      _isButtonPressed = true;
      _emailError = '';
      _passwordError = '';
      _authError = '';
    });

    _showLoadingOverlay(); // Show loading overlay

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _emailError = email.isEmpty ? 'Email tidak boleh kosong' : '';
        _passwordError =
            password.isEmpty ? 'Kata sandi tidak boleh kosong' : '';
        _isButtonPressed = false;
      });
      _hideLoadingOverlay(); // Hide loading overlay
      return;
    }

    try {
      // Hash the entered password
      String hashedPassword = sha256.convert(utf8.encode(password)).toString();

      // Use the hashed password for authentication
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: hashedPassword,
      );

      if (userCredential.user != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('email', email);
        await prefs.setBool('rememberMe', _rememberMe);

        // Check the user's role
        final userSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .get();

        if (userSnapshot.exists) {
          String userRole = userSnapshot.get('role');

          // Based on the role, navigate to the appropriate page
          switch (userRole) {
            case 'Siswa':
              _navigateToDashboard();
              break;
            case 'Staff':
              _navigateToStaffHomePage();
              break;
            case 'Dinas':
              _navigateToDinasPage();
              break;
            default:
              debugPrint("Unknown role: $userRole");
          }
        } else {
          debugPrint("User role not found");
        }
      } else {
        setState(() {
          _authError = 'Autentikasi gagal.';
          _isButtonPressed = false;
        });
      }
    } catch (e) {
      setState(() {
        _authError = 'Autentikasi gagal.';
        _isButtonPressed = false;
      });
      debugPrint("Error: $e");
    } finally {
      _hideLoadingOverlay(); // Hide loading overlay
    }
  }

  Future<bool> _isEmailRegistered(String email) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get();

    return querySnapshot.docs.isNotEmpty;
  }

  void _navigateToDashboard() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const Dashboard(),
      ),
    );
  }

  void _navigateToStaffHomePage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const StaffHomePage(),
      ),
    );
  }

  void _navigateToDinasPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const DinasPage(),
      ),
    );
  }

  void _loadRememberMeOption() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _rememberMe = prefs.getBool('rememberMe') ?? false;
    });
  }

  void _loadSavedEmail() async {
    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString('email');
    if (savedEmail != null) {
      setState(() {
        _emailController.text = savedEmail;
      });
    }
  }

  void _saveRememberMeOption() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('rememberMe', _rememberMe);
  }

  @override
  void initState() {
    super.initState();
    _loadRememberMeOption();
    _loadSavedEmail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
          color: Colors.black,
        ),
        title: const Text(''),
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      "Masuk",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 300,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              hintText: "Email",
                              labelText: 'Email',
                              contentPadding: const EdgeInsets.all(10),
                              prefixIcon: const Icon(Icons.person),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Color(0xFF1CC2CD),
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
                    SizedBox(
                      width: 300,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            obscureText: _isObscure,
                            controller: _passwordController,
                            decoration: InputDecoration(
                              labelText: 'Kata Sandi',
                              hintText: "Kata Sandi",
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
                                    _togglePasswordVisibility();
                                  });
                                },
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Color(0xFF1CC2CD),
                                ),
                              ),
                              errorText: _passwordError.isNotEmpty
                                  ? _passwordError
                                  : null,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (_authError.isNotEmpty)
                      Text(
                        _authError,
                        style: const TextStyle(color: Colors.red),
                      ),
                    const SizedBox(height: 5),
                    Row(
                      children: <Widget>[
                        Transform.scale(
                          scale: 1.3,
                          child: Checkbox(
                            activeColor: Colors.blueGrey,
                            shape: const CircleBorder(),
                            value: _rememberMe,
                            onChanged: (value) {
                              setState(() {
                                _rememberMe = value!;
                                _saveRememberMeOption();
                              });
                            },
                          ),
                        ),
                        const Text("Ingat Saya"),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Container(
                        child: MaterialButton(
                          minWidth: double.infinity,
                          height: 60,
                          onPressed: () {
                            _signInWithEmailAndPassword();
                          },
                          color: const Color(0xFF0C356A),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: const Text(
                            "Masuk",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text(
                          "Tidak memiliki akun? ",
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Registration(),
                              ),
                            );
                          },
                          child: const Text(
                            "Daftar disini.",
                            style: TextStyle(
                              color: Color.fromARGB(255, 28, 144, 152),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
