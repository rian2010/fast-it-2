import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Laporan extends StatefulWidget {
  const Laporan({Key? key}) : super(key: key);

  @override
  _LaporanState createState() => _LaporanState();
}

class _LaporanState extends State<Laporan> {
  List<String?> filePaths = [];
  String? selectedKerusakan;
  String? selectedSekolah;
  bool userSubmittedReport = false;
  OverlayEntry? _overlayEntry;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final List<String> kerusakanOptions = [
    "Kerusakan Ringan",
    "Kerusakan Sedang",
    "Kerusakan Berat",
  ];

  final TextEditingController _verificationController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();
  final TextEditingController _ruanganController = TextEditingController();

  final CollectionReference reportsCollection =
      FirebaseFirestore.instance.collection('reports');

  String? _validateSekolah(String? value) {
    if (value == null || value.isEmpty) {
      return 'Pilih sekolah terlebih dahulu';
    }
    return null;
  }

  String? _validateRuangan(String? value) {
    if (value == null || value.isEmpty) {
      return 'Isi ruangan terlebih dahulu';
    }
    return null;
  }

  String? _validateKerusakan(String? value) {
    if (value == null || value.isEmpty) {
      return 'Pilih jenis kerusakan terlebih dahulu';
    }
    return null;
  }

  String? _validateFiles(List<String?> value) {
    if (value.isEmpty) {
      return 'Pilih file terlebih dahulu';
    }
    return null;
  }

  String? _validateDeskripsi(String? value) {
    if (value == null || value.isEmpty) {
      return 'Isi deskripsi terlebih dahulu';
    }
    return null;
  }

  bool hasUnsavedChanges() {
    // Check if there are unsaved changes in the form
    // For example, you can check if the text controllers have non-empty values
    return _verificationController.text.isNotEmpty ||
        _ruanganController.text.isNotEmpty ||
        selectedKerusakan != null ||
        filePaths.isNotEmpty ||
        _deskripsiController.text.isNotEmpty;
  }

