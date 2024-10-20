import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:mavis/TerapiObat/TerapiObat.dart';
import 'package:mavis/ConctactScreen/ContactScreen.dart'; // Import ContactScreen
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences untuk menyimpan kontak
import 'dart:convert'; // Import untuk decoding JSON

class MedisScreen extends StatefulWidget {
  const MedisScreen({Key? key}) : super(key: key);

  @override
  _MedisScreenState createState() => _MedisScreenState();
}

class _MedisScreenState extends State<MedisScreen> {
  double _uploadProgress = 0.0;
  List<File> _selectedFiles = [];
  List<Map<String, dynamic>> _fileDetails = [];
  String documentID = "";
  final List<String> _riwayatPenyakit = [];
  final TextEditingController _penyakitController = TextEditingController();
  final List<String> _alergiList = [];
  final TextEditingController _alergiController = TextEditingController();
  bool _showShareDialog = false; // To control share dialog visibility
  bool _showPostView = false; // To control the view post
  String _shareTo = ""; // To track where the document is shared

  List<Map<String, dynamic>> contacts = []; // List untuk menyimpan kontak

  @override
  void initState() {
    super.initState();
    _generateRandomID();
    _loadContacts(); // Memuat daftar kontak saat pertama kali screen terbuka
  }

  // Generate random ID
  void _generateRandomID() {
    setState(() {
      documentID =
          List.generate(8, (index) => Random().nextInt(9).toString()).join();
    });
  }

