import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fast_it_2/components/detail/laporan_selesai.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CardLaporanSelesai extends StatelessWidget {
  const CardLaporanSelesai({Key? key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final userId = user?.uid;

    CollectionReference reportsCollection =
        FirebaseFirestore.instance.collection('reports');

    return StreamBuilder<QuerySnapshot>(
      stream: reportsCollection
          .where('status', isEqualTo: 'Selesai')
          .where('userId', isEqualTo: userId)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
          return Column(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              var data = document.data() as Map<String, dynamic>;

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailLaporanSelesai(
                        documentId: document.id,
                      ),
                    ),
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(
                      height: 8,
                    ), // Add padding between AppBar and the content
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 300,
                        decoration: BoxDecoration(
                          color: Colors.white, // Set the background color
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color:
                                const Color(0xFF0C356A), // Set the border color
                            width: 2.0, // Set the border width
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons
                                        .assignment, // Replace with your desired icon
                                  ),
                                  const SizedBox(width: 4),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        data['ruangan'] ?? "Ruangan Kelas",
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        (data['timestamp'] as Timestamp?)
                                                ?.toDate()
                                                .toString() ??
                                            "12:34 PM",
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        getStatusIcon(data['status']),
                                        const SizedBox(width: 4),
                                        Text(
                                          data['status'] ??
                                              "Menunggu Verifikasi",
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal:
                                      8.0), // Adjust left and right padding
                              child: Container(
                                height: 1,
                                color: Colors.grey[300], // Thin line color
                              ),
                            ),
                            Row(
                              children: [
                                Container(
                                  width: 80,
                                  height: 80,
                                  margin: const EdgeInsets.all(8.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      (data['fileUrls'] as List<dynamic>)
                                              .isNotEmpty
                                          ? data['fileUrls'][0].toString()
                                          : "lib/images/school.jpg",
                                      height: 85,
                                      width: 85,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        data['nama'] ?? "Ruang Kelas",
                                        style: TextStyle(
                                          color: Colors.grey[800],
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        data['kerusakan'] ?? "Jenis Kerusakan",
                                        style: TextStyle(
                                          color: Colors.grey[500],
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        data['deskripsi'] ??
                                            "Deskripsi Kerusakan",
                                        maxLines: 2,
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          );
        } else {
          // Handle the case where there is no data
          return Center(
            child: Lottie.asset('lib/animation/datanotfound.json'),
          );
        }
      },
    );
  }

  Widget getStatusIcon(String? status) {
    switch (status) {
      case 'Menunggu Verifikasi':
        return const Icon(Icons.pending, color: Colors.grey, size: 24);
      case 'Diverifikasi':
        return const Icon(Icons.assignment_turned_in,
            color: Colors.green, size: 24);
      case 'Dalam Pengerjaan':
        return const Icon(Icons.build, color: Colors.amber, size: 24);
      case 'Selesai':
        return const Icon(Icons.verified, color: Colors.green, size: 24);
      case 'Dibatalkan':
        return const Icon(Icons.cancel, color: Colors.red, size: 24);
      default:
        return const Icon(Icons.pending, color: Colors.grey, size: 24);
    }
  }
}
