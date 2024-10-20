import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TherapyScreen extends StatefulWidget {
  final String documentID;

  const TherapyScreen({Key? key, required this.documentID}) : super(key: key);

  @override
  _TherapyScreenState createState() => _TherapyScreenState();
}

class _TherapyScreenState extends State<TherapyScreen> {
  bool _isInTherapy = false;
  List<String> _selectedDrugs = [];
  Map<String, List<String>> _drugTimings = {};
  String userName = '';
  final TextEditingController _drugController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('userName') ?? 'Pengguna';
    });
  }

  void _addDrug() {
    if (_drugController.text.isNotEmpty) {
      setState(() {
        // Mengubah input obat menjadi huruf kapital
        String drug = _drugController.text.toUpperCase();
        _selectedDrugs.add(drug);
        _drugTimings[drug] = ['10:00 WIB', '16:00 WIB', '21:00 WIB'];
        _drugController.clear();
      });
    }
  }

  void _removeDrug(String drug) {
    setState(() {
      _selectedDrugs.remove(drug);
      _drugTimings.remove(drug);
    });
  }

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
                    Text("Halo, $userName!",
                        style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          "ID : ${widget.documentID}",
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
                decoration: InputDecoration(
                  hintText: "Mencari",
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Apakah sedang dalam terapi obat?
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
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            !_isInTherapy ? Colors.red : Colors.grey.shade300,
                      ),
                      onPressed: () {
                        setState(() {
                          _isInTherapy = false;
                          _selectedDrugs.clear();
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
                TextField(
                  controller: _drugController,
                  decoration: const InputDecoration(
                    hintText: "Tuliskan obat...",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),

                // Tombol Tambah dan Tanya Apoteker
                Row(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        minimumSize: const Size(100, 48),
                      ),
                      onPressed: _addDrug,
                      child: const Text(
                        "Tambah",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF34BCAC),
                        ),
                        onPressed: _tanyaApoteker,
                        child: const Text(
                          "Tanya Apoteker(?)",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Menampilkan obat yang ditambahkan
                if (_selectedDrugs.isNotEmpty)
                  Column(
                    children: _selectedDrugs.map((drug) {
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Nama Obat',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        drug,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors
                                                .green), // Highlight nama obat
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: const [
                                      Text(
                                        "Waktu Minum Obat",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Icon(Icons.arrow_forward_ios, size: 14),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),

                              // Chip waktu
                              Wrap(
                                spacing: 8.0,
                                runSpacing: 8.0,
                                children: _drugTimings[drug]!.map((time) {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: Colors.green.shade100,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      time,
                                      style: const TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  // Tombol delete sekarang berada di kiri
                                  IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
                                    onPressed: () => _removeDrug(drug),
                                  ),
                                  const SizedBox(width: 10),
                                  // Ikon tanda seru dan teks "Belum Dikonfirmasi Apoteker"
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade300,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      children: const [
                                        Icon(Icons.error, color: Colors.red),
                                        SizedBox(width: 5),
                                        Text(
                                          'Belum Dikonfirmasi Apoteker',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                const SizedBox(height: 20),

                // Tombol Informasi Obat
                Align(
                  alignment: Alignment.centerLeft,
                  child: ElevatedButton(
                    onPressed: _selectedDrugs.isNotEmpty ? () {} : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "Informasi Obat",
                      style: TextStyle(fontSize: 14, color: Colors.white),
                    ),
                  ),
                ),
              ] else
                Container(),
              const SizedBox(height: 20),

              // Tombol Pharmaceutical Care
              Center(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF34BCAC),
                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 80),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text(
                    "Pharmaceutical Care",
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
