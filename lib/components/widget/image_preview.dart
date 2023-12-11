import 'dart:io';
import 'package:flutter/material.dart';

class ImagePreviewScreen extends StatelessWidget {
  final File? imageFile;

  ImagePreviewScreen({required this.imageFile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Customize the app bar as needed
        title: const Text('Foto Profil'),
        backgroundColor: Colors.black,
        actions: [
          IconButton(icon: const Icon(Icons.edit), onPressed: () {}),
        ],
      ),
      backgroundColor: Colors.black,
      body: Dismissible(
        direction: DismissDirection.vertical,
        key: const Key('key'),
        onDismissed: (_) => Navigator.of(context).pop(),
        child: Center(
          child: Hero(
            tag:
                'profileImageHero', // Make sure the tag is unique within the app
            child: Container(
              width: double.infinity,
              height: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 125),
              child: imageFile != null
                  ? Image.file(
                      imageFile!,
                      fit: BoxFit.cover, // Adjust the fit property
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
    );
  }
}
