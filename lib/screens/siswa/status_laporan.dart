import 'package:flutter/material.dart';

class StatusLaporan extends StatefulWidget {
  const StatusLaporan({super.key});

  @override
  State<StatusLaporan> createState() => _StatusLaporanState();
}

class _StatusLaporanState extends State<StatusLaporan> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('tes'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(
                height: 16), // Add padding between AppBar and the content
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: const Color(0xFF1CC2CD), // Set the background color
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment
                      .center, // Center the content horizontally
                  children: [
                    Container(
                      width: 120,
                      height:
                          120, // Set the image height to match the container's height
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          bottomLeft: Radius.circular(16),
                        ),
                        image: DecorationImage(
                          image: AssetImage('lib/images/kelas.jpeg'),
                          fit: BoxFit
                              .cover, // Make the image cover the container
                        ),
                      ),
                    ),
                    const SizedBox(
                        width: 16), // Add some space between image and text
                    const Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white, // Text color
                            ),
                          ),
                          Text(
                            'Laporan Kerusakan',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white, // Text color
                            ),
                          ),
                          // Add more widgets as needed
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
