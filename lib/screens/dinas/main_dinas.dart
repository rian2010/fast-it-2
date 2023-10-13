import 'package:fast_it_2/utils/dinas_navbar.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(home: DinasPage()));
}

class DinasPage extends StatelessWidget {
  const DinasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fast-It',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: DinasNavbar(),
    );
  }
}
