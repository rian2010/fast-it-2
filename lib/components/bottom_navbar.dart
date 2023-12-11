// ignore_for_file: library_private_types_in_public_api

import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:fast_it_2/main.dart';
import 'package:fast_it_2/screens/siswa/homepage.dart';
import 'package:fast_it_2/screens/siswa/status_laporan.dart';
import 'package:fast_it_2/components/profile/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _currentIndex = 0;
  late List<Widget> _pages;

  Future<bool> _onWillPop() async {
    if (_currentIndex > 0) {
      // If not on the home page, go back to the previous page
      setState(() {
        _currentIndex = 0;
      });
      _saveCurrentIndex(0);
      return false;
    } else {
      // If on the home page, show a dialog to confirm logout
      Completer<bool> completer = Completer<bool>();

      AwesomeDialog(
              context: context,
              dialogType: DialogType.warning,
              headerAnimationLoop: false,
              animType: AnimType.bottomSlide,
              title: 'Keluar?',
              titleTextStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  // color: Colors.grey,
                  fontSize: 25),
              desc: 'Konfimasi tindakan',
              descTextStyle: TextStyle(color: Colors.grey),
              buttonsTextStyle: const TextStyle(color: Colors.white),
              showCloseIcon: true,
              btnCancelOnPress: () {},
              btnOkOnPress: () {
                debugPrint('Berhasil keluar');
                logout();
              },
              btnOkColor: const Color(0xFF0C356A),
              btnCancelColor: const Color(0xFFCD1C1C),
              btnCancelText: 'Batal')
          .show()
          .then((value) {
        completer.complete(value ?? false); // handle null value
      });

      return await completer.future;
    }
  }

  void logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      // ignore: use_build_context_synchronously
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const WelcomePage()),
        (route) => false,
      );
    } catch (e) {
      print('Error logging out: $e');
    }
  }

  Future<void> _saveCurrentIndex(int index) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('currentIndex', index);
  }

  @override
  void initState() {
    super.initState();
    _pages = [HomePage(), StatusLaporan(), const Profile()];
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: _pages,
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
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
              label: 'Profil',
            ),
          ],
          selectedItemColor:
              const Color(0xFF0C356A), // Customize selected item color
          unselectedItemColor: Colors.grey, // Customize unselected item color
          showSelectedLabels: true, // Show labels for selected items
          showUnselectedLabels: true, // Show labels for unselected items
          type:
              BottomNavigationBarType.fixed, // Ensure labels are always visible
          backgroundColor: Colors.white,
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}
