import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:fast_it_2/components/widget/image_preview.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({super.key});

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  File? returnedImage;
  bool isEditing = false; // Track whether the user is in editing mode or not
  String selectedRole = 'Teacher';
  String selectedGrade = 'Grade 10';

  @override
  void initState() {
    super.initState();
    // Load the saved image path from SharedPreferences
    loadSavedImage();
  }

  // Load the saved image path from SharedPreferences
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

  Widget buildTextField({
    required String hintText,
    required String labelText,
  }) {
    return SizedBox(
      width: 300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            enabled: isEditing, // Set enabled based on isEditing
            readOnly: !isEditing, // Set readOnly based on isEditing
            decoration: InputDecoration(
              hintText: hintText,
              labelText: labelText,
              contentPadding: const EdgeInsets.all(10),
              prefixIcon: const Icon(Icons.person),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: Color(0xFF1CC2CD),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget buildDropdown({
    required String hintText,
    required String labelText,
    required List<String> items,
    required String selectedValue,
    required ValueChanged<String> onChanged,
  }) {
    return SizedBox(
      width: 300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownButtonFormField<String>(
            value: selectedValue,
            items: items.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            decoration: InputDecoration(
              hintText: hintText,
              labelText: labelText,
              contentPadding: const EdgeInsets.all(10),
              prefixIcon: const Icon(Icons.arrow_drop_down),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: Color(0xFF1CC2CD),
                ),
              ),
            ),
            onChanged: (String? value) {},
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

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
                isEditing = true; // Enable editing mode
              });
            },
          ),
        ],
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
            buildTextField(
              hintText: 'Nama',
              labelText: 'Nama',
            ),
            buildTextField(
              hintText: 'NIP/NIS/NIK',
              labelText: 'NIP/NIS/NIK',
            ),
            buildTextField(
              hintText: 'Nama Sekolah',
              labelText: 'Nama Sekolah',
            ),
            buildTextField(
              hintText: 'No. Hp',
              labelText: 'No. Hp',
            ),
            buildDropdown(
              hintText: 'Sekolah',
              labelText: 'Sekolah',
              items: [],
              selectedValue: selectedRole,
              onChanged: (value) {
                setState(() {
                  selectedRole = value;
                });
              },
            ),
            buildDropdown(
              hintText: 'Kelas',
              labelText: 'Kelas',
              items: ['Grade 10', 'Grade 11', 'Grade 12'],
              selectedValue: selectedGrade,
              onChanged: (value) {
                setState(() {
                  selectedGrade = value;
                });
              },
            ),

            // Add more fields as needed
            ElevatedButton(
              onPressed: () {
                setState(() {
                  isEditing = false; // Disable editing mode
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
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    const Color(0xFF0C356A), // Original button color
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
            const SizedBox(height: 18)
          ],
        ),
      ),
    );
  }
}
