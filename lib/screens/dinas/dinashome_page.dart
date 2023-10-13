import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fast_it_2/main.dart';
import 'package:fast_it_2/widgets/build_square.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DinasHomePage extends StatefulWidget {
  const DinasHomePage({Key? key}) : super(key: key);

  @override
  State<DinasHomePage> createState() => _DinasHomePageState();
}

class _DinasHomePageState extends State<DinasHomePage> {
  String username = '';
  String role = '';
  int laporanMasukNotificationCount = 0;

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
        print('Error fetching user data: $e');
      }
    }
  }

  Future<void> showLogoutConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Log Out Confirmation',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'Are you sure you want to log out?',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey, // Text color
                textStyle: const TextStyle(fontSize: 16),
              ),
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.red, // Text color
                textStyle: const TextStyle(fontSize: 16),
              ),
              child: const Text('Log Out'),
              onPressed: () {
                logout(); // Call the logout method
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 10,
          backgroundColor: Colors.white,
        );
      },
    );
  }

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
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Home',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              showLogoutConfirmationDialog(
                  context); // Show the confirmation dialog
            },
            color: Colors.black,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Hi $username',
                style: const TextStyle(fontSize: 18),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                '$role',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search',
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFF1CC2CD),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFF1CC2CD),
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: 16.0,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: screenWidth - 32.0,
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFF1CC2CD),
                    width: 2.0,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 16.0, top: 8.0),
                            child: Text(
                              'Welcome',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF1CC2CD),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 16.0),
                            child: Text(
                              'Facilities Report',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF1CC2CD),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 120,
                      height: 120 - 15.0,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('lib/images/pana.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CustomBubbleSquare(
                        color: const Color(0xFF1CC2CD),
                        icon: Icons.inbox,
                        title: 'Laporan Masuk',
                        width: (screenWidth - 32.0) / 2 - 10,
                        onTap: () {
                          // Handle button press for 'Laporan Terkirim'
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(builder: (context) => Laporan()),
                          // );
                        },
                      ),
                      const SizedBox(width: 8),
                      CustomBubbleSquare(
                        color: const Color(0xFF1CC2CD),
                        icon: Icons.timer,
                        title: 'Dalam Penanganan',
                        width: (screenWidth - 32.0) / 2 - 10,
                        onTap: () {
                          // Handle button press for 'Dalam Penanganan'
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CustomBubbleSquare(
                        color: const Color(0xFF1CC2CD),
                        icon: Icons.assignment_turned_in,
                        title: 'Telah Diperbaiki',
                        width: (screenWidth - 32.0) / 2 - 10,
                        onTap: () {},
                      ),
                      const SizedBox(width: 8),
                      CustomBubbleSquare(
                        color: const Color(0xFF1CC2CD),
                        icon: Icons.add,
                        title: 'Buat Laporan',
                        width: (screenWidth - 32.0) / 2 - 10,
                        onTap: () {
                          // Handle button press for 'Buat Laporan'
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(builder: (context) => Laporan()),
                          // );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
