import 'package:fast_it_2/components/card/card_laporan_masuk.dart';
import 'package:flutter/material.dart';

class LaporanMasukDinas extends StatefulWidget {
  const LaporanMasukDinas({super.key});

  @override
  State<LaporanMasukDinas> createState() => _LaporanMasukDinasState();
}

class _LaporanMasukDinasState extends State<LaporanMasukDinas> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Laporan Masuk'),
          backgroundColor: Color(0xFF0C356A),
        ),
        body: CardLaporanMasuk(
          userRole: 'dinas',
        ));
  }
}
