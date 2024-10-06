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

                  // Timeline Gula Darah
                  Column(
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                          radius: 20,
                          backgroundColor: _progress >= 0.33
                              ? Colors.blueAccent
                              : Colors
                                  .grey.shade400, // Berubah berdasarkan progres
                          child: const Text(
                            "01",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        title: const Text("30 menit"),
                        subtitle: const Text(
                            "Kadar gula darah akan meningkat seiring dengan penyerapan karbohidrat."),
                      ),
                      ListTile(
                        leading: CircleAvatar(
                          radius: 20,
                          backgroundColor: _progress >= 0.66
                              ? Colors.blueAccent
                              : Colors
                                  .grey.shade400, // Berubah berdasarkan progres
                          child: const Text(
                            "02",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        title: const Text("1 jam"),
                        subtitle: const Text(
                            "Gula darah Anda bisa mencapai puncaknya sekitar 130 mg/dL."),
                      ),
                      ListTile(
                        leading: CircleAvatar(
                          radius: 20,
                          backgroundColor: _progress == 1.0
                              ? Colors.blueAccent
                              : Colors
                                  .grey.shade400, // Berubah berdasarkan progres
                          child: const Text(
                            "03",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        title: const Text("2 jam"),
                        subtitle: const Text(
                            "Gula darah akan mulai turun kembali ke normal, tergantung sensitivitas insulin tubuh Anda."),
                      ),
                    ],
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

                  // Rekomendasi 1 dengan background biru lembut
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

                  // Rekomendasi 2 dengan background biru lembut
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
          setState(() {
            if (_progress < 1.0) {
              _progress += 0.33;

              // Update nilai gula darah berdasarkan progres
              if (_progress == 0.33) {
                _sugarLevel = 30;
              } else if (_progress == 0.66) {
                _sugarLevel = 60;
              } else if (_progress >= 1.0) {
                _sugarLevel = 130;
                _progress = 1.0; // Pastikan progres penuh
                isCompleted = true;
              }
            }
          });
        },
        child: const Icon(Icons.fitness_center),
      ),
    );
  }
}
