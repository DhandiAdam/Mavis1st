import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Tambahkan untuk SharedPreferences
import 'package:mavis/ConctactScreen/ContactScreen.dart'; // Import ContactScreen

class TherapyScreen extends StatefulWidget {
  final String documentID; // Ambil dari MedisScreen

  const TherapyScreen({Key? key, required this.documentID}) : super(key: key);

  @override
  _TherapyScreenState createState() => _TherapyScreenState();
}

class _TherapyScreenState extends State<TherapyScreen> {
  bool _isInTherapy = false; // Apakah sedang menjalani terapi obat?
  List<String> _diseases = ["Diabetes", "Jantung", "Hipertensi", "Asma"];
  List<String> _selectedDrugs = []; // Obat yang dipilih pengguna
  List<String> _searchHistory = []; // Riwayat pencarian penyakit
  String _selectedDisease = ''; // Penyakit yang dipilih
  Map<String, List<String>> _drugTimings =
      {}; // Waktu minum obat untuk setiap obat

  final TextEditingController _diseaseController = TextEditingController();
  final TextEditingController _drugController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  String userName = ''; // Nama pengguna diambil dari SharedPreferences

  @override
  void initState() {
    super.initState();
    _loadUserName(); // Memuat nama pengguna saat inisialisasi
  }

  // Fungsi untuk memuat nama pengguna dari SharedPreferences
  Future<void> _loadUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('userName') ??
          'Pengguna'; // Default ke "Pengguna" jika tidak ada
    });
  }

  // Fungsi untuk menambahkan obat
  void _addDrug() {
    if (_drugController.text.isNotEmpty && _timeController.text.isNotEmpty) {
      setState(() {
        _selectedDrugs.add(_drugController.text);
        _drugTimings[_drugController.text] = [_timeController.text];
        _drugController.clear();
        _timeController.clear();
      });
    }
  }

  // Fungsi untuk menampilkan daftar penyakit default
  List<String> _getFilteredDiseases(String query) {
    return _diseases
        .where((disease) => disease.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  // Fungsi untuk menambahkan ke riwayat pencarian
  void _addToSearchHistory(String disease) {
    if (!_searchHistory.contains(disease)) {
      setState(() {
        _searchHistory.add(disease);
      });
    }
  }

  // Fungsi untuk menampilkan tombol Tanya Apoteker (placeholder)
  void _tanyaApoteker() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Menghubungi apoteker...")),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header dan ID
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Pemantauan Terapi Obat",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    // Menampilkan nama pengguna yang dimuat dari SharedPreferences
                    Text("Halo, $userName!",
                        style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          "ID : ${widget.documentID}", // Ambil ID dari MedisScreen
                          style: const TextStyle(
                              color: Colors.green,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Pencarian penyakit
              const Text(
                "Perawatan apa yang sedang Anda jalani?",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _diseaseController,
                decoration: InputDecoration(
                  hintText: "Mencari",
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onChanged: (query) {
                  setState(() {
                    _selectedDisease = query;
                  });
                },
                onSubmitted: (query) {
                  _addToSearchHistory(query);
                },
              ),
              const SizedBox(height: 10),

              // Menampilkan penyakit yang sudah disiapkan secara default
              if (_selectedDisease.isNotEmpty)
                Wrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children:
                      _getFilteredDiseases(_selectedDisease).map((disease) {
                    return Chip(
                      label: Text(disease),
                      onDeleted: () {
                        setState(() {
                          _diseaseController.clear();
                          _selectedDisease = '';
                        });
                      },
                    );
                  }).toList(),
                ),
              const SizedBox(height: 10),

              // Menampilkan riwayat pencarian penyakit
              if (_searchHistory.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Riwayat Pencarian",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Wrap(
                      spacing: 8.0,
                      children: _searchHistory.map((history) {
                        return Chip(
                          label: Text(history),
                          onDeleted: () {
                            setState(() {
                              _searchHistory.remove(history);
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              const SizedBox(height: 20),

              // Pertanyaan apakah sedang dalam terapi obat
              const Text(
                "Apakah sedang dalam terapi obat?",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            _isInTherapy ? Colors.green : Colors.grey.shade300,
                      ),
                      onPressed: () {
                        setState(() {
                          _isInTherapy = true;
                        });
                      },
                      child: const Text(
                        'Ya',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),

                  // Tombol lain untuk pilihan "Tidak"
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            !_isInTherapy ? Colors.red : Colors.grey.shade300,
                      ),
                      onPressed: () {
                        setState(() {
                          _isInTherapy = false;
                          _selectedDrugs
                              .clear(); // Bersihkan input obat jika "Tidak" dipilih
                        });
                      },
                      child: const Text(
                        'Tidak',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Obat yang dikonsumsi
              if (_isInTherapy) ...[
                const Text(
                  "Obat apa yang dikonsumsi?",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _drugController,
                        decoration: const InputDecoration(
                          hintText: "Tuliskan obat...",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      onPressed: _addDrug,
                      child: const Text(
                        "Tambah",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Input untuk waktu minum obat
                const Text(
                  "Waktu Minum Obat",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _timeController,
                  decoration: const InputDecoration(
                    hintText: "Misal: 10:00 WIB",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),

                // Menampilkan obat yang ditambahkan
                if (_selectedDrugs.isNotEmpty)
                  Column(
                    children: _selectedDrugs.map((drug) {
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: ListTile(
                          leading: const Icon(Icons.medical_services,
                              color: Colors.green),
                          title: Text(drug),
                          subtitle: Text(
                              "Waktu Minum Obat: ${_drugTimings[drug]?.join(", ")}"),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              setState(() {
                                _selectedDrugs.remove(drug);
                                _drugTimings.remove(drug);
                              });
                            },
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                const SizedBox(height: 20),
              ] else ...[
                const Text(
                  "Obat apa yang dikonsumsi?",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        enabled: false,
                        decoration: const InputDecoration(
                          hintText: "Tuliskan...",
                          border: OutlineInputBorder(),
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                      ),
                      onPressed:
                          null, // Tidak bisa di klik jika tidak dalam terapi
                      child: const Text(
                        "Tambah",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],

              // Tombol Tanya Apoteker
              ElevatedButton(
                onPressed: _tanyaApoteker,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: const Center(
                  child: Text(
                    "Tanya Apoteker",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Tombol di bawah
              if (_isInTherapy)
                ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Data berhasil disimpan")),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Center(
                    child: Text(
                      "Berikutnya",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
