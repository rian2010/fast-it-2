import 'package:fast_it_2/screens/siswa/services/time_line.dart';
import 'package:flutter/material.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({Key? key}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
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
        title: const Text('Detail'),
        backgroundColor: const Color(0xFF1CC2CD),
      ),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment:
                CrossAxisAlignment.start, // Align content to the left
            children: [
              // Swipeable images
              Container(
                color: Colors.white, // Background color for the main image
                child: Center(
                  child: Container(
                    width:
                        400, // Set a fixed width for the main image container
                    height:
                        250, // Set a fixed height for the main image container
                    child: PageView.builder(
                      itemCount: imagePaths.length,
                      onPageChanged: (index) {
                        setState(() {
                          selectedImageIndex = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        return Image.asset(
                          imagePaths[index], // Display the selected image
                          fit: BoxFit.fill, // Adjust the fit as needed
                        );
                      },
                    ),
                  ),
                ),
              ),
              // Other images
              Container(
                height: 80.0, // Set a fixed height for the image row
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: imagePaths.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedImageIndex =
                              index; // Update the selected image index
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.all(8.0),
                        width:
                            80.0, // Set a fixed width for the image container
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: index == selectedImageIndex
                                ? Colors.blue // Highlight selected image
                                : Colors.transparent,
                            width: 2.0,
                          ),
                        ),
                        child: Image.asset(
                          imagePaths[index], // Display the other images
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
              ),
              // The rest of the page content
              Container(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Ruang Kelas',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 85, 84, 84),
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        'Jenis Kerusakan:', // Add "Jenis Kerusakan" text
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        'Jenis Kerusakan.',
                        style: TextStyle(
                          fontSize: 15.0,
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        'Deskripsi:',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        'Deskripsi',
                        style: TextStyle(
                          fontSize: 15.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Read More button
          Positioned(
            bottom: 20.0,
            left: 16.0,
            right: 16.0,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TimeLine()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1CC2CD), // Button color
                padding: const EdgeInsets.symmetric(
                  vertical: 16.0,
                  horizontal: 32.0,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0), // Circular shape
                ),
              ),
              child: const Text(
                'Lihat Proses', // Button text
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
