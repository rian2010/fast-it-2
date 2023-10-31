import 'package:flutter/material.dart';
import 'package:fast_it_2/screens/siswa/detail.dart';

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
        title: const Text(
          'Status Laporan',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(
                height: 16), // Add padding between AppBar and the content
            // Small buttons using a Row wrapped in SingleChildScrollView
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Text(
                      'Status',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: OutlinedButton(
                      onPressed: () {
                        // Add action for the first button
                      },
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            // Add border radius
                          ),
                        ),
                      ),
                      child: const Text(
                        'Menunggu Verifikasi',
                        style: TextStyle(color: Color(0xFF1CC2CD)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: OutlinedButton(
                      onPressed: () {
                        // Add action for the third button
                      },
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            // Add border radius
                          ),
                        ),
                      ),
                      child: const Text(
                        'Dalam Pengerjaan',
                        style: TextStyle(color: Color(0xFF1CC2CD)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: OutlinedButton(
                      onPressed: () {
                        // Add action for the third button
                      },
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            // Add border radius
                          ),
                        ),
                      ),
                      child: const Text(
                        'Selesai',
                        style: TextStyle(color: Color(0xFF1CC2CD)),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFF1CC2CD), // Set the border color
                    width: 2.0, // Set the border width
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 120,
                      height: 80,
                      margin: const EdgeInsets.all(
                          8.0), // Add a margin to create a gap
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('lib/images/kelas.jpeg'),
                          fit: BoxFit.cover,
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
                              fontSize: 14, // Decrease the font size
                              color: Colors.black, // Text color
                            ),
                          ),
                          Text(
                            'Laporan Kerusakan',
                            style: TextStyle(
                              fontSize: 14, // Decrease the font size
                              color: Colors.black, // Text color
                            ),
                          ),
                          // Add more widgets as needed
                        ],
                      ),
                    ),
                    // Add "See Details" button
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const DetailPage()),
                        );
                      },
                      child: const Text(
                        'See Details',
                        style: TextStyle(
                          color: Color(0xFF1CC2CD), // Set button color
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFF1CC2CD), // Set the border color
                    width: 2.0, // Set the border width
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 120,
                      height: 80,
                      margin: const EdgeInsets.all(
                          8.0), // Add a margin to create a gap
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('lib/images/kelas.jpeg'),
                          fit: BoxFit.cover,
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
                              fontSize: 14, // Decrease the font size
                              color: Colors.black, // Text color
                            ),
                          ),
                          Text(
                            'Laporan Kerusakan',
                            style: TextStyle(
                              fontSize: 14, // Decrease the font size
                              color: Colors.black, // Text color
                            ),
                          ),
                          // Add more widgets as needed
                        ],
                      ),
                    ),
                    // Add "See Details" button
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const DetailPage()),
                        );
                      },
                      child: const Text(
                        'See Details',
                        style: TextStyle(
                          color: Color(0xFF1CC2CD), // Set button color
                        ),
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
