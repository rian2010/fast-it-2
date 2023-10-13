import 'package:fast_it_2/screens/siswa/homepage.dart';
import 'package:fast_it_2/screens/siswa/profile.dart';
import 'package:fast_it_2/screens/siswa/status_laporan.dart';
import 'package:fast_it_2/screens/staff/staffhome_page.dart';
import 'package:flutter/material.dart';

class StaffNavbar extends StatefulWidget {
  const StaffNavbar({Key? key}) : super(key: key);

  @override
  _StaffNavbarState createState() => _StaffNavbarState();
}

class _StaffNavbarState extends State<StaffNavbar> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getCurrentPage(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle),
            label: 'Status',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        selectedItemColor:
            const Color(0xFF1CC2CD), // Customize selected item color
        unselectedItemColor: Colors.grey, // Customize unselected item color
        showSelectedLabels: true, // Show labels for selected items
        showUnselectedLabels: true, // Show labels for unselected items
        type: BottomNavigationBarType.fixed, // Ensure labels are always visible
        backgroundColor: Colors.white,
      ),
    );
  }

  Widget _getCurrentPage() {
    switch (_currentIndex) {
      case 0:
        return StaffPage();
      case 1:
        return StatusLaporan();
      case 2:
        return Profile();
      default:
        return HomePage(); // Default to the first page
    }
  }
}
