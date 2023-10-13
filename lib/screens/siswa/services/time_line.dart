import 'package:flutter/material.dart';
import 'package:fast_it_2/utils/package.dart';

class TimeLine extends StatefulWidget {
  const TimeLine({super.key});

  @override
  State<TimeLine> createState() => _TimeLineState();
}

class _TimeLineState extends State<TimeLine> {
  int selectedImageIndex = 0; // Index of the selected image

  // List of image paths
  List<String> imagePaths = [
    'lib/images/kelas.jpeg', // Main image
    'lib/images/pana.png', // Other images
    'lib/images/tree.jpg',
    'lib/images/random.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Proses'),
        backgroundColor: const Color(0xFF1CC2CD),
      ),
      body: SingleChildScrollView(
        // Wrap the Column with SingleChildScrollView
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Swipeable images
            Container(
              color: Colors.white,
              child: Center(
                child: Container(
                  width: 400,
                  height: 250,
                  child: PageView.builder(
                    itemCount: imagePaths.length,
                    onPageChanged: (index) {
                      setState(() {
                        selectedImageIndex = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      return Image.asset(
                        imagePaths[index],
                        fit: BoxFit.fill,
                      );
                    },
                  ),
                ),
              ),
            ),

            // Other images
            Container(
              height: 80.0,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: imagePaths.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedImageIndex = index;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.all(8.0),
                      width: 80.0,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: index == selectedImageIndex
                              ? Colors.blue
                              : Colors.transparent,
                          width: 2.0,
                        ),
                      ),
                      child: Image.asset(
                        imagePaths[index],
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),

            // The rest of the page content
            // ... (existing code)

            // Add your PackageDeliveryTrackingPage here
            PackageDeliveryTrackingPage(),
          ],
        ),
      ),
    );
  }
}
