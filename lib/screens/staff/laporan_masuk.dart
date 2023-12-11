import 'package:fast_it_2/components/card/card_laporan_masuk.dart';
import 'package:flutter/material.dart';

class LaporanMasuk extends StatefulWidget {
  const LaporanMasuk({super.key});

  @override
  State<LaporanMasuk> createState() => _LaporanMasukState();
}

class _LaporanMasukState extends State<LaporanMasuk> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Laporan Masuk'),
          backgroundColor: Color(0xFF0C356A),
        ),
        body: CardLaporanMasuk(
          userRole: 'staff',
        ));
  }
}
