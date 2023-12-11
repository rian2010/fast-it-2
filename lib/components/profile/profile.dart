import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:fast_it_2/components/profile/update_profile.dart';
import 'package:fast_it_2/components/widget/image_preview.dart';
import 'package:fast_it_2/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String username = '';
  String email = '';
  File? returnedImage;

  void logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const WelcomePage()),
        (route) => false,
      );
    } catch (e) {
      print('Error logging out: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    // Fetch the username from Firestore when the widget is first created
    fetchUserData();
    loadSavedImage();
  }

  Future<void> fetchUserData() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .get();

        if (userDoc.exists) {
          setState(() {
            username = userDoc['username'];
            email = userDoc['email'];
          });
        }
      } catch (e) {
        debugPrint('Error fetching user data: $e');
      }
    }
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

  // Dummy logout method, replace it with your actual logout logic

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
                _pickImage(
                    ImageSource.gallery); // Call _pickImage with gallery source
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('Ambil foto'),
              onTap: () {
                _pickImage(
                    ImageSource.camera); // Call _pickImage with camera source
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  // Method to pick an image from the gallery or camera
  void _pickImage(ImageSource source) async {
    final picker = ImagePicker();

    try {
      final pickedFile = await picker.pickImage(source: source);

      if (pickedFile != null) {
        // Handle the picked image file
        // You can use the pickedFile.path or other properties as needed
        setState(() {
          returnedImage = File(pickedFile.path);
        });

        saveImagePath(pickedFile.path);
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  void navigateToImagePreview() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ImagePreviewScreen(imageFile: returnedImage),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    loadSavedImage();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profil',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF0C356A),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
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
                                  tag:
                                      'profileImageHero', // Make sure the tag is unique within the app
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
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              username,
              style: const TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              email,
              style: const TextStyle(
                fontSize: 16.0,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.key),
              title: const Text('Akun'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UpdateProfile(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Keluar'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                AwesomeDialog(
                  context: context,
                  dialogType: DialogType.warning,
                  headerAnimationLoop: false,
                  animType: AnimType.bottomSlide,
                  title: 'Keluar?',
                  titleTextStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      // color: Colors.grey,
                      fontSize: 25),
                  desc: 'Konfimasi tindakan',
                  descTextStyle: TextStyle(color: Colors.grey),
                  buttonsTextStyle: const TextStyle(color: Colors.white),
                  showCloseIcon: true,
                  btnCancelOnPress: () {},
                  btnOkOnPress: () {
                    debugPrint('Berhasil keluar');
                    logout();
                  },
                  btnOkColor: const Color(0xFF0C356A),
                  btnCancelColor: const Color(0xFFCD1C1C),
                ).show();
              },
            )
          ],
        ),
      ),
    );
  }
}
