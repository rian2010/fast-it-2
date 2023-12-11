import 'package:fast_it_2/components/card/card_status.dart';
import 'package:fast_it_2/components/detail/dalam_pengerjaan.dart';
import 'package:fast_it_2/components/laporan/laporan_selesai.dart';
import 'package:fast_it_2/components/laporan/laporan.dart';
import 'package:fast_it_2/components/widget/notification.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String username = '';
  String role = ''; // Initialize username as an empty string
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Fetch the username from Firestore when the widget is first created
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
        } else {
          debugPrint('User document does not exist in Firestore.');
        }
      } catch (e) {
        debugPrint('Error fetching user data: $e');
      }
    } else {
      debugPrint('User is not signed in.');
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
                color: Color(0xFF0C356A),
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(50.0),
                  bottomLeft: Radius.circular(50.0),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Selamat Datang',
                            style: TextStyle(color: Colors.white, fontSize: 28),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NotificationPage(),
                            ),
                          );
                        },
                        child: const Align(
                          alignment: Alignment.topRight,
                          child: Icon(
                            Icons
                                .notifications, // Replace with your desired icon
                            color: Colors.white,
                            size: 30, // Adjust the icon size as needed
                          ),
                        ),
                      )
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
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Laporan()));
                        },
                        child: Column(
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  width: 75,
                                  height: 75,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    color: const Color(
                                        0xFF7895CB), // Background color
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.add,
                                      color: Colors.white,
                                      size:
                                          30, // Adjust the icon size as needed
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Buat Laporan',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors
                                    .white, // Change the text color as needed
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const DalamPengerjaan(),
                            ),
                          );
                        },
                        child: Column(
                          children: [
                            Column(
                              children: [
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Container(
                                      width: 75,
                                      height: 75,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        color: const Color(
                                            0xFF7895CB), // Background color
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    const Icon(
                                      Icons.timer,
                                      color: Colors.white,
                                      size:
                                          30, // Adjust the icon size as needed
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Dalam Pengerjaan',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors
                                        .white, // Change the text color as needed
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(
                                    height:
                                        4), // Add spacing between the icon and text
                              ],
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LaporanSelesai(),
                            ),
                          );
                        },
                        child: Column(
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  width: 75,
                                  height: 75,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    color: const Color(
                                        0xFF7895CB), // Background color
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                const Icon(
                                  Icons.verified,
                                  color: Colors.white,
                                  size: 30, // Adjust the icon size as needed
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Laporan Selesai',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors
                                    .white, // Change the text color as needed
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(
                                height:
                                    4), // Add spacing between the icon and text
                          ],
                        ),
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
                child: TextField(
                  focusNode: _searchFocusNode,
                  decoration: const InputDecoration(
                    suffixIcon: Icon(
                      Icons.search,
                      color: Colors.black,
                      size: 20.0,
                    ),
                    border: InputBorder.none,
                    hintText: 'Search',
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Row(
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Laporan Kamu', // Add your text here
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {},
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Lebih Banyak', // Add your text here
                                style: TextStyle(
                                    fontSize: 13, color: Color(0xFF0C356A)),
                                textAlign: TextAlign.end,
                              ),
                            ],
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: Color(0xFF0C356A),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            CardStatus()
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Dispose of the focus node when the widget is disposed
    _searchFocusNode.dispose();
    super.dispose();
  }
}
