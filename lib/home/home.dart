import 'package:flutter/material.dart';
import 'package:mavis/profile/profile.dart'; // Pastikan Anda telah membuat halaman Profile sesuai kebutuhan
import 'package:mavis/constants/colors.dart';
import 'dart:async';
import 'package:fl_chart/fl_chart.dart';
import 'package:mavis/nutrition/nutrition.dart';
import 'package:mavis/afterEat/AfterEat.dart';
import 'package:mavis/Sos/Sos.dart';

class HomePage extends StatefulWidget {
  final String userName; // Definisikan userName

  HomePage({required this.userName}); // Tambahkan parameter di konstruktor

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String userName; // Simpan nama pengguna secara lokal di dalam state
  final String sleep = '8h 20m';
  final String calories = '760 kCal';
  double heartRate = 78.0;
  List<FlSpot> heartRateSpots = [];
  Timer? _timer;
  double tick = 0; // Variable to track time

  @override
  void initState() {
    super.initState();
    userName = widget.userName; // Inisialisasi nama dari widget
    // Timer untuk memperbarui heart rate setiap 3 detik
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      setState(() {
        tick += 1;
        // Mengupdate heart rate setiap 3 detik, dengan batasan 50-150 BPM
        heartRate = 60 + (20 * (tick % 5)).toDouble();
        if (heartRate > 150) {
          heartRate = 150; // Membatasi heart rate tidak lebih dari 150 BPM
        }

        // Tambahkan heart rate baru ke dalam spots
        heartRateSpots.add(FlSpot(tick, heartRate));

        // Jika sudah mencapai batas X (20), reset dan mulai dari awal
        if (tick >= 20) {
          tick = 0; // Reset tick to restart from the beginning
          heartRateSpots.clear(); // Clear old data to start fresh
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // Fungsi untuk membuka halaman profil dan menerima nama yang diperbarui
  void _editProfile() async {
    final newName = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Profile(
          currentName: userName, // Kirim nama saat ini ke halaman profil
          updateName: (newName) {
            // Fungsi yang digunakan untuk memperbarui nama di HomePage
            setState(() {
              userName = newName; // Perbarui nama di halaman home
            });
          },
        ),
      ),
    );

    // Jika nama diperbarui dan dikembalikan
    if (newName != null && newName is String) {
      setState(() {
        userName = newName; // Perbarui nama di halaman home
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        toolbarHeight: 100,
        title: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Selamat Datang,',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.greySmooth,
                ),
              ),
              const SizedBox(
                  height:
                      9), // Menambahkan jarak antara "Selamat Datang" dan nama
              GestureDetector(
                onTap: _editProfile, // Buka halaman profil saat nama diklik
                child: Text(
                  '$userName!',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 25.0, vertical: 0.0),
                    child: Text(
                      'Status Aktivitas',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(right: 25.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SOSScreen()),
                        );
                      },
                      child: _buildServicSos(
                        Image.asset(
                          'assets/icons/SOS.png',
                          width: 60,
                          height: 60,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Heart Rate Graph
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3), // shadow position
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Heart Rate",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                "${heartRate.toInt()} BPM",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: heartRate > 120
                                      ? Colors.red
                                      : Colors.green.shade700,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Container(
                            height: 150,
                            child: LineChart(
                              LineChartData(
                                minX: 0,
                                maxX: 20, // Reset when reaching 20
                                minY: 50,
                                maxY: 150,
                                lineBarsData: [
                                  LineChartBarData(
                                    spots: heartRateSpots,
                                    isCurved: true,
                                    colors: heartRate > 120
                                        ? [Colors.red]
                                        : [Colors.green.shade700],
                                    barWidth: 4,
                                    isStrokeCapRound: true,
                                    belowBarData: BarAreaData(
                                      show: true,
                                      colors: heartRate > 120
                                          ? [Colors.red.withOpacity(0.3)]
                                          : [Colors.green.withOpacity(0.3)],
                                    ),
                                  ),
                                ],
                                titlesData: FlTitlesData(
                                  show: false, // Menyembunyikan labels sumbu
                                ),
                                gridData: FlGridData(
                                  show: true,
                                  getDrawingHorizontalLine: (value) {
                                    return FlLine(
                                      color: Colors.grey.shade300,
                                      strokeWidth: 1,
                                    );
                                  },
                                  drawVerticalLine: false,
                                ),
                                borderData: FlBorderData(
                                  show: false,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Heart Rate Info
              Center(
                child: Text(
                  '${heartRate.toInt()} BPM',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: heartRate >= 130 ? Colors.red : AppColors.baseColor2,
                  ),
                ),
              ),

              // Kalori dan Tidur
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildCard(
                    title: 'Kalori',
                    subtitle: calories,
                    image: 'assets/icons/Calories-Pie.png',
                  ),
                  _buildCard(
                    title: 'Tidur',
                    subtitle: sleep,
                    image: 'assets/icons/Sleep-Graph.png',
                  ),
                ],
              ),

              // Icon bar
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildServiceButton(
                    context,
                    Image.asset(
                      'assets/icons/Food.png',
                      width: 40,
                      height: 40,
                    ),
                    const NutritionPage(),
                  ),
                  _buildServiceButton(
                      context,
                      Image.asset(
                        'assets/icons/Hungry.png',
                        width: 40,
                        height: 40,
                      ),
                      const AfterMealScreen()),
                  _buildServiceButton(
                      context,
                      Image.asset(
                        'assets/icons/Goal.png',
                        width: 40,
                        height: 40,
                      ),
                      const AfterMealScreen()),
                  _buildServiceButton(
                      context,
                      Image.asset(
                        'assets/icons/Pill.png',
                        width: 40,
                        height: 40,
                      ),
                      const AfterMealScreen()),
                ],
              ),
              const SizedBox(
                  height: 40), // Padding bottom supaya tidak overflow
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required String subtitle,
    required String image,
    Color? color,
  }) {
    return Container(
      width: 150,
      height: 180,
      decoration: BoxDecoration(
        color: color ?? Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              subtitle,
              style: const TextStyle(
                color: AppColors.baseColor3,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Center(
              child: Image.asset(
                image,
                fit: BoxFit.contain,
                width: 80,
                height: 80,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceButton(BuildContext context, Widget icon, Widget page,
      {Color backgroundColor = AppColors.baseColor3}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        },
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.all(8.0),
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                AppColors.gradientStart,
                AppColors.gradientEnd
              ], // Warna gradient
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: icon,
          ),
        ),
      ),
    );
  }

  Widget _buildServicSos(Widget icon,
      {Color backgroundColor = AppColors.baseColor4}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SOSScreen()),
          );
        },
        borderRadius: BorderRadius.circular(30),
        child: Container(
          padding: const EdgeInsets.all(8.0),
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.gradientsosStart, AppColors.gradientsosEnd],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Center(
            child: icon,
          ),
        ),
      ),
    );
  }
}
