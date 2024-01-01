import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fast_it_2/components/detail/detail_kerusakan.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';

class ProgresLaporan extends StatelessWidget {
  final int maxItemsToShow;
  final String? statusFilter;
  final String? userRole;
  ProgresLaporan({this.maxItemsToShow = 3, this.statusFilter, this.userRole});

  @override
  Widget build(BuildContext context) {
    CollectionReference reportsCollection =
        FirebaseFirestore.instance.collection('reports');
    Query reportsQuery = reportsCollection;

    if (statusFilter != null) {
      reportsQuery = reportsQuery.where('status', isEqualTo: statusFilter);
    }

    if (userRole == 'dinas') {
      reportsQuery = reportsQuery.where('status',
          whereNotIn: ['Menunggu Verifikasi', 'Ditangani Sekolah']);
    } else if (userRole == 'staff') {
      reportsQuery = reportsQuery.where('status',
          whereIn: ['Ditangani Sekolah', 'Menunggu Verifikasi']);
    }

    return StreamBuilder<QuerySnapshot>(
      stream: reportsQuery.snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
          List<DocumentSnapshot> displayedReports =
              snapshot.data!.docs.take(maxItemsToShow).toList().toList();

          return Column(
            children: displayedReports.map((DocumentSnapshot document) {
              var data = document.data() as Map<String, dynamic>;

              bool isImageLoaded =
                  (data['fileUrls'] as List<dynamic>).isNotEmpty;

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => KerusakanDetail(
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
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 300,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: const Color(0xFF0C356A),
                            width: 2.0,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.assignment,
                                  ),
                                  const SizedBox(width: 4),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        data['username'] ?? "username",
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Container(
                                height: 1,
                                color: Colors.grey[300],
                              ),
                            ),
                            Row(
                              children: [
                                isImageLoaded
                                    ? Container(
                                        width: 80,
                                        height: 80,
                                        margin: const EdgeInsets.all(8.0),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Image.network(
                                            data['fileUrls'][0].toString(),
                                            height: 85,
                                            width: 85,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      )
                                    : Shimmer.fromColors(
                                        baseColor: Colors.grey[300]!,
                                        highlightColor: Colors.grey[100]!,
                                        child: Container(
                                          width: 80,
                                          height: 80,
                                          margin: const EdgeInsets.all(8.0),
                                          color: Colors.white,
                                        ),
                                      ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      isImageLoaded
                                          ? Text(
                                              data['ruangan'] ?? "Ruang Kelas",
                                              style: TextStyle(
                                                color: Colors.grey[800],
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            )
                                          : Shimmer.fromColors(
                                              baseColor: Colors.grey[300]!,
                                              highlightColor: Colors.grey[100]!,
                                              child: Container(
                                                height: 16,
                                                width: 150,
                                                color: Colors.white,
                                              ),
                                            ),
                                      const SizedBox(height: 5),
                                      isImageLoaded
                                          ? Text(
                                              data['kerusakan'] ??
                                                  "Jenis Kerusakan",
                                              style: TextStyle(
                                                color: Colors.grey[500],
                                                fontSize: 14,
                                              ),
                                            )
                                          : Shimmer.fromColors(
                                              baseColor: Colors.grey[300]!,
                                              highlightColor: Colors.grey[100]!,
                                              child: Container(
                                                height: 14,
                                                width: 100,
                                                color: Colors.white,
                                              ),
                                            ),
                                      const SizedBox(height: 10),
                                      isImageLoaded
                                          ? Text(
                                              data['deskripsi'] ??
                                                  "Deskripsi Kerusakan",
                                              maxLines: 2,
                                              style: TextStyle(
                                                color: Colors.grey[700],
                                              ),
                                            )
                                          : Shimmer.fromColors(
                                              baseColor: Colors.grey[300]!,
                                              highlightColor: Colors.grey[100]!,
                                              child: Container(
                                                height: 14,
                                                width: 200,
                                                color: Colors.white,
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
      case 'Ditangani Sekolah':
        return const Icon(Icons.verified, color: Colors.green, size: 24);
      case 'Dibatalkan':
        return const Icon(Icons.cancel, color: Colors.red, size: 24);
      case 'Ditolak':
        return const Icon(Icons.cancel, color: Colors.red, size: 24);
      default:
        return const Icon(Icons.pending, color: Colors.grey, size: 24);
    }
  }
}
