import 'package:fast_it_2/auth/login.dart';
import 'package:fast_it_2/auth/register.dart';
import 'package:fast_it_2/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:async';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fast-It',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const WelcomePage(),
    );
  }
}

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key});

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final List<String> backgroundImages = [
    "lib/images/school.jpg",
    "lib/images/classJ.jpg",
    "lib/images/library.jpg",
    "lib/images/library2.jpg",
  ];

  int _currentPage = 0;
  int _nextImageIndex = 1;
  Timer? _timer;
  final Duration slideDuration = const Duration(seconds: 7);

  @override
  void initState() {
    super.initState();
    startAutoSlideTimer();
  }

  void startAutoSlideTimer() {
    _timer = Timer.periodic(slideDuration, (timer) {
      setState(() {
        _currentPage = (_currentPage + 1) % backgroundImages.length;
        _nextImageIndex = (_currentPage + 1) % backgroundImages.length;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ColorFiltered(
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.5),
                BlendMode
                    .darken), // Adjust the opacity value for the darkness level
            child: Image.asset(
              backgroundImages[_currentPage],
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          // Next image with the same color filter
          ColorFiltered(
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.5),
                BlendMode
                    .darken), // Adjust the opacity value for the darkness level
            child: Image.asset(
              backgroundImages[_nextImageIndex], // Preloaded next image
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // const Icon(
                //   Icons.android,
                //   color: Colors.white,
                //   size: 45,
                // ),
                const SizedBox(height: 200),
                const Text(
                  "Selamat Datang di Fast-it",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                  ),
                ),
                const SizedBox(height: 10),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "Laporan Fasilitas yang Efisien, Perbaikan yang Transparan",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.lightBlue,
                    backgroundColor: Colors.white,
                    minimumSize: const Size(210, 48),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Login()),
                    );
                  },
                  child: const Text(
                    "Login",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.lightBlue,
                    backgroundColor: Colors.white,
                    minimumSize: const Size(210, 48),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Registration()),
                    );
                  },
                  child: const Text(
                    "Register",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
