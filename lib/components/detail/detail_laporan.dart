import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:fast_it_2/components/widget/package.dart';
// import 'package:fast_it_2/components/widget/package.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';

class DetailPage extends StatefulWidget {
  final String documentId;

  const DetailPage({
    Key? key,
    required this.documentId,
  }) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  int selectedImageIndex = 0;
  bool laporanDibatalkan = false;
  bool isRatingSubmitted = false;
  double rating = 0.0;
  final String isRatingSubmittedKey = 'isRatingSubmitted';

  final PageController _pageController = PageController();
  late Stream<DocumentSnapshot> reportStream;
  late Future<Map<String, dynamic>> fetchData;
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    _loadButtonState();
    loadRatingSubmittedState();
    fetchData = _getData();
    fetchRatingFromDatabase();
    reportStream = FirebaseFirestore.instance
        .collection('reports')
        .doc(widget.documentId)
        .snapshots();
  }

  Future<void> loadRatingSubmittedState() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isRatingSubmitted = prefs.getBool(isRatingSubmittedKey) ?? false;
    });
  }

  Future<void> saveRatingSubmittedState() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(isRatingSubmittedKey, isRatingSubmitted);
  }

  Future<Map<String, dynamic>> _getData() async {
    var snapshot = await FirebaseFirestore.instance
        .collection('reports')
        .doc(widget.documentId)
        .get();

    if (snapshot.exists) {
      return snapshot.data() as Map<String, dynamic>;
    } else {
      return {};
    }
  }

  Future<void> fetchRatingFromDatabase() async {
    try {
      // Fetch the 'penilaian' field from the database
      DocumentSnapshot reportSnapshot = await FirebaseFirestore.instance
          .collection('reports')
          .doc(widget.documentId)
          .get();

      if (reportSnapshot.exists) {
        // If the document exists, set the rating value
        setState(() {
          rating = (reportSnapshot.data() as dynamic)['penilaian'] ?? 0.0;
          isRatingSubmitted = true;
        });
      }
    } catch (e) {
      print('Error fetching rating from the database: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: fetchData,
      builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: SizedBox(
              width: 40.0,
              height: 40.0,
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        var data = snapshot.data!;

        return StreamBuilder<DocumentSnapshot>(
          stream: reportStream,
          builder: (context, AsyncSnapshot<DocumentSnapshot> streamSnapshot) {
            if (streamSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: SizedBox(
                  width: 40.0,
                  height: 40.0,
                  child: CircularProgressIndicator(),
                ),
              );
            }

            if (streamSnapshot.hasError) {
              return Text('Error: ${streamSnapshot.error}');
            }

            data = streamSnapshot.data!.data() as Map<String, dynamic>;

            return Scaffold(
              appBar: _buildAppBar(data),
              body: buildBody(data),
            );
          },
        );
      },
    );
  }

  AppBar _buildAppBar(Map<String, dynamic> data) {
    bool isDeletable = data['status'] == 'Menunggu Verifikasi' ||
        data['status'] == 'Diteruskan ke Dinas'; // Add your specific conditions

    return AppBar(
      title: Text(data['ruangan'] ?? 'Ruang Kelas'),
      backgroundColor: const Color(0xFF0C356A),
      actions: [
        if (isDeletable)
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              showDeleteConfirmationDialog();
            },
          ),
      ],
    );
  }

  Widget buildBody(Map<String, dynamic> data) {
    String ruangan = data['ruangan'] ?? 'Ruang Kelas';
    String jenisKerusakan = data['kerusakan'] ?? 'Jenis Kerusakan';
    String deskripsi = data['deskripsi'] ?? 'Deskripsi Kerusakan';
    String selectedTechnician = data['selectedTechnician'] ?? '';

    List<String> imagePaths = List<String>.from(data['fileUrls'] ?? []);
    List<String> buktiLaporan = List<String>.from(data['buktiLaporan'] ?? []);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildImageCarousel(imagePaths),
          buildImageList(imagePaths),
          buildReportDetails(
              data, ruangan, jenisKerusakan, deskripsi, selectedTechnician),
          if (data['status'] == 'Selesai')
            buildLaporanSelesai(context, buktiLaporan),
          if (data['status'] == 'Menunggu Verifikasi')
            buildBatalkanLaporanButton(),
          // if (data['status'] == 'Dalam Pengerjaan') MyTimeline()
          // if (data['status'] == 'Dalam Pengerjaan')
          //   PackageDeliveryTrackingPage()
        ],
      ),
    );
  }

  Widget buildImageCarousel(List<String> imagePaths) {
    return Container(
      color: Colors.white,
      child: Center(
        child: SizedBox(
          width: 400,
          height: 250,
          child: PageView.builder(
            controller: _pageController, // Add this line
            itemCount: imagePaths.length,
            onPageChanged: (index) {
              setState(() {
                selectedImageIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return Image.network(
                imagePaths[index],
                fit: BoxFit.fill,
              );
            },
          ),
        ),
      ),
    );
  }

  Widget buildImageList(List<String> imagePaths) {
    return SizedBox(
      height: 80.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: imagePaths.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedImageIndex = index;
                print("Selected Image Index: $index");

                _pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
              });
            },
            child: Container(
              margin: const EdgeInsets.all(8.0),
              width: 80.0,
              decoration: BoxDecoration(
                border: Border.all(
                  color: index == selectedImageIndex
                      ? Colors.blue
                      : Colors.transparent,
                  width: 2.0,
                ),
              ),
              child: Image.network(
                imagePaths[index],
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildReportDetails(Map<String, dynamic> data, String ruangan,
      String jenisKerusakan, String deskripsi, String selectedTechnician) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildReportHeader(data),
          const SizedBox(height: 16.0),
          buildText('Jenis Kerusakan:', 18.0, FontWeight.bold, Colors.grey),
          const SizedBox(height: 10.0),
          buildText(jenisKerusakan, 15.0, null, null),
          const SizedBox(height: 16.0),
          buildText('Deskripsi:', 18.0, FontWeight.bold, Colors.grey),
          const SizedBox(height: 10.0),
          buildText(deskripsi, 15.0, null, null),
          if (data['status'] == 'Dalam Pengerjaan' ||
              data['status'] == 'Selesai') ...[
            buildText('Teknisi:', 18.0, FontWeight.bold, Colors.grey),
            const SizedBox(height: 10.0),
            buildText(selectedTechnician, 15.0, null, null),
          ]
        ],
      ),
    );
  }

  Widget buildReportHeader(Map<String, dynamic> data) {
    return Row(
      children: [
        Text(
          data['ruangan'] ?? 'Ruang Kelas',
          style: const TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 85, 84, 84),
          ),
        ),
        const Spacer(),
        Row(
          children: [
            getStatusIcon(data['status']),
            const SizedBox(width: 4),
            Text(
              data['status'] ?? "Menunggu Verifikasi",
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _loadButtonState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLaporanDibatalkan = prefs.getBool(widget.documentId) ?? false;

    setState(() {
      laporanDibatalkan = isLaporanDibatalkan;
    });
  }

  void showDeleteConfirmationDialog() {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      headerAnimationLoop: false,
      animType: AnimType.bottomSlide,
      title: 'Konfirmasi Hapus',
      desc: '',
      body: const Center(
        child: Text(
          'Apakah Anda yakin ingin menghapus laporan ini?',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
      ),
      buttonsTextStyle: const TextStyle(color: Colors.white),
      showCloseIcon: true,
      btnCancelOnPress: () {},
      btnOkOnPress: () async {
        debugPrint('Berhasil dihapus');
        await FirebaseFirestore.instance
            .collection('reports')
            .doc(widget.documentId)
            .delete();
        Navigator.pop(context);
      },
      btnOkColor: const Color(0xFF0C356A),
      btnCancelColor: const Color(0xFFCD1C1C),
      btnOkText: 'Ya',
      btnCancelText: 'Tidak',
    ).show();
  }

  Widget buildBatalkanLaporanButton() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: laporanDibatalkan
              ? null
              : () async {
                  // Display confirmation dialog for "Batalkan Laporan" action
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.warning,
                    headerAnimationLoop: false,
                    animType: AnimType.bottomSlide,
                    title: 'Konfirmasi Tindakan',
                    desc: '',
                    body: const Center(
                      child: Text(
                        'Apakah Anda yakin ingin membatalkan pengajuan laporan ini?',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ),
                    buttonsTextStyle: const TextStyle(color: Colors.white),
                    showCloseIcon: true,
                    btnCancelOnPress: () {},
                    btnOkOnPress: () async {
                      debugPrint('Berhasil dibatalkan');

                      // Update the status in Firestore to 'Dibatalkan'
                      await FirebaseFirestore.instance
                          .collection('reports')
                          .doc(widget.documentId)
                          .update({'status': 'Dibatalkan'});

                      // Update the state to indicate that the laporan is dibatalkan
                      setState(() {
                        laporanDibatalkan = true;
                      });

                      _saveButtonState();
                    },
                    btnOkColor: const Color(0xFF0C356A),
                    btnCancelColor: const Color(0xFFCD1C1C),
                    btnOkText: 'Ya',
                    btnCancelText: 'Tidak',
                  ).show();
                },
          style: ElevatedButton.styleFrom(
            backgroundColor:
                laporanDibatalkan ? Colors.red : const Color(0xFF0C356A),
            padding: const EdgeInsets.symmetric(
              vertical: 16.0,
              horizontal: 32.0,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50.0),
            ),
          ),
          child: Text(
            laporanDibatalkan ? 'Laporan Dibatalkan' : 'Batalkan Laporan',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _saveButtonState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(widget.documentId, laporanDibatalkan);
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

  Widget buildLaporanSelesai(BuildContext context, List<String> buktiLaporan) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildText('Bukti: ', 18, FontWeight.bold, Colors.grey),
              const SizedBox(height: 8),
              buildImage(buktiLaporan),
              const SizedBox(height: 8),
              buildRatingBar(),
              const SizedBox(height: 8)
            ],
          ),
        ),
        buildBottomButton(),
        const SizedBox(height: 18)
      ],
    );
  }

  Widget buildText(
      String text, double fontSize, FontWeight? fontWeight, Color? color) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
      ),
    );
  }

  Widget buildImage(List<String> buktiLaporan) {
    if (buktiLaporan.isNotEmpty) {
      return Container(
        color: Colors.white,
        child: Center(
          child: SizedBox(
            width: double.infinity,
            height: 250,
            child: Image.network(
              buktiLaporan[0],
              fit: BoxFit.fitWidth,
              loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
        ),
      );
    } else {
      return Container(
        color: Colors.white,
        child: Center(
          child: SizedBox(
            width: double.infinity,
            height: 250,
            child: Lottie.asset(
                'lib/animation/notfound.json'), // Replace with your Lottie animation asset path
          ),
        ),
      );
    }
  }

  Widget buildRatingBar() {
    final starSize = 48.0; // Adjust the size as needed

    return Center(
      child: Column(
        children: [
          // isRatingSubmitted
          //     ? Row(
          //         mainAxisAlignment: MainAxisAlignment.center,
          //         children: List.generate(5, (index) {
          //           return Icon(
          //             index < rating.ceil() ? Icons.star : Icons.star_border,
          //             color: Colors.amber,
          //             size: starSize,
          //           );
          //         }),
          //       )
          // :
          RatingBar.builder(
            initialRating: rating,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => const Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (value) {
              setState(() {
                rating = value;
              });
            },
            itemSize: starSize,
          ),
        ],
      ),
    );
  }

  Widget buildBottomButton() {
    return Visibility(
      // visible: !isRatingSubmitted,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () async {
              debugPrint('Berhasil Dikirim');

              // Update the document with the new 'penilaian' field
              await FirebaseFirestore.instance
                  .collection('reports')
                  .doc(widget.documentId)
                  .update({'penilaian': rating});

              setState(() {
                isRatingSubmitted = true;
              });

              // Save the state to local storage
              saveRatingSubmittedState();

              submitRatingToReports();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0C356A),
              padding: const EdgeInsets.symmetric(
                vertical: 16.0,
                horizontal: 32.0,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0),
              ),
            ),
            child: const Text(
              'Kirim',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void submitRatingToReports() async {
    AwesomeDialog(
            context: context,
            dialogType: DialogType.success,
            headerAnimationLoop: false,
            animType: AnimType.bottomSlide,
            title: 'Berhasil',
            desc: 'Terimakasih sudah memberikan penilaian',
            buttonsTextStyle: const TextStyle(color: Colors.white),
            showCloseIcon: true,
            btnOkOnPress: () {})
        .show();
  }
}
