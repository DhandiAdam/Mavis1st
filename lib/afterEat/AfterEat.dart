import 'package:flutter/material.dart';

class AfterMealScreen extends StatefulWidget {
  const AfterMealScreen({Key? key}) : super(key: key);

  @override
  _AfterMealScreenState createState() => _AfterMealScreenState();
}

class _AfterMealScreenState extends State<AfterMealScreen> {
  double _progress = 0.0; // Nilai progres dari 0 hingga 1
  int _sugarLevel = 0; // Nilai gula darah mulai dari 0 mg/dL
  bool isCompleted = false; // Untuk mengecek apakah progres sudah selesai
  String activity = ''; // Deskripsi aktivitas terakhir
  int currentActivity = 0; // Indikator aktivitas saat ini

  // Update status gula darah berdasarkan aktivitas yang selesai
  void _updateSugarLevel() {
    setState(() {
      switch (currentActivity) {
        case 0:
          _sugarLevel += 50; // Jalan cepat menurunkan gula darah 50 mg/dL
          activity = 'Jalan Cepat selama 30 menit';
          break;
        case 1:
          _sugarLevel += 30; // Berlari menurunkan gula darah 30 mg/dL
          activity = 'Berlari selama 30 menit';
          break;
        case 2:
          _sugarLevel += 20; // Bersepeda sedang menurunkan gula darah 20 mg/dL
          activity = 'Bersepeda Sedang selama 30 menit';
          break;
        case 3:
          _sugarLevel +=
              (_sugarLevel * 0.19).round(); // Bersepeda cepat menurunkan 19%
          activity = 'Bersepeda Cepat selama 60 menit';
          break;
        case 4:
          _sugarLevel += 20; // Aerobik menurunkan gula darah 20 mg/dL
          activity = 'Aerobik Intensitas Sedang selama 30 menit';
          break;
        case 5:
          _sugarLevel += 30; // Berenang menurunkan gula darah 30 mg/dL
          activity = 'Berenang selama 30 menit';
          break;
        default:
          break;
      }

      // Progres bar bertambah setiap kali aktivitas selesai
      if (_progress < 1.0) {
        _progress += 0.16; // Setiap aktivitas selesai menambah 1/6 progres
        currentActivity++; // Beralih ke aktivitas selanjutnya
      }

      if (_progress >= 1.0) {
        _progress = 1.0; // Set progres maksimum ke 1
        isCompleted = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Gradient Hijau di atas
            Container(
              height: 500,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF73DD6A),
                    Color(0xFF55FF8E),
                  ],
                ),
              ),
              child: Column(
                children: [
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back_ios,
                                color: Colors.white),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          const Text(
                            "Setelah Makan",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            icon: const Icon(Icons.more_horiz,
                                color: Colors.white),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Image.asset(
                      'assets/icons/Vector.png',
                      height: 250,
                      width: 250,
                    ),
                  ),
                ],
              ),
            ),

            // Kondisi Tubuh Anda
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Kondisi tubuh anda",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Status Gula Darah dan ProgressBar
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: const [
                                Icon(
                                  Icons.calendar_today,
                                  size: 20,
                                  color: Colors.blueAccent,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  "Status Gula Darah",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              "$_sugarLevel mg/dL", // Tampilan nilai gula darah
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // Progress Bar
                        LinearProgressIndicator(
                          value: _progress,
                          backgroundColor: Colors.grey.shade300,
                          color: Colors.blueAccent,
                          minHeight: 8.0,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Aktivitas Olahraga
                  const Text(
                    "Aktivitas Olahraga",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Aktivitas dengan gambar dan deskripsi
                  _buildActivityTile(
                    1,
                    'Jalan Cepat',
                    '30 menit',
                    'assets/icons/Hungry.png',
                    'Menurunkan kadar gula darah sekitar 50 mg/dL.',
                  ),
                  _buildActivityTile(
                    2,
                    'Berlari',
                    '30 menit',
                    'assets/icons/Hungry.png',
                    'Menurunkan kadar gula darah sekitar 30 mg/dL.',
                  ),
                  _buildActivityTile(
                    3,
                    'Bersepeda Sedang',
                    '30 menit',
                    'assets/icons/Hungry.png',
                    'Menurunkan kadar gula darah sekitar 20 mg/dL.',
                  ),
                  _buildActivityTile(
                    4,
                    'Bersepeda Cepat',
                    '60 menit',
                    'assets/icons/Hungry.png',
                    'Menurunkan gula darah sekitar 19% selama sehari.',
                  ),
                  _buildActivityTile(
                    5,
                    'Aerobik Intensitas Sedang',
                    '30 menit',
                    'assets/icons/Hungry.png',
                    'Menurunkan kadar gula darah sekitar 20 mg/dL.',
                  ),
                  _buildActivityTile(
                    6,
                    'Berenang',
                    '30 menit',
                    'assets/icons/Hungry.png',
                    'Membakar 300 kalori, menurunkan gula darah sekitar 30 mg/dL.',
                  ),
                  const SizedBox(height: 20),

                  // Rekomendasi
                  const Text(
                    "Rekomendasi",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Rekomendasi 1
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/icons/VectorOlahraga.png',
                              height: 100,
                              width: 100,
                            ),
                            const SizedBox(width: 20),
                            const Expanded(
                              child: Text(
                                "Disarankan untuk melakukan aktivitas fisik ringan setelah makan untuk membantu menjaga keseimbangan gula darah.",
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Rekomendasi 2
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/icons/VectorMinuman.png',
                              height: 100,
                              width: 100,
                            ),
                            const SizedBox(width: 20),
                            const Expanded(
                              child: Text(
                                "Minum air putih untuk mendukung metabolisme dan proses penyerapan karbohidrat.",
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Simulasikan progres bertambah dengan menekan tombol
          _updateSugarLevel(); // Tidak perlu dialog lagi, langsung perbarui progres
        },
        child: const Icon(Icons.fitness_center),
      ),
    );
  }

  // Widget untuk setiap aktivitas olahraga
  Widget _buildActivityTile(int number, String title, String duration,
      String imagePath, String description) {
    return ListTile(
      leading: CircleAvatar(
        radius: 20,
        backgroundColor: _progress >= (number * 0.16)
            ? Colors.blueAccent
            : Colors.grey.shade400, // Berubah berdasarkan progres
        child: Text(
          "$number",
          style: const TextStyle(color: Colors.white),
        ),
      ),
      title: Text("$duration $title"),
      subtitle: Text(description),
      trailing: Image.asset(imagePath, width: 40, height: 40),
    );
  }
}
