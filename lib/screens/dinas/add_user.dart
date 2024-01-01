import 'package:flutter/material.dart';

class NambahUser extends StatefulWidget {
  const NambahUser({Key? key}) : super(key: key);

  @override
  _NambahUserState createState() => _NambahUserState();
}

class _NambahUserState extends State<NambahUser> {
  String selectedRole = 'siswa'; // Default role
  String? gender;
  final List<String> genderOptions = ["Perempuan", "Laki-laki"];
  bool _isObscure = true;
  bool _isPasswordEightCharacters = false;
  bool _hasPasswordOneNumber = false;

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();

  bool _isRegistering = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambahkan Akun'),
        backgroundColor: Color(0xFF0C356A),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DropdownButton<String>(
                value: selectedRole,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedRole = newValue!;
                  });
                },
                items: <String>['siswa', 'staff', 'dinas'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              if (selectedRole == 'siswa' ||
                  selectedRole == 'staff' ||
                  selectedRole == 'dinas')
                buildForm(),
              if (selectedRole == 'siswa' ||
                  selectedRole == 'staff' ||
                  selectedRole == 'dinas')
                _buildRegistrationButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildForm() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: 300,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildTextFormField(
                hintText: "Nama Lengkap",
                labelText: "Nama Lengkap",
                prefixIcon: Icons.person,
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: buildTextFormField(
                      hintText: "Nomor HP",
                      labelText: "Nomor HP",
                      prefixIcon: Icons.phone,
                    ),
                  ),
                  SizedBox(width: 16), // Adjust the spacing as needed
                  if (selectedRole == 'siswa' ||
                      selectedRole == 'staff' ||
                      selectedRole == 'dinas')
                    Expanded(
                      child: buildTextFormField(
                        hintText:
                            selectedRole == 'staff' || selectedRole == 'dinas'
                                ? "NIP"
                                : "NIS",
                        labelText:
                            selectedRole == 'staff' || selectedRole == 'dinas'
                                ? "NIP"
                                : "NIS",
                        prefixIcon: Icons.school,
                      ),
                    ),
                ],
              ),
              SizedBox(height: 16),
              if (selectedRole == 'siswa' || selectedRole == 'staff')
                buildTextFormField(
                  hintText: "Nama Sekolah",
                  labelText: "Nama Sekolah",
                  prefixIcon: Icons.school,
                ),
              if (selectedRole == 'siswa' || selectedRole == 'staff')
                SizedBox(height: 16),
              buildGenderDropdown(),
              SizedBox(height: 16),
              buildTextFormField(
                hintText: "Email",
                labelText: "Email",
                prefixIcon: Icons.email,
              ),
              SizedBox(height: 16),
              buildPasswordTextFormField(
                onchanged: _onPasswordChanged,
                hintText: "Kata Sandi",
                labelText: "Kata Sandi",
                prefixIcon: Icons.lock,
                obscureText: true,
              ),
              SizedBox(height: 16),
              buildTextFormField(
                hintText: "Konfirmasi Kata Sandi",
                labelText: "Konfirmasi Kata Sandi",
                prefixIcon: Icons.lock,
                obscureText: true,
              ),
              _buildPasswordStrengthIndicator(
                text: "Minimal Memiliki 8 karakter",
                indicator: _isPasswordEightCharacters,
              ),
              _buildPasswordStrengthIndicator(
                text: "Minimal Memiliki 1 Angka",
                indicator: _hasPasswordOneNumber,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextFormField({
    required String hintText,
    required String labelText,
    required IconData prefixIcon,
    bool obscureText = false,
  }) {
    return TextFormField(
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        contentPadding: const EdgeInsets.all(10),
        prefixIcon: Icon(prefixIcon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color(0xFF1CC2CD),
          ),
        ),
      ),
    );
  }

  Widget buildPasswordTextFormField({
    required String hintText,
    required String labelText,
    required IconData prefixIcon,
    required onchanged,
    bool obscureText = false,
  }) {
    return TextFormField(
      obscureText: _isObscure,
      onChanged: (value) {
        _onPasswordChanged(value);
        onchanged(value);
      },
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        contentPadding: const EdgeInsets.all(10),
        prefixIcon: Icon(prefixIcon),
        suffixIcon: IconButton(
          icon: Icon(
            _isObscure ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: _togglePasswordVisibility,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color(0xFF1CC2CD),
          ),
        ),
      ),
    );
  }

  Widget buildGenderDropdown() {
    return SizedBox(
      width: 300,
      child: DropdownButtonFormField<String>(
        value: gender,
        items: genderOptions.map((String option) {
          return DropdownMenuItem<String>(
            value: option,
            child: Text(
              option,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            gender = newValue;
          });
        },
        decoration: InputDecoration(
          hintText: "Pilih Gender",
          contentPadding: EdgeInsets.all(10),
          prefixIcon: const Icon(Icons.person),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
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

  void _signUp(
    String email,
    String password,
    String confirmPassword,
    String username,
  ) {
    // Implement your sign-up logic here
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
}
