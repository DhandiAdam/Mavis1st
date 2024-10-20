import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChallengePage extends StatefulWidget {
  @override
  _ChallengePageState createState() => _ChallengePageState();
}

class _ChallengePageState extends State<ChallengePage> {
  int? targetSteps; // Target langkah yang diatur pengguna
  int currentSteps = 0; // Langkah saat ini (awalnya 0)
  int points = 0; // Poin yang dihitung berdasarkan langkah
  int stepIncrement = 1500; // Setiap 1000 langkah = 1 step

  TextEditingController _stepController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSavedTarget(); // Load target dari SharedPreferences
  }

  // Load target langkah dari SharedPreferences
  Future<void> _loadSavedTarget() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      targetSteps =
          int.tryParse(prefs.getString('stepTarget')?.split(' ')[0] ?? '8000');
      calculatePoints(); // Hitung poin berdasarkan target langkah yang dimuat
    });
  }

  // Hitung poin berdasarkan langkah yang dicapai
  void calculatePoints() {
    setState(() {
      points = 0; // Reset poin

      if (targetSteps == null) return; // Jika tidak ada target, hentikan

      if (targetSteps! >= 1000) {
        points = 10; // 1000 langkah = 10 poin
      }
      if (targetSteps! >= 2000) {
        points = 25; // 2000 langkah = 25 poin
      }
      if (targetSteps! >= 5000) {
        points = 50; // 5000 langkah = 50 poin
      }
      if (targetSteps! > 5000) {
        int extraSteps = targetSteps! - 5000;
        points +=
            (extraSteps ~/ 3000) * 30; // 30 poin setiap tambahan 3000 langkah
      }
    });
  }

  // Fungsi untuk mengedit target langkah
  void _editStepTarget() {
    _stepController.clear(); // Kosongkan input sebelumnya
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Target Langkah'),
        content: TextField(
          controller: _stepController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            hintText: 'Masukkan target langkah baru',
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              if (_stepController.text.isNotEmpty) {
                setState(() {
                  targetSteps = int.parse(_stepController.text);
                  _saveNewTarget(targetSteps!); // Simpan target baru
                  calculatePoints(); // Hitung ulang poin berdasarkan target baru
                });
                Navigator.pop(context); // Tutup dialog
              }
            },
            child: const Text('Simpan'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context), // Tutup dialog
            child: const Text('Batal'),
          ),
        ],
      ),
    );
  }

  // Simpan target langkah baru ke SharedPreferences
  Future<void> _saveNewTarget(int newTarget) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('stepTarget', '$newTarget langkah');
  }

  @override
  Widget build(BuildContext context) {
    int totalSteps = targetSteps ?? 8000; // Target default = 8000 langkah

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Tantangan',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: targetSteps == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // Align kiri
                children: [
                  // Target Hari Ini
                  Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Target Hari Ini',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Poin hadiah
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade50,
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                          color: Colors.white, width: 2),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Image.asset(
                                              'assets/icons/Rating.png',
                                              width: 38,
                                              height: 38,
                                            ),
                                            const SizedBox(
                                                width:
                                                    8), // Tambahkan spasi lebih besar
                                            Flexible(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    '$points', // Tampilkan poin yang dihitung
                                                    style: const TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Color(0xFF5D5FEF),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 2),
                                                  const Text(
                                                    'Hadiah',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.grey,
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
                                const SizedBox(
                                    width: 12), // Tambahkan spasi lebih besar
                                // Langkah kaki
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade50,
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                          color: Colors.white, width: 2),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Image.asset(
                                              'assets/icons/boots.png',
                                              width: 38,
                                              height: 38,
                                            ),
                                            const SizedBox(
                                                width:
                                                    8), // Tambahkan spasi lebih besar
                                            Flexible(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    '$totalSteps', // Tampilkan total langkah target
                                                    style: const TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Color(0xFF5D5FEF),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 2),
                                                  const Text(
                                                    'Langkah Kaki',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.grey,
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
                          ],
                        ),
                      ),

                      // Tombol Edit di pojok kanan atas
                      Positioned(
                        top: 0,
                        right: 0,
                        child: IconButton(
                          icon: Icon(Icons.edit, color: Colors.blueAccent),
                          onPressed:
                              _editStepTarget, // Panggil fungsi edit target
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'Berjalan Santai',
                    style: TextStyle(
                      fontWeight: FontWeight.bold, // Mengatur teks menjadi bold
                      fontSize: 16, // Opsional: Mengatur ukuran font
                    ),
                  ),

                  // Mode Normal
                  const Text(
                    'Mode Normal',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 10),

                  // Kemajuan section
                  const Text(
                    'Kemajuan',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),

                  Expanded(
                    child: ListView.builder(
                      itemCount: (totalSteps / stepIncrement).ceil(),
                      itemBuilder: (context, index) {
                        int step = (index + 1) * stepIncrement;
                        bool isCompleted = currentSteps >= step;
                        return _buildProgressStep(
                          index + 1,
                          '$step langkah kaki',
                          isCompleted ? 'Bagus, lanjutkan!' : '',
                          isCompleted,
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Status kemajuan
                  Center(
                    child: Text(
                      currentSteps < totalSteps
                          ? 'Kamu belum melakukannya...'
                          : 'Target Tercapai!',
                      style: TextStyle(
                        color: currentSteps < totalSteps
                            ? Colors.red
                            : Colors.green,
                        fontSize: 16,
                      ),
                    ),
                  ),

                  // Tombol claim hadiah jika target tercapai
                  if (currentSteps >= totalSteps)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: ElevatedButton(
                        onPressed: () {
                          print('Claim Hadiah!');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          'Claim Hadiah',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                ],
              ),
            ),
    );
  }

  // Progress langkah builder
  Widget _buildProgressStep(
      int stepNumber, String step, String status, bool isCompleted) {
    return ListTile(
      leading: CircleAvatar(
        radius: 15,
        backgroundColor: isCompleted ? Colors.green : Colors.grey.shade400,
        child: Text(
          stepNumber.toString(),
          style: const TextStyle(color: Colors.white),
        ),
      ),
      title: Text(step, style: const TextStyle(fontSize: 14)),
      subtitle: status.isNotEmpty ? Text(status) : null,
      trailing: isCompleted
          ? const Icon(Icons.check_circle, color: Colors.green)
          : const Icon(Icons.circle_outlined, color: Colors.grey),
    );
  }
}
