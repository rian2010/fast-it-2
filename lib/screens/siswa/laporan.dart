// import 'package:fast_it/config/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class Laporan extends StatefulWidget {
  @override
  State<Laporan> createState() => _LaporanState();
}

class _LaporanState extends State<Laporan> {
  String? filePath;
  String? selectedKerusakan;

  final List<String> kerusakanOptions = [
    "Option 1",
    "Option 2",
    "Option 3",
    // Add more options as needed
  ];

  // Store the selected file path
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buat Laporan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
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
              const SizedBox(height: 16.0),
              Container(
                width: 300,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color:
                        const Color(0xFF1CC2CD), // Set the outline color here
                  ),
                ),
                child: TextFormField(
                  decoration: const InputDecoration(
                    hintText: "Nama Sekolah",
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(10),
                  ),
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
              const SizedBox(height: 16.0),
              Container(
                width: 300,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: const Color(0xFF1CC2CD),
                  ),
                ),
                child: DropdownButtonFormField<String>(
                  value: selectedKerusakan,
                  items: kerusakanOptions.map((String option) {
                    return DropdownMenuItem<String>(
                      value: option,
                      child: Text(
                        option,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black, // Text color
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedKerusakan = newValue;
                    });
                  },
                  decoration: const InputDecoration(
                    hintText: "Pilih Jenis Kerusakan",
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(10),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              const Text(
                "Upload File",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                height: 4 * 54.0, // Match the height with the description box
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextButton.icon(
                        onPressed: () async {
                          // Open file explorer
                          final result = await FilePicker.platform.pickFiles(
                            type: FileType.custom,
                            allowedExtensions: [
                              'pdf',
                              'doc',
                              'docx',
                              'jpg',
                              'jpeg',
                              'png'
                            ],
                          );

                          if (result != null) {
                            filePath = result.files.single.path;
                            // You can use the 'filePath' variable to access the selected file path.
                          }
                        },
                        icon: const Icon(Icons.attach_file),
                        label: const Text("Pilih File"),
                      ),
                    ),
                    if (filePath != null)
                      Text(
                        filePath!,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.blue,
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
              const TextField(
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: "Masukkan deskripsi kerusakan",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  // Implement submit logic
                },
                child: const Text("Submit"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
