import 'package:fast_it_2/components/card/card_selesai.dart';
import 'package:flutter/material.dart';

class LaporanSelesaiSiswa extends StatefulWidget {
  const LaporanSelesaiSiswa({super.key});

  @override
  State<LaporanSelesaiSiswa> createState() => _LaporanSelesaiSiswaState();
}

class _LaporanSelesaiSiswaState extends State<LaporanSelesaiSiswa> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Selesai',
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
        body: const CardLaporanSelesai());
  }
}