  Future<bool> _onWillPop() async {
    if (hasUnsavedChanges()) {
      // Show a confirmation dialog if there are unsaved changes
      return await AwesomeDialog(
                  context: context,
                  dialogType: DialogType.warning,
                  animType: AnimType.bottomSlide,
                  title: 'Perubahan yang Anda buat belum disimpan.',
                  titleTextStyle:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  desc: 'Apakah Anda yakin ingin keluar? ',
                  descTextStyle: TextStyle(fontWeight: FontWeight.normal),
                  btnCancelOnPress: () =>
                      () => Navigator.of(context).pop(false),
                  btnOkOnPress: () => Navigator.of(context).pop(true),
                  btnCancelText: 'Batal',
                  btnOkColor: Color(0xFF0C356A))
              .show() ??
          false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Buat Laporan'),
          backgroundColor: const Color(0xFF0C356A),
          elevation: 0.0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    "Nama Sekolah",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Column(
                    children: [
                      TypeAheadFormField<String>(
                        textFieldConfiguration: TextFieldConfiguration(
                          controller: _verificationController,
                          decoration: InputDecoration(
                            hintText: 'Pilih Sekolah',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  const BorderSide(color: Color(0xFF0C356A)),
                            ),
                            contentPadding: const EdgeInsets.all(12.0),
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
                            selectedSekolah = suggestion;
                          });
                          _verificationController.text = suggestion;
                        },
                        validator: _validateSekolah,
                        suggestionsBoxDecoration: SuggestionsBoxDecoration(
                          color: Colors.white,
                          elevation: 5,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                    ],
                  ),
                  const Text(
                    "Ruangan",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: 300,
                    child: TextFormField(
                      controller: _ruanganController,
                      decoration: InputDecoration(
                        hintText: "Ruangan",
                        contentPadding: EdgeInsets.all(10),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors
                                .grey, // You can customize the border color here
                            width:
                                1.0, // You can customize the border width here
                          ),
                          borderRadius: BorderRadius.circular(
                              10), // You can customize the border radius here
                        ),
                      ),
                      validator: _validateRuangan,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    "Jenis Kerusakan",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  SizedBox(
                    width: 300,
                    child: DropdownButtonFormField<String>(
                      value: selectedKerusakan,
                      items: kerusakanOptions.map((String option) {
                        return DropdownMenuItem<String>(
                          value: option,
                          child: Text(
                            option,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedKerusakan = newValue;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: "Pilih Jenis Kerusakan",
                        contentPadding: EdgeInsets.all(10),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors
                                .grey, // You can customize the border color here
                            width:
                                1.0, // You can customize the border width here
                          ),
                          borderRadius: BorderRadius.circular(
                              10), // You can customize the border radius here
                        ),
                      ),
                      validator: _validateKerusakan,
                    ),
                  ),
                  const SizedBox(height: 10),
                  buildText(
                      'Ringan: Cat dinding yang terkelupas, pecahnya kaca jendela kecil',
                      10,
                      FontWeight.normal,
                      Colors.grey),
                  const SizedBox(height: 10),
                  buildText(
                      'Sedang: Keran air yang mengalir dengan tekanan rendah, pintu kelas yang sulit dibuka dan ditutup',
                      10,
                      FontWeight.normal,
                      Colors.grey),
                  const SizedBox(height: 10),
                  buildText(
                      'Berat: Kebocoran gas di laboratorium, kerusakan struktural pada gedung sekolah',
                      10,
                      FontWeight.normal,
                      Colors.grey),
                  const SizedBox(height: 16),
                  const Text(
                    "Unggah File",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Container(
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
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    "Deskripsi",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: 300,
                    child: TextFormField(
                      controller: _deskripsiController,
                      maxLines: 10,
                      decoration: InputDecoration(
                        hintText: "Deskripsi Kerusakan",
                        contentPadding: EdgeInsets.all(10),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors
                                .grey, // You can customize the border color here
                            width:
                                1.0, // You can customize the border width here
                          ),
                          borderRadius: BorderRadius.circular(
                              10), // You can customize the border radius here
                        ),
                      ),
                      validator: _validateDeskripsi,
                    ),
                  ),
                  const SizedBox(height: 16),
                  buildText(
                      'Jelaskan kerusakan dengan benar', 12, null, Colors.grey),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        if (user != null) {
                          _submitReport();
                        } else {
                          print('User is not signed in. Please log in.');
                        }
                      }
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<String> getSuggestions(String query) {
    return ["SMK 1", "SMA 1", "SMA 3", "SMA APA AJA"]
        .where((option) => option.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  Future<void> _submitReport() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        print('User is not signed in. Please log in.');
        return;
      }

      String userRole = await _getUserRole(user.uid);
      if (userRole == 'Siswa' || userRole == 'Staff') {
        bool confirmSubmit = await _showConfirmationDialog();

        if (confirmSubmit) {
          _showLoadingOverlay();
          List<String> fileUrls = await _uploadFiles();

          // Fetch user document to get the username
          DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();

          String username = userSnapshot.get('username');

          Map<String, dynamic> reportData = {
            'sekolah': selectedSekolah,
            'ruangan': _ruanganController.text,
            'kerusakan': selectedKerusakan,
            'deskripsi': _deskripsiController.text,
            'fileUrls': fileUrls,
            'userId': user.uid,
            'username': username,
            'timestamp': FieldValue.serverTimestamp(),
            'status': userRole == 'Staff'
                ? 'Diteruskan ke Dinas'
                : 'Menunggu Verifikasi',
          };

          await reportsCollection.add(reportData);

          _removeLoadingOverlay();

          _showSuccessDialog();

          setState(() {
            userSubmittedReport = true;
          });
          // Reset form fields after successful submission
          _formKey.currentState?.reset();
          _verificationController.clear();
          _ruanganController.clear();
          _deskripsiController.clear();
          setState(() {
            selectedSekolah = null;
            selectedKerusakan = null;
            filePaths.clear();
          });
        }
      } else {
        print('User does not have the required role to submit a report.');
      }
    } catch (e) {
      print('Error submitting report: $e');
      _removeLoadingOverlay();
    }
  }

  Future<bool> _showConfirmationDialog() async {
    bool confirmed = false;

    await AwesomeDialog(
      context: context,
      dialogType: DialogType.info,
      animType: AnimType.bottomSlide,
      title: 'Konfirmasi',
      desc: 'Apakah anda ingin mengirim laporan ini?',
      btnCancelOnPress: () {
        confirmed = false;
      },
      btnOkOnPress: () {
        confirmed = true;
      },
    ).show();

    return confirmed;
  }

  void _showSuccessDialog() {
    AwesomeDialog(
      context: context,
      animType: AnimType.leftSlide,
      headerAnimationLoop: false,
      dialogType: DialogType.success,
      showCloseIcon: true,
      title: 'Berhasil',
      desc: 'Laporan Berhasil Diajukan',
      btnOkOnPress: () {},
      btnOkIcon: Icons.check_circle,
      btnCancelText: 'Batal',
      onDismissCallback: (type) {},
    ).show();
  }

  Future<String> _getUserRole(String userId) async {
    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userSnapshot.exists) {
        return userSnapshot.get('role');
      } else {
        print('User not found in Firestore.');
        return '';
      }
    } catch (e) {
      print('Error retrieving user role: $e');
      return '';
    }
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

  void _showLoadingOverlay() {
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned.fill(
        child: Container(
          color: Colors.black.withOpacity(0.5),
          child: const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeLoadingOverlay() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }
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

    if (result != null) {
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

  Widget buildText(
    String text,
    double fontSize,
    FontWeight? fontWeight,
    Color? color,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 5.0,
          height: 5.0,
          margin: EdgeInsets.only(
              top: 4.0, right: 8.0), // Adjust the margin as needed
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey, // You can customize the color of the dot
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: fontWeight,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}
