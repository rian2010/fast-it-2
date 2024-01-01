import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:intl/intl.dart';

import 'package:shared_preferences/shared_preferences.dart';

class KerusakanDetail extends StatefulWidget {
  final String documentId;

  const KerusakanDetail({Key? key, required this.documentId}) : super(key: key);

  @override
  State<KerusakanDetail> createState() => _KerusakanDetailState();
}

class _KerusakanDetailState extends State<KerusakanDetail> {
  int selectedImageIndex = 0;
  double rating = 0.0;
  bool showDescription = true;
  bool isVerified = false;
  final TextEditingController _verificationController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool laporanDiVerifikasi = false;
  final PageController _pageController = PageController();
  String selectedTechnician = '';
  List<String?> filePaths = [];
  bool shouldShowFormAndButton = true;
  late Stream<DocumentSnapshot> reportStream;
  late Future<Map<String, dynamic>> fetchData;

  @override
  void initState() {
    super.initState();
    _loadButtonState();
    fetchData = _getData();
    fetchRatingFromDatabase();

    reportStream = FirebaseFirestore.instance
        .collection('reports')
        .doc(widget.documentId)
        .snapshots();
    _checkUserRole();
  }

  Future<void> fetchRatingFromDatabase() async {
    try {
      // Fetch the 'penilaian' field from the database
      DocumentSnapshot reportSnapshot = await FirebaseFirestore.instance
          .collection('reports')
          .doc(widget.documentId)
          .get();

      if (reportSnapshot.exists) {
        setState(() {
          rating = (reportSnapshot.data() as dynamic)['penilaian'] ?? 0.0;
        });
      }
    } catch (e) {
      print('Error fetching rating from the database: $e');
    }
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

  Future<void> _checkUserRole() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user != null) {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      String userRole = userSnapshot.get('role');

      if (userRole != 'Staff' && userRole != 'Dinas') {
        // User doesn't have the required role, navigate back or show an error
        Navigator.pop(context); // or show an error page
      }
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

            // Combine the data from the initial fetch and the stream
            data = streamSnapshot.data!.data() as Map<String, dynamic>;

            return Scaffold(
              appBar: _buildAppBar(data),
              body: buildBody(data),
              bottomNavigationBar: buildBottomNavigationBar(data),
              // floatingActionButton: data['status'] == 'Diverifikasi'
              //     ? _buildFloatingActionButton()
              //     : null,
            );
          },
        );
      },
    );
  }

  AppBar _buildAppBar(Map<String, dynamic> data) {
    return AppBar(
      title: Text(data['ruangan'] ?? 'Ruang Kelas'),
      backgroundColor: const Color(0xFF0C356A),
    );
  }

  Widget buildBody(Map<String, dynamic> data) {
    String ruangan = data['ruangan'] ?? 'Ruang Kelas';
    String jenisKerusakan = data['kerusakan'] ?? 'Jenis Kerusakan';
    String deskripsi = data['deskripsi'] ?? 'Deskripsi Kerusakan';
    String selectedTechnician = data['selectedTechnician'] ?? 'Teknisi';
    String sekolah = data['sekolah'] ?? 'Sekolah';
    // String verificationDateTime = data['verificationDateTime'] ?? 'time';

    List<String> imagePaths = List<String>.from(data['fileUrls'] ?? []);
    List<String> buktiLaporan = List<String>.from(data['buktiLaporan'] ?? []);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildImageCarousel(imagePaths),
          buildImageList(imagePaths),
          buildReportDetails(data, ruangan, jenisKerusakan, deskripsi,
              selectedTechnician, sekolah),
          if (data['status'] == 'Diverifikasi') buildTechnicianButton(),
          if (data['status'] == 'Selesai') buildStatusSelesai(buktiLaporan),
          const SizedBox(height: 8),
          if (data['status'] == 'Selesai') buildRatingBar(),
          const SizedBox(height: 18)
        ],
      ),
    );
  }

  Widget buildImageCarousel(List<String> imagePaths) {
    return Container(
      color: Colors.white,
      child: Center(
        child: SizedBox(
          width: double.infinity,
          height: 250,
          child: PageView.builder(
            controller: _pageController,
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
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  } else {
                    return const Center(
                      child: SpinKitCircle(
                        color: Colors.blue, // Change the color as needed
                        size: 50.0, // Change the size as needed
                      ),
                    );
                  }
                },
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
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  } else {
                    return const Center(
                      child: SpinKitCircle(
                        color: Colors.blue, // Change the color as needed
                        size: 50.0, // Change the size as needed
                      ),
                    );
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildReportDetails(
      Map<String, dynamic> data,
      String ruangan,
      String jenisKerusakan,
      String deskripsi,
      String selectedTechnician,
      String sekolah) {
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
          buildText('Nama Sekolah', 18.0, FontWeight.bold, Colors.grey),
          const SizedBox(height: 10.0),
          buildText(sekolah, 15.0, null, null),
          const SizedBox(height: 16.0),
          buildText('Deskripsi:', 18.0, FontWeight.bold, Colors.grey),
          const SizedBox(height: 10.0),
          buildText(deskripsi, 15.0, null, null),
          const SizedBox(height: 16.0),
          if (data['status'] == 'Diverifikasi') buildVerificationForm(data),
          if (data['status'] == 'Dalam Pengerjaan' ||
              data['status'] == 'Selesai') ...[
            buildText('Teknisi:', 18.0, FontWeight.bold, Colors.grey),
            const SizedBox(height: 10.0),
            buildText(selectedTechnician, 15.0, null, null),
            if (data['status'] == 'Dalam Pengerjaan') buildSelesaiButton(),
          ],
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
            buildStatusIcon(data['status']),
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

  Widget buildStatusIcon(String? status) {
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

  String? _validateTeknisi(String? value) {
    if (value == null || value.isEmpty) {
      return 'Pilih Teknisi terlebih dahulu';
    }
    return null;
  }

  Widget buildVerificationForm(Map<String, dynamic> data) {
    if (shouldShowFormAndButton) {
      return Form(
        key: _formKey,
        child: Column(
          children: [
            TypeAheadFormField<String>(
              textFieldConfiguration: TextFieldConfiguration(
                controller: _verificationController,
                decoration: const InputDecoration(
                  labelText: 'Pilih Teknisi',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(12.0),
                ),
              ),
              suggestionsCallback: (pattern) {
                return getSuggestions(pattern);
              },
              itemBuilder: (context, suggestion) {
                return ListTile(
                  title: Text(suggestion),
                );
              },
              onSuggestionSelected: (suggestion) {
                setState(() {
                  _verificationController.text = suggestion;
                  selectedTechnician =
                      suggestion; // Set the selected technician
                });
              },
              validator: _validateTeknisi,
              suggestionsBoxDecoration: SuggestionsBoxDecoration(
                color: Colors.white,
                elevation: 5,
                borderRadius: BorderRadius.circular(8.0),
              ),
              direction: AxisDirection.up,
            ),
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  Visibility? buildBottomNavigationBar(Map<String, dynamic> data) {
    return (data['status'] == 'Diteruskan ke Dinas' ||
                data['status'] == 'Menunggu Verifikasi') &&
            data['status'] != 'Selesai' // Check if status is not 'Selesai'
        ? Visibility(
            visible: !isVerified,
            child: BottomAppBar(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          showTolakConfirmationDialog();
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            const Color(0xFFBA0909),
                          ),
                          foregroundColor: MaterialStateProperty.all<Color>(
                            Colors.white,
                          ),
                        ),
                        child: Text(showDescription ? 'Tolak' : 'Submit'),
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (data['status'] == 'Menunggu Verifikasi') {
                            teruskanDialog();
                          } else {
                            showVerificationDialog();
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            const Color(0xFF0C356A),
                          ),
                          foregroundColor: MaterialStateProperty.all<Color>(
                            Colors.black,
                          ),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                        child: const Text(
                          'Verifikasi',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        : null;
  }

  void showTolakConfirmationDialog() {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      headerAnimationLoop: false,
      animType: AnimType.bottomSlide,
      title: 'Konfirmasi Tindakan',
      desc: '',
      body: const Center(
        child: Text(
          'Apakah Anda yakin ingin menolak laporan ini?',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
      ),
      buttonsTextStyle: const TextStyle(color: Colors.white),
      showCloseIcon: true,
      btnCancelOnPress: () {},
      btnOkOnPress: () async {
        debugPrint('Berhasil ditolak');
        await FirebaseFirestore.instance
            .collection('reports')
            .doc(widget.documentId)
            .update({'status': 'Ditolak'});
        setState(() {
          isVerified = true;
          laporanDiVerifikasi = true;
        });
        _saveButtonState();
      },
      btnOkColor: const Color(0xFF0C356A),
      btnCancelColor: const Color(0xFFCD1C1C),
    ).show();
  }

  void showVerificationDialog() {
    AwesomeDialog(
      context: context,
      animType: AnimType.leftSlide,
      headerAnimationLoop: false,
      dialogType: DialogType.success,
      showCloseIcon: true,
      title: 'Berhasil',
      desc: 'Verifikasi Berhasil',
      btnOkOnPress: () async {
        debugPrint('Berhasil diverifikasi');
        await FirebaseFirestore.instance
            .collection('reports')
            .doc(widget.documentId)
            .update({
          'status': 'Diverifikasi',
          'verificationDateTime': FieldValue.serverTimestamp(),
        });
        setState(() {
          isVerified = true;
          laporanDiVerifikasi = true;
        });
        _saveButtonState();
      },
      btnOkIcon: Icons.check_circle,
      onDismissCallback: (type) {
        debugPrint('Dialog Dissmiss from callback $type');
      },
    ).show();
  }

  void teruskanDialog() {
    AwesomeDialog(
      context: context,
      animType: AnimType.leftSlide,
      headerAnimationLoop: false,
      dialogType: DialogType.question,
      showCloseIcon: true,
      title: 'Teruskan?',
      titleTextStyle: TextStyle(
          fontWeight: FontWeight.bold, fontSize: 20, color: Colors.grey),
      desc: ('Apakah anda ingin meneruskan laporan ini ke dinas pendidikan?'),
      descTextStyle: TextStyle(),
      btnOkOnPress: () async {
        debugPrint('Berhasil Diteruskan');
        await FirebaseFirestore.instance
            .collection('reports')
            .doc(widget.documentId)
            .update({
          'status': 'Diteruskan ke Dinas',
          'verificationDateTime': FieldValue.serverTimestamp(),
        });
        showSuccessDialog('Berhasil diteruskan');
      },
      btnCancelOnPress: () async {
        debugPrint('Berhasil diverifikasi');
        await FirebaseFirestore.instance
            .collection('reports')
            .doc(widget.documentId)
            .update({
          'status': 'Ditangani Sekolah',
          'verificationDateTime': FieldValue.serverTimestamp(),
        });
        Navigator.pop(context);
      },
      btnCancelText: ('Terima'),
      btnOkColor: const Color(0xFF0C356A),
      btnCancelColor: Colors.green,
      btnOkText: ('Teruskan'),
      onDismissCallback: (type) {
        debugPrint('Dialog Dissmiss from callback $type');
      },
    ).show();
  }

  void showSuccessDialog(String message) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.success, // You can change the type as needed
      animType: AnimType.bottomSlide,
      title: 'Berhasil',
      desc: message,
      btnOkOnPress: () {
        Navigator.pop(context);
      },
      btnOkText: 'OK',
    ).show();
  }

  List<String> getSuggestions(String query) {
    return ['Gamal', 'Twilight', 'Orion', 'Ashura']
        .where((option) => option.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  Future<void> _loadButtonState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLaporanDiVerifikasi = prefs.getBool(widget.documentId) ?? false;
    bool isVerifiedValue =
        prefs.getBool('${widget.documentId}_isVerified') ?? false;

    // Check if the technician is selected
    String selectedTechnicianValue =
        prefs.getString('${widget.documentId}_selectedTechnician') ?? '';
    if (selectedTechnicianValue.isNotEmpty) {
      setState(() {
        shouldShowFormAndButton = false;
        selectedTechnician = selectedTechnicianValue;
      });
    }

    setState(() {
      laporanDiVerifikasi = isLaporanDiVerifikasi;
      isVerified = isVerifiedValue;

      if (isVerified) {
        showDescription = false;
      }
    });
  }

  Future<void> _saveButtonState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(widget.documentId, laporanDiVerifikasi);
    await prefs.setBool('${widget.documentId}_isVerified', isVerified);
    await prefs.setString(
        '${widget.documentId}_selectedTechnician', selectedTechnician);
  }

  Widget buildTechnicianButton() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
        child: ElevatedButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              if (selectedTechnician.isNotEmpty) {
                await FirebaseFirestore.instance
                    .collection('reports')
                    .doc(widget.documentId)
                    .update({
                  'selectedTechnician': selectedTechnician,
                  'status': 'Dalam Pengerjaan',
                }).then((value) async {
                  await _saveButtonState();

                  debugPrint('Selected technician updated successfully');
                }).catchError((error) {
                  debugPrint('Error updating selected technician: $error');
                });
              } else {
                debugPrint('Please select a technician before submitting');
              }
            }
            veriicationDialog();
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
    );
  }

  void veriicationDialog() {
    AwesomeDialog(
      context: context,
      animType: AnimType.leftSlide,
      headerAnimationLoop: false,
      dialogType: DialogType.success,
      showCloseIcon: true,
      title: 'Berhasil',
      desc: 'Berhasil Ditugaskan',
      btnOkOnPress: () {},
      btnOkIcon: Icons.check_circle,
      onDismissCallback: (type) {
        debugPrint('Dialog Dissmiss from callback $type');
      },
    ).show();
  }

  Widget buildStatusSelesai(List<String> buktiLaporan) {
    bool isBuktiLaporanSent = buktiLaporan.isNotEmpty;

    return isBuktiLaporanSent
        ? buildLaporanSelesai(context, buktiLaporan)
        : _buildStatusSelesaiWidget();
  }

  Widget _buildStatusSelesaiWidget() {
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
              uploadBukti(),
              const SizedBox(height: 10),
            ],
          ),
        ),
        buildBottomButton(),
      ],
    );
  }

  Widget buildRatingBar() {
    final starSize = 48.0; // Adjust the size as needed

    return Center(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return Icon(
                index < rating.ceil() ? Icons.star : Icons.star_border,
                color: Colors.amber,
                size: starSize,
              );
            }),
          )
        ],
      ),
    );
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
              buildText('Bukti', 18, FontWeight.bold, Colors.grey),
              const SizedBox(height: 8),
              buildImage(buktiLaporan),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildImage(List<String> buktiLaporan) {
    return Container(
      color: Colors.white,
      child: Center(
        child: SizedBox(
          width: double.infinity,
          height: 250,
          child: Image.network(
            buktiLaporan.isNotEmpty
                ? buktiLaporan[0]
                : '', // Display the first image if available
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
  }

  Widget uploadBukti() {
    return Container(
      height: 4 * 54.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey),
      ),
      child: Column(
        children: [
          if (filePaths.isEmpty)
            Expanded(
              child: Center(
                child: TextButton.icon(
                  onPressed: () async {
                    _showFilePickerOrCameraModal();
                  },
                  icon: const Icon(
                    Icons.attach_file,
                    color: Color(0xFF0C356A),
                  ),
                  label: const Text(
                    "Pilih File",
                    style: TextStyle(color: Color(0xFF0C356A)),
                  ),
                ),
              ),
            ),
          if (filePaths.isNotEmpty)
            Expanded(
              child: _buildSelectedImagesWidget(),
            ),
          if (filePaths.isNotEmpty)
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextButton.icon(
                      onPressed: () {
                        setState(() {
                          filePaths.clear();
                        });
                      },
                      icon: const Icon(Icons.clear),
                      label: const Text("Hapus Semua"),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  void _showFilePickerOrCameraModal() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.file_upload),
              title: const Text('Pilih dari Galeri'),
              onTap: () {
                Navigator.pop(context);
                _pickFile();
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Buka Kamera'),
              onTap: () {
                Navigator.pop(context);
                _openCamera();
              },
            ),
          ],
        );
      },
    );
  }

  void _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'webp'],
      allowMultiple: true,
    );

    if (result != null) {
      setState(() {
        filePaths.addAll(result.files.map((file) => file.path));
      });
    }
  }

  void _openCamera() async {
    final result = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );

    if (result != null && mounted) {
      setState(() {
        filePaths.add(result.path);
      });
    }
  }

  Widget _buildSelectedImagesWidget() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: filePaths.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: _buildSelectedImageWidget(filePaths[index]!),
        );
      },
    );
  }

  Widget _buildSelectedImageWidget(String imagePath) {
    return SizedBox(
      width: 310.0,
      height: 100.0,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.file(
          File(imagePath),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget buildBottomButton() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () async {
            AwesomeDialog(
              context: context,
              animType: AnimType.leftSlide,
              headerAnimationLoop: false,
              dialogType: DialogType.success,
              showCloseIcon: true,
              title: 'Berhasil',
              desc: 'Bukti Laporan Berhasil Diunggah',
              btnOkOnPress: () async {
                List<String> uploadedFileUrls = await _uploadFiles();

                // Update the Firestore document with the evidence URLs
                await FirebaseFirestore.instance
                    .collection('reports')
                    .doc(widget.documentId)
                    .update({'buktiLaporan': uploadedFileUrls});

                Navigator.pop(context);
                // Add any additional actions or feedback you want to provide
                debugPrint('Bukti laporan uploaded successfully');
              },
              btnOkIcon: Icons.check_circle,
              onDismissCallback: (type) {
                debugPrint('Dialog Dissmiss from callback $type');
              },
            ).show();
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
    );
  }

  Future<List<String>> _uploadFiles() async {
    List<String> fileUrls = [];

    for (String? filePath in filePaths.where((path) => path != null)) {
      if (filePath != null) {
        File file = File(filePath);
        String fileName = file.path.split('/').last;

        Reference storageReference =
            FirebaseStorage.instance.ref().child('files/$fileName');

        UploadTask uploadTask = storageReference.putFile(file);
        TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);

        String downloadURL = await taskSnapshot.ref.getDownloadURL();
        fileUrls.add(downloadURL);
      }
    }

    return fileUrls;
  }

  Widget buildSelesaiButton() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () async {
            AwesomeDialog(
              context: context,
              animType: AnimType.leftSlide,
              headerAnimationLoop: false,
              dialogType: DialogType.warning,
              showCloseIcon: true,
              title: 'Selesaikan Pengerjaan?',
              btnOkOnPress: () async {
                // Update the Firestore document with the evidence URLs
                await FirebaseFirestore.instance
                    .collection('reports')
                    .doc(widget.documentId)
                    .update({'status': 'Selesai'});

                Navigator.pop(context);
                // Add any additional actions or feedback you want to provide
                debugPrint('Bukti laporan uploaded successfully');
              },
              btnCancelOnPress: () {},
              btnOkColor: const Color(0xFF0C356A),
              btnCancelText: ('Batalkan'),
              onDismissCallback: (type) {
                debugPrint('Dialog Dissmiss from callback $type');
              },
            ).show();
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
            'Selesaikan Pengerjaan',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
          ),
        ),
      ),
    );
  }
}
