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
  bool showActivity = false; // Untuk mengontrol visibilitas aktivitas olahraga

  int _currentStep = 0; // Indikator tahapan progres misi harian (0-3)

  // Fungsi untuk memperbarui progres misi harian
  void _updateMissionProgress() {
    setState(() {
      if (_progress < 1.0) {
        _progress += 0.33; // Setiap langkah menambah progres 1/3
        _currentStep++; // Beralih ke tahapan berikutnya
      }
      if (_progress >= 1.0) {
        _progress = 1.0; // Menandakan bahwa misi harian selesai
      }
    });
  }

  // Fungsi untuk mengontrol visibilitas aktivitas olahraga
  void _toggleActivityVisibility() {
    setState(() {
      showActivity = !showActivity; // Toggle visibility
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
                      height: 300,
                      width: 300,
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

                  // List Misi dengan tahapan waktu dan garis penghubung titik-titik
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 15.0), // Adjust padding
                    child: Column(
                      children: [
                        _buildMissionStep(
                            1,
                            "30 menit",
                            "Kadar gula darah akan meningkat seiring dengan penyerapan karbohidrat.",
                            false),
                        _buildDivider(),
                        _buildMissionStep(
                            2,
                            "1 jam",
                            "Gula darah bisa mencapai puncaknya sekitar 130 mg/dL.",
                            false),
                        _buildDivider(),
                        _buildMissionStep(
                            3,
                            "2 jam",
                            "Gula darah akan mulai turun kembali ke normal.",
                            false),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Rekomendasi Olahraga
                  const Text(
                    "Rekomendasi Olahraga",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Border biru untuk rekomendasi olahraga tanpa outline
                  GestureDetector(
                    onTap: _toggleActivityVisibility,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
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

                  // Aktivitas Olahraga yang muncul setelah klik
                  if (showActivity)
                    Container(
                      color: Colors.white, // Warna putih di dalam border
                      child: Column(
                        children: [
                          _buildActivityTile(
                            1,
                            'Jalan Cepat',
                            '30 menit',
                            'assets/icons/Hungry.png',
                            'Menurunkan kadar gula darah sekitar 50 mg/dL.',
                            false, // Default abu-abu
                          ),
                          _buildActivityTile(
                            2,
                            'Berlari',
                            '30 menit',
                            'assets/icons/Hungry.png',
                            'Menurunkan kadar gula darah sekitar 30 mg/dL.',
                            false, // Default abu-abu
                          ),
                          _buildActivityTile(
                            3,
                            'Bersepeda Sedang',
                            '30 menit',
                            'assets/icons/Hungry.png',
                            'Menurunkan kadar gula darah sekitar 20 mg/dL.',
                            false, // Default abu-abu
                          ),
                          _buildActivityTile(
                            4,
                            'Bersepeda Cepat',
                            '60 menit',
                            'assets/icons/Hungry.png',
                            'Menurunkan gula darah sekitar 19% selama sehari.',
                            false, // Default abu-abu
                          ),
                          _buildActivityTile(
                            5,
                            'Aerobik Intensitas Sedang',
                            '30 menit',
                            'assets/icons/Hungry.png',
                            'Menurunkan kadar gula darah sekitar 20 mg/dL.',
                            false, // Default abu-abu
                          ),
                          _buildActivityTile(
                            6,
                            'Berenang',
                            '30 menit',
                            'assets/icons/Hungry.png',
                            'Membakar 300 kalori, menurunkan gula darah sekitar 30 mg/dL.',
                            false, // Default abu-abu
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 20),

                  // Rekomendasi Minuman tanpa outline
                  const Text(
                    "Rekomendasi Minuman",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),

                  Container(
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  //Rekomendasi Olahraga
  Widget _buildActivityTile(int number, String title, String duration,
      String imagePath, String description, bool isActive) {
    return ListTile(
      leading: CircleAvatar(
        radius: 15,
        backgroundColor: isActive ? Colors.blueAccent : Colors.grey.shade300,
        child: Text(
          "$number",
          style: const TextStyle(color: Colors.white),
        ),
      ),
      title: Text(
        "$duration $title",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: isActive ? Colors.black : Colors.grey.shade600,
        ),
      ),
      subtitle: Text(
        description,
        style: TextStyle(
          color: isActive ? Colors.black : Colors.grey.shade600,
        ),
      ),
      trailing: Image.asset(
        imagePath,
        width: 40,
        height: 40,
        color:
            isActive ? null : Colors.grey.shade600, // abu-abu jika belum aktif
      ),
    );
  }

  // Progres misi yang diatas
  Widget _buildMissionStep(
      int stepNumber, String time, String description, bool isActive) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 12,
            backgroundColor: isActive
                ? Colors.blueAccent
                : Colors.grey.shade300, // Aktif atau abu-abu
            child: isActive
                ? const Icon(Icons.check, color: Colors.white, size: 16)
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isActive ? Colors.black : Colors.grey.shade600,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: isActive ? Colors.black : Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      height: 5,
      width: 1,
      color: Colors.grey.shade300,
    );
  }
}
