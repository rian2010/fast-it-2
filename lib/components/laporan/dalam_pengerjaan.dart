import 'package:fast_it_2/components/card/dalam_pengerjaan_card.dart';
import 'package:flutter/material.dart';

class DalamPengerjaan extends StatefulWidget {
  const DalamPengerjaan({super.key});

  @override
  State<DalamPengerjaan> createState() => _DalamPengerjaanState();
}

class _DalamPengerjaanState extends State<DalamPengerjaan> {
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
        body: const CardDalamPengerjaan());
  }
}
