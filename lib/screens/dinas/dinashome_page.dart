import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fast_it_2/components/card/progress_laporan.dart';
import 'package:fast_it_2/components/detail/detail_laporan_selesai.dart';
import 'package:fast_it_2/components/laporan/laporan_masuk.dart';
import 'package:fast_it_2/screens/dinas/dalam_pengerjaan.dart';
import 'package:fast_it_2/screens/dinas/user_list.dart';
// import 'package:fast_it_2/screens/staff/laporan_masuk.dart';
import 'package:fast_it_2/components/widget/notification.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DinasHomePage extends StatefulWidget {
  const DinasHomePage({Key? key}) : super(key: key);

  @override
  State<DinasHomePage> createState() => _DinasHomePageState();
}

class _DinasHomePageState extends State<DinasHomePage> {
  String username = '';
  String role = '';
  int newReportsCount = 0;

  @override
  void initState() {
    super.initState();
    fetchUserData();
    checkIfLaporanMasukPageOpened();
  }

  Future<void> fetchUserData() async {
    var currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .get();

        if (userDoc.exists) {
          setState(() {
            username = userDoc['username'];
          });
        }
      } catch (e) {
        print('Error fetching user data: $e');
      }
    }
  }

  Future<void> checkIfLaporanMasukPageOpened() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool laporanMasukPageOpened =
        prefs.getBool('laporanMasukPageOpened') ?? false;

    if (!laporanMasukPageOpened) {
      listenForNewReports();
    }
  }

  void markLaporanMasukPageOpened() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('laporanMasukPageOpened', true);
  }

  void listenForNewReports() {
    FirebaseFirestore.instance
        .collection('reports')
        .snapshots()
        .listen((event) {
      setState(() {
        allReports = event.docs; // Store all reports
        newReportsCount = allReports.length; // Update new reports count
        filterReports(searchController.text); // Apply filtering
      });
    });
  }

  void filterReports(String query) {
    setState(() {
      filteredReports = allReports.where((report) {
        // Assuming 'ruangan' is the field in your report documents
        return report['ruangan'].toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  TextEditingController searchController = TextEditingController();
  List<QueryDocumentSnapshot> allReports = [];
  List<QueryDocumentSnapshot> filteredReports = [];

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
                          // Add your navigation logic here
                          // For example, navigate to a notifications page
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => NotificationPage()));
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
                      _buildMenuButton(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LaporanMasukDinas(),
                            ),
                          );
                          markLaporanMasukPageOpened();
                          setState(() {
                            newReportsCount = 0;
                          });
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
                              builder: (context) =>
                                  const DalamPengerjaanDinas(),
                            ),
                          );
                          markLaporanMasukPageOpened();
                          setState(() {
                            newReportsCount = 0;
                          });
                        },
                        icon: Icons.timer,
                        label: 'Dalam \nPengerjaan',
                        badgeCount: newReportsCount,
                      ),
                      _buildMenuButton(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LaporanSelesaiDinas(),
                            ),
                          );
                          markLaporanMasukPageOpened();
                          setState(() {
                            newReportsCount = 0;
                          });
                        },
                        icon: Icons.verified,
                        label: 'Laporan\nSelesai',
                        badgeCount: newReportsCount,
                      ),
                      // _buildMenuButton(
                      //   onTap: () {
                      //     Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //         builder: (context) => const NambahUser(),
                      //       ),
                      //     );
                      //   },
                      //   icon: Icons.person_add,
                      //   label: 'Tambahkan\nPengguna',
                      // ),
                      _buildMenuButton(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UserList()));
                        },
                        icon: Icons.person_add,
                        label: 'Kelola\nPengguna',
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
                margin: const EdgeInsets.symmetric(horizontal: 25),
                decoration: BoxDecoration(
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 20.0,
                      offset: Offset(0, 10.0),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.white,
                ),
                child: TextField(
                  controller: searchController,
                  onChanged: (query) {
                    filterReports(query);
                  },
                  decoration: const InputDecoration(
                    suffixIcon: Icon(
                      Icons.search,
                      color: Colors.black,
                      size: 20.0,
                    ),
                    border: InputBorder.none,
                    hintText: 'Telusuri',
                  ),
                ),
              ),
            ),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(left: 25, right: 25, bottom: 8),
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
            ProgresLaporan(
              userRole: 'dinas',
              maxItemsToShow: 3,
            )
          ],
        ),
      ),
    );
  }

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