  // Pick file (Multiple upload)
  Future<void> _pickFile() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: true);

    if (result != null) {
      setState(() {
        _selectedFiles = result.paths.map((path) => File(path!)).toList();
        _fileDetails = result.files
            .map((file) => {
                  "name": file.name,
                  "size": (file.size / (1024 * 1024)).toStringAsFixed(2) + " MB"
                })
            .toList();
        _uploadProgress = 0.0;
      });

      // Simulate upload process
      _startUpload();
    }
  }

  // Simulate upload process
  Future<void> _startUpload() async {
    for (int i = 0; i <= 100; i++) {
      await Future.delayed(const Duration(milliseconds: 50));
      setState(() {
        _uploadProgress = i / 100;
      });
    }
  }

  // Add illness history
  void _addPenyakit() {
    if (_penyakitController.text.isNotEmpty) {
      setState(() {
        _riwayatPenyakit.add(_penyakitController.text);
        _penyakitController.clear();
      });
    }
  }

  // Add allergies
  void _addAlergi() {
    if (_alergiController.text.isNotEmpty) {
      setState(() {
        _alergiList.add(_alergiController.text);
        _alergiController.clear();
      });
    }
  }

  // Toggle share dialog visibility
  void _toggleShareDialog() {
    setState(() {
      _showShareDialog = !_showShareDialog;
    });
  }

  // Toggle view post visibility
  void _togglePostView() {
    setState(() {
      _showPostView = !_showPostView;
    });
  }

  // Simulate sharing process
  void _shareToEntity(String entity) {
    setState(() {
      _shareTo = entity;
      _showShareDialog = false;
    });

    Future.delayed(const Duration(seconds: 1), () {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Anda berhasil menshare ke $entity")),
      );
    });
  }

  // Navigasi ke halaman Terapi Obat
  void _goToTherapyScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TherapyScreen(documentID: documentID),
      ),
    );
  }

  // Fungsi untuk memuat daftar kontak dari SharedPreferences
  Future<void> _loadContacts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? contactsData = prefs.getString('contacts');

    if (contactsData != null) {
      setState(() {
        contacts = List<Map<String, dynamic>>.from(jsonDecode(contactsData));
      });
    }
  }

  // Build share dialog with contacts
  Widget _buildContactsDialog() {
    return AlertDialog(
      title: const Text("Bagikan ke Kontak"),
      content: contacts.isEmpty
          ? const Text("Tidak ada kontak yang tersedia.")
          : SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: contacts.length,
                itemBuilder: (context, index) {
                  final contact = contacts[index];
                  return GestureDetector(
                    onTap: () {
                      // Ketika kontak dipilih, simulasikan share dan tutup dialog
                      _shareToEntity(contact['name']);
                      Navigator.pop(context);
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.green),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(contact['name'],
                              style: const TextStyle(fontSize: 16)),
                          Text(contact['number'],
                              style: const TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Tutup"),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.green,
        centerTitle: true,
        title: const Text(
          "Medikasi",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Dokumen Klinis",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: _pickFile,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.upload_file,
                            size: 40,
                            color: Colors.blue.shade200,
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "Klik Untuk Unggah atau Tarik dan Lepas",
                            style: TextStyle(color: Colors.blue),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Show upload details
                  if (_selectedFiles.isNotEmpty) ...[
                    for (var fileDetail in _fileDetails)
                      Column(
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.insert_drive_file),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  "${fileDetail["name"]} (${fileDetail["size"]})",
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          LinearProgressIndicator(
                            value: _uploadProgress,
                            backgroundColor: Colors.grey.shade300,
                            color: _uploadProgress == 1.0
                                ? Colors.green
                                : Colors.blueAccent,
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    if (_uploadProgress == 1.0)
                      const Text(
                        "Upload Selesai!",
                        style: TextStyle(color: Colors.green),
                      ),
                  ],

                  const SizedBox(height: 20),

                  // Riwayat Penyakit
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Riwayat Penyakit",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_circle, color: Colors.green),
                        onPressed: _addPenyakit,
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Wrap(
                      spacing: 8.0,
                      children: _riwayatPenyakit
                          .map((penyakit) => Chip(
                                label: Text(penyakit),
                                onDeleted: () {
                                  setState(() {
                                    _riwayatPenyakit.remove(penyakit);
                                  });
                                },
                              ))
                          .toList(),
                    ),
                  ),
                  TextField(
                    controller: _penyakitController,
                    decoration: const InputDecoration(
                      hintText: "Tambahkan Riwayat Penyakit...",
                    ),
                    onSubmitted: (_) => _addPenyakit(),
                  ),
                  const SizedBox(height: 20),

                  // Alergi
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Alergi",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_circle, color: Colors.green),
                        onPressed: _addAlergi,
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Wrap(
                      spacing: 8.0,
                      children: _alergiList
                          .map((alergi) => Chip(
                                label: Text(alergi),
                                onDeleted: () {
                                  setState(() {
                                    _alergiList.remove(alergi);
                                  });
                                },
                              ))
                          .toList(),
                    ),
                  ),
                  TextField(
                    controller: _alergiController,
                    decoration: const InputDecoration(
                      hintText: "Tambahkan Alergi...",
                    ),
                    onSubmitted: (_) => _addAlergi(),
                  ),
                  const SizedBox(height: 30),

                  // Dokumen ID, Share Icon, dan Tombol Berikutnya
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Dengan siapa Anda berbagi Dokumen ini?",
                            textAlign: TextAlign.left,
                          ),
                          Text(
                            "ID Dokumen: $documentID",
                            style: const TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.share, color: Colors.green),
                        onPressed: () {
                          // Menampilkan dialog daftar kontak saat tombol share ditekan
                          showDialog(
                            context: context,
                            builder: (_) => _buildContactsDialog(),
                          );
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // Button berikutnya
                  Center(
                    child: ElevatedButton(
                      onPressed: _goToTherapyScreen, // Navigate to TerapiObat
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 100, vertical: 16),
                      ),
                      child: const Text(
                        "Berikutnya",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Build share dialog
  Widget _buildShareDialog() {
    return AlertDialog(
      title: const Text("Bagikan ID Dokumen"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Apakah Anda yakin ingin membagikan ID ini?"),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: const Icon(Icons.local_hospital, color: Colors.green),
                onPressed: () => _shareToEntity("Dokter"),
              ),
              IconButton(
                icon: const Icon(Icons.local_pharmacy, color: Colors.green),
                onPressed: () => _shareToEntity("Farmasi"),
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => setState(() => _showShareDialog = false),
          child: const Text("Batal"),
        ),
      ],
    );
  }

  // Build view post modal
  Widget _buildViewPostModal() {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
            BoxShadow(blurRadius: 10, color: Colors.black26, spreadRadius: 5),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Dokumen Anda:",
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text("ID Dokumen: $documentID",
                style: const TextStyle(color: Colors.green)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _togglePostView,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text("Tutup"),
            ),
          ],
        ),
      ),
    );
  }
}
