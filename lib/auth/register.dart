import 'package:fast_it_2/auth/services/services.dart';
import 'package:fast_it_2/screens/siswa/mainpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Registration extends StatefulWidget {
  const Registration({Key? key}) : super(key: key);

  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final String _defaultRole = 'Siswa';
  bool _isObscure = true;
  bool _isPasswordEightCharacters = false;
  bool _hasPasswordOneNumber = false;
  bool _isRegistering = false;
  OverlayEntry? _overlayEntry;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseService _firebaseService = FirebaseService();

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isObscure = !_isObscure;
    });
  }

  void _onPasswordChanged(String password) {
    final numericRegex = RegExp(r'[0-9]');

    setState(() {
      _isPasswordEightCharacters = password.length >= 8;
      _hasPasswordOneNumber = numericRegex.hasMatch(password);
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

  void _removeLoadingOverlay() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }
  }

  String? _validateNotEmpty(String? value) {
    if (value == null || value.isEmpty) {
      return 'Form ini wajib diisi';
    }
    return null;
  }

  String? _validatePasswordConfirmation(String? value) {
    if (value != _passwordController.text) {
      return 'Kata sandi tidak sama';
    }
    return null;
  }

  Future<bool> _isEmailInUse(String email) async {
    try {
      final result =
          await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
      return result.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  void _signUp(String email, String password, String confirmPassword,
      String username) async {
    print('Attempting to sign up...');

    if (_formKey.currentState!.validate()) {
      // Check password requirements
      if (!_isPasswordEightCharacters || !_hasPasswordOneNumber) {
        setState(() {
          _isRegistering = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Kata sandi harus memiliki minimal 8 karakter dan setidaknya 1 angka.'),
          ),
        );
        return;
      }

      if (_formKey.currentState!.validate()) {
        // Check email format
        if (_validateNotEmpty(email) != null ||
            !RegExp(r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b')
                .hasMatch(email)) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Email yang digunakan tidak valid!.'),
            ),
          );
          return;
        }
      }
      _showLoadingOverlay();
      setState(() {
        _isRegistering = true;
      });

      if (password == confirmPassword) {
        try {
          // Check if the email is already in use
          bool isEmailInUse = await _isEmailInUse(email);

          if (isEmailInUse) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Email sudah digunakan oleh akun lain.'),
              ),
            );
          } else {
            User? user =
                await _firebaseService.signUp(email, password, username);

            if (user != null) {
              if (_defaultRole == 'Siswa') {
                _completeSignup();
              } else {
                debugPrint("Unknown role: $_defaultRole");
              }
            }
          }
        } catch (e) {
          debugPrint("Registration error: $e");
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content:
                  Text('Terjadi kesalahan saat mendaftar. Silakan coba lagi.'),
            ),
          );
        } finally {
          _removeLoadingOverlay();
          setState(() {
            _isRegistering = false;
          });
        }
      } else {
        debugPrint("Kata sandi tidak sama");
        setState(() {
          _isRegistering = false;
        });
      }
    }
  }

  void _completeSignup() {
    Navigator.push<void>(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => const Dashboard(),
      ),
    );
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
        title: const Text(
          'Daftar Akun',
          style: TextStyle(
            color: Color.fromARGB(255, 76, 74, 74),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: 300,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: _usernameController,
                          decoration: InputDecoration(
                            hintText: "Nama Lengkap",
                            labelText: 'Nama Lengkap',
                            contentPadding: const EdgeInsets.all(10),
                            prefixIcon: const Icon(Icons.person),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Color(0xFF1CC2CD),
                              ),
                            ),
                          ),
                          validator: _validateNotEmpty,
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
                          controller: _emailController,
                          decoration: InputDecoration(
                            hintText: 'Email',
                            labelText: 'Email',
                            contentPadding: const EdgeInsets.all(10),
                            prefixIcon: const Icon(Icons.mail),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Color(0xFF1CC2CD),
                              ),
                            ),
                          ),
                          validator: _validateNotEmpty,
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
                          onChanged: _onPasswordChanged,
                          obscureText: _isObscure,
                          controller: _passwordController,
                          decoration: InputDecoration(
                            hintText: 'Kata Sandi',
                            labelText: 'Kata Sandi',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Color(0xFF1CC2CD),
                              ),
                            ),
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
                          validator: _validateNotEmpty,
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
                          controller: _confirmPasswordController,
                          decoration: InputDecoration(
                            hintText: "Konfirmasi Kata Sandi",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Color(0xFF1CC2CD),
                              ),
                            ),
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
                          validator: _validatePasswordConfirmation,
                        ),
                      ],
                    ),
                  ),
                  _buildPasswordStrengthIndicator(
                    text: "Minimal Memiliki 8 karakter",
                    indicator: _isPasswordEightCharacters,
                  ),
                  _buildPasswordStrengthIndicator(
                    text: "Minimal Memiliki 1 Angka",
                    indicator: _hasPasswordOneNumber,
                  ),
                  const SizedBox(height: 10),
                  _buildRegistrationButton(),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordStrengthIndicator({
    required String text,
    required bool indicator,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: indicator ? Colors.green : Colors.transparent,
              border: indicator
                  ? Border.all(color: Colors.transparent)
                  : Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(50),
            ),
            child: indicator
                ? const Center(
                    child: Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 15,
                    ),
                  )
                : null,
          ),
          const SizedBox(
            width: 10,
          ),
          Text(text),
        ],
      ),
    );
  }

  Widget _buildRegistrationButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Container(
        child: MaterialButton(
          minWidth: double.infinity,
          height: 60,
          onPressed: _isRegistering
              ? null
              : () async {
                  String email = _emailController.text.trim();
                  String password = _passwordController.text.trim();
                  String confirmPassword =
                      _confirmPasswordController.text.trim();
                  String username = _usernameController.text.trim();

                  _signUp(email, password, confirmPassword, username);
                },
          color: const Color(0xFF0C356A),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: _isRegistering
                ? const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  )
                : const Text(
                    "Daftar",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
