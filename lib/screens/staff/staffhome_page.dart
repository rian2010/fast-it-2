import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fast_it_2/screens/siswa/laporan.dart';
import 'package:fast_it_2/screens/staff/laporan_masuk.dart';
// import 'package:fast_it_2/screens/staff/laporan_masuk.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class StaffPage extends StatefulWidget {
  const StaffPage({Key? key}) : super(key: key);

  @override
  State<StaffPage> createState() => _StaffPageState();
}

class _StaffPageState extends State<StaffPage> {
  String username = '';
  String role = '';

  @override
  void initState() {
    super.initState();
    fetchUserData();
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
            role = userDoc['role'];
          });
        }
      } catch (e) {
        debugPrint('Error fetching user data: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 300,
              width: double.infinity,
              padding: const EdgeInsets.only(left: 25, right: 25, top: 60),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF1CC2CD), Colors.blue],
                ),
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(50.0),
                  bottomLeft: Radius.circular(50.0),
                ),
              ),
              child: Column(
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Selamat Datang',
                            style: TextStyle(color: Colors.white, fontSize: 28),
                          ),
                        ],
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: Icon(
                          Icons.notifications, // Replace with your desired icon
                          color: Colors.white,
                          size: 30, // Adjust the icon size as needed
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hi, ${username.toUpperCase()}👋',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 16.5),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            role,
                            style: const TextStyle(
                                color: Color.fromARGB(255, 224, 217, 217)),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          // Handle button press for 'Laporan Terkirim'
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Laporan()),
                          );
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    color: const Color(
                                        0xFF1CCDB5), // Background color
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: 20, // Adjust the icon size as needed
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 4,
                            ), // Add spacing between the icon and text
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LaporanMasuk(),
                            ),
                          );
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                color:
                                    const Color(0xFF1CCDB5), // Background color
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.inbox,
                                  color: Colors.white,
                                  size: 20, // Adjust the icon size as needed
                                ),
                              ),
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: Container(
                                width: 20,
                                height: 20,
                                decoration: const BoxDecoration(
                                  color: Colors
                                      .red, // Customize the badge background color
                                  shape: BoxShape.circle,
                                ),
                                child: const Center(
                                  child: Text(
                                    '4', // The badge text
                                    style: TextStyle(
                                      color: Colors
                                          .white, // Customize the text color
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  color: const Color(
                                      0xFF1CCDB5), // Background color
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              const Icon(
                                Icons.timer,
                                color: Colors.white,
                                size: 20, // Adjust the icon size as needed
                              ),
                            ],
                          ),
                          const SizedBox(
                              height:
                                  4), // Add spacing between the icon and text
                        ],
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  color: const Color(
                                      0xFF1CCDB5), // Background color
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              const Icon(
                                Icons.assignment_turned_in,
                                color: Colors.white,
                                size: 20, // Adjust the icon size as needed
                              ),
                            ],
                          ),
                          const SizedBox(
                              height:
                                  4), // Add spacing between the icon and text
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Transform.translate(
              offset: const Offset(0, -35),
              child: Container(
                height: 60,
                padding: const EdgeInsets.only(left: 20, top: 8),
                margin: const EdgeInsets.symmetric(horizontal: 25),
                decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 20.0,
                        offset: Offset(0, 10.0),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(5.0),
                    color: Colors.white),
                child: const TextField(
                  decoration: InputDecoration(
                      suffixIcon: Icon(
                        Icons.search,
                        color: Colors.black,
                        size: 20.0,
                      ),
                      border: InputBorder.none,
                      hintText: 'Search'),
                ),
              ),
            ),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Laporan', // Add your text here
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
