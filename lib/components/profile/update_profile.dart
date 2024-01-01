// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fast_it_2/components/widget/image_preview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({Key? key}) : super(key: key);

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  File? returnedImage;
  bool isEditing = false;
  String selectedSchool = '';

  String? currentUserRole;
  String? currentUserName;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  TextEditingController namaController = TextEditingController();
  TextEditingController nipController = TextEditingController();
  TextEditingController noHpController = TextEditingController();
  TextEditingController sekolahController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadSavedImage();
    fetchUserData();
  }

  void loadSavedImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? imagePath = prefs.getString('user_image_path');

    if (imagePath != null) {
      setState(() {
        returnedImage = File(imagePath);
      });
    }
  }

  void saveImagePath(String imagePath) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('user_image_path', imagePath);
  }

  void showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Ambil dari galeri'),
              onTap: () {
                _pickImage(ImageSource.gallery);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('Ambil foto'),
              onTap: () {
                _pickImage(ImageSource.camera);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _pickImage(ImageSource source) async {
    final picker = ImagePicker();

    try {
      final pickedFile = await picker.pickImage(source: source);

      if (pickedFile != null) {
        setState(() {
          returnedImage = File(pickedFile.path);
        });

        saveImagePath(pickedFile.path);
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  void navigateToImagePreview() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ImagePreviewScreen(imageFile: returnedImage),
      ),
    );
  }

  void fetchUserData() async {
    try {
      User? user = _auth.currentUser;

      if (user != null) {
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(user.uid).get();

        setState(() {
          currentUserRole = userDoc['role'];
          currentUserName = userDoc['username'];
          namaController.text = currentUserName ?? '';
          nipController.text = userDoc['nip'] ?? '';
          noHpController.text = userDoc['noHp'] ?? '';
          sekolahController.text = userDoc['sekolah'] ?? '';
        });
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  bool hasUnsavedChanges() {
    // Check if there are unsaved changes in the form
    // For example, you can check if the text controllers have non-empty values
    return namaController.text.isNotEmpty ||
        nipController.text.isNotEmpty ||
        noHpController.text.isEmpty;
    // sekolahController != null;
  }

  Future<bool> _onWillPop() async {
    if (hasUnsavedChanges()) {
      // Show a confirmation dialog if there are unsaved changes
      return await AwesomeDialog(
                  context: context,
                  dialogType: DialogType.warning,
                  animType: AnimType.bottomSlide,
                  title: 'Perubahan yang Anda buat belum disimpan.',
                  titleTextStyle:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  desc: 'Apakah Anda yakin ingin keluar? ',
                  descTextStyle: TextStyle(fontWeight: FontWeight.normal),
                  btnCancelOnPress: () =>
                      () => Navigator.of(context).pop(false),
                  btnOkOnPress: () => Navigator.of(context).pop(true),
                  btnCancelText: 'Batal',
                  btnOkColor: Color(0xFF0C356A))
              .show() ??
          false;
    }
    return true;
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Perbarui',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF0C356A),
        elevation: 0.0,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              setState(() {
                isEditing = true;
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.325,
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 40.0),
                      child: Container(
                        height: MediaQuery.of(context).size.height,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.elliptical(
                                MediaQuery.of(context).size.width * 0.5, 50.0),
                            bottomRight: Radius.elliptical(
                                MediaQuery.of(context).size.width * 0.5, 50.0),
                          ),
                          color: const Color(0xFF0C356A),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                                child: GestureDetector(
                                  onTap: navigateToImagePreview,
                                  child: Hero(
                                    tag: 'profileImageHero',
                                    child: CircleAvatar(
                                      radius: 70,
                                      backgroundColor: Colors.grey,
                                      child: returnedImage != null
                                          ? ClipOval(
                                              child: Image.file(
                                                returnedImage!,
                                                fit: BoxFit.cover,
                                                width: 140,
                                                height: 140,
                                              ),
                                            )
                                          : const Icon(
                                              Icons.person,
                                              size: 100,
                                              color: Colors.white,
                                            ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 4,
                                right: 4,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                  ),
                                  child: GestureDetector(
                                    onTap: showImagePickerOptions,
                                    child: const CircleAvatar(
                                      backgroundColor: Color(0xff0C356A),
                                      radius: 18,
                                      child: Icon(
                                        Icons.camera_alt,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: 300,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: namaController,
                      enabled: isEditing,
                      readOnly: !isEditing,
                      decoration: InputDecoration(
                        hintText: 'Nama',
                        labelText: 'Nama',
                        contentPadding: const EdgeInsets.all(10),
                        prefixIcon: const Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Color(0xFF1CC2CD),
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nama tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              // Display the "NIP/NIS/NIK" field
              SizedBox(
                width: 300,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: nipController,
                      enabled: isEditing,
                      readOnly: !isEditing,
                      decoration: InputDecoration(
                        hintText: 'NIP/NIS/NIK',
                        labelText: 'NIP/NIS/NIK',
                        contentPadding: const EdgeInsets.all(10),
                        prefixIcon: const Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Color(0xFF1CC2CD),
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'NIP/NIS/NIK tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              // Display the "No. Hp" field
              SizedBox(
                width: 300,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: noHpController,
                      enabled: isEditing,
                      readOnly: !isEditing,
                      decoration: InputDecoration(
                        hintText: 'No HP',
                        labelText: 'No HP',
                        contentPadding: const EdgeInsets.all(10),
                        prefixIcon: const Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Color(0xFF1CC2CD),
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'No HP tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              // Display the "Sekolah" dropdown
              if (currentUserRole != 'Dinas')
                SizedBox(
                  width: 300,
                  child: buildDropdown('Sekolah'),
                ),
              const SizedBox(height: 18),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    setState(() {
                      isEditing = false;
                    });

                    // Extract values from controllers
                    String nama = namaController.text;
                    String nip = nipController.text;
                    String noHp = noHpController.text;
                    String selectedSekolah = sekolahController.text;

                    try {
                      // Get the current user
                      User? user = _auth.currentUser;

                      if (user != null) {
                        // Update user data in Firestore
                        await _firestore
                            .collection('users')
                            .doc(user.uid)
                            .update({
                          'username': nama,
                          'nip': nip,
                          'noHp': noHp,
                          'sekolah': selectedSekolah,
                          // Add other fields as needed
                        });

                        AwesomeDialog(
                          context: context,
                          animType: AnimType.leftSlide,
                          headerAnimationLoop: false,
                          dialogType: DialogType.success,
                          showCloseIcon: true,
                          title: 'Berhasil',
                          desc: 'Berhasil Diperbarui',
                          btnOkOnPress: () {},
                          btnOkIcon: Icons.check_circle,
                          onDismissCallback: (type) {},
                        ).show();
                      }
                    } catch (e) {
                      print('Error updating user data: $e');
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0C356A),
                  padding: const EdgeInsets.symmetric(
                    vertical: 16.0,
                    horizontal: 32.0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                ),
                child: const Text(
                  'Perbarui',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
              ),
              const SizedBox(height: 18),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDropdown(String labelText) {
    return IgnorePointer(
      ignoring: !isEditing,
      child: DropdownButtonFormField<String>(
        value: selectedSchool.isNotEmpty ? selectedSchool : null,
        items: ['SMA 1', 'SMA 3', 'SMK 1']
            .map((school) => DropdownMenuItem<String>(
                  value: school,
                  child: Text(school),
                ))
            .toList(),
        onChanged: isEditing
            ? (value) {
                setState(() {
                  selectedSchool = value ?? '';
                });
              }
            : null,
        // Update the TextEditingController when the value changes
        onSaved: (value) {
          sekolahController.text = value ?? '';
        },
        decoration: InputDecoration(
          labelText: labelText,
          contentPadding: const EdgeInsets.all(10),
          prefixIcon: const Icon(Icons.school),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Color(0xFF1CC2CD),
            ),
          ),
        ),
      ),
    );
  }
}
