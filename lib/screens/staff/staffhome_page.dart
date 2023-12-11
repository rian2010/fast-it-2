import 'package:fast_it_2/components/card/progress_laporan.dart';
import 'package:fast_it_2/components/detail/dalam_pengerjaan.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fast_it_2/components/laporan/laporan.dart';
import 'package:fast_it_2/components/laporan/laporan_selesai.dart';
import 'package:fast_it_2/screens/staff/laporan_masuk.dart';
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
  int newReportsCount = 0;

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
            // Header Section
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
                          Icons.notifications,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hi, ${username.toUpperCase()}👋',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Buttons Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildMenuButton(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Laporan(),
                            ),
                          );
                        },
                        icon: Icons.add,
                        label: 'Buat \n Laporan',
                      ),
                      _buildMenuButton(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LaporanMasuk(),
                            ),
                          );
                        },
                        icon: Icons.inbox,
                        label: 'Laporan\nMasuk',
                        badgeCount: newReportsCount,
                      ),
                      _buildMenuButton(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DalamPengerjaan(),
                            ),
                          );
                        },
                        icon: Icons.timer,
                        label: 'Dalam\nPengerjaan',
                      ),
                      _buildMenuButton(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LaporanSelesai(),
                            ),
                          );
                        },
                        icon: Icons.assignment_turned_in,
                        label: 'Laporan \n Selesai',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Search Section
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
                  color: Colors.white,
                ),
                child: const TextField(
                  decoration: InputDecoration(
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
            // Laporan Masuk Section
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Row(
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Laporan Masuk',
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
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LaporanMasuk(),
                          ),
                        );
                        // markLaporanMasukPageOpened();
                        setState(() {
                          newReportsCount = 0;
                        });
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Lebih Banyak',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF0C356A),
                                ),
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
            ProgresLaporan(
              userRole: 'staff',
            )
          ],
        ),
      ),
    );
  }

  // Helper method to build individual menu buttons
  Widget _buildMenuButton({
    required VoidCallback onTap,
    required IconData icon,
    required String label,
    int? badgeCount,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Align(
        alignment: Alignment.center,
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
                    color: const Color(0xFF7895CB),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                Icon(
                  icon,
                  color: Colors.white,
                  size: 20,
                ),
                if (badgeCount != null && badgeCount > 0)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          badgeCount.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
