import 'package:fast_it_2/components/card/working.dart';
import 'package:flutter/material.dart';

class DalamPengerjaanDinas extends StatelessWidget {
  const DalamPengerjaanDinas({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Dalam Pengerjaan',
            style: TextStyle(color: Colors.white),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
            color: Colors.white,
          ),
          centerTitle: true,
          backgroundColor: const Color(0xFF0C356A),
          elevation: 0.0,
        ),
        body: const DalamPengerjaanCard());
  }
}
