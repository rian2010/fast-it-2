import 'package:fast_it_2/components/card/progress_laporan.dart';
import 'package:flutter/material.dart';

class StatusLaporanDinas extends StatefulWidget {
  const StatusLaporanDinas({super.key});

  @override
  State<StatusLaporanDinas> createState() => _StatusLaporanDinasState();
}

class _StatusLaporanDinasState extends State<StatusLaporanDinas> {
  String? currentFilter;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Progres Laporan ',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.only(right: 14, left: 14),
                child: Row(
                  children: [
                    _buildFilterButton('Diteruskan ke Dinas'),
                    _buildFilterButton('Dalam Pengerjaan'),
                    _buildFilterButton('Selesai'),
                  ],
                ),
              ),
            ),
            ProgresLaporan(
              maxItemsToShow: 100,
              statusFilter: currentFilter,
              userRole: 'dinas',
            )
          ],
        ),
      ),
    );
  }

  Widget _buildFilterButton(String status) {
    bool isSelected = currentFilter == status;

    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: OutlinedButton(
        onPressed: () {
          _filterReports(status);
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(
            isSelected ? const Color(0xFF0C356A) : Colors.white,
          ),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          side: MaterialStateProperty.all(
            BorderSide(
              color: isSelected ? Colors.white : const Color(0xFF0C356A),
            ),
          ),
        ),
        child: Text(
          status,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF0C356A),
          ),
        ),
      ),
    );
  }

  void _filterReports(String status) {
    setState(() {
      if (currentFilter == status) {
        currentFilter = null;
      } else {
        currentFilter = status;
      }
    });
  }
}
