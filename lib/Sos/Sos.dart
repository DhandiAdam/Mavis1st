import 'package:flutter/material.dart';
import 'package:mavis/constants/colors.dart';
import 'package:mavis/ConctactScreen/ContactScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SOS App',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const SOSScreen(),
    );
  }
}

class SOSScreen extends StatefulWidget {
  const SOSScreen({Key? key}) : super(key: key);

  @override
  _SOSScreenState createState() => _SOSScreenState();
}

class _SOSScreenState extends State<SOSScreen> {
  String sosStatus = "Kamu aman sekarang";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
        title: const Text(
          'SOS',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz, color: Colors.black),
            onPressed: () {
              // Tambahkan fungsi di sini
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // Tombol Pengaturan Kontak
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ContactSettingsScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white, // Background putih terang
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                shape: RoundedRectangleBorder(
                  side: const BorderSide(
                    color: AppColors.baseColor2, // Border hijau terang
                    width: 2, // Ketebalan border
                  ),
                  borderRadius: BorderRadius.circular(18.0),
                ),
              ),
              child: const Text(
                "Pengaturan Kontak",
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.baseColor2, // Warna teks hijau terang
                ),
              ),
            ),
            const SizedBox(height: 50),

            // Pusatkan ikon SOS dengan Center
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Outer white glowing effect
                  Container(
                    height: 230, // Outer white outline size
                    width: 230,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.withOpacity(0.5), // Glow color
                          spreadRadius: 20,
                          blurRadius: 30,
                          offset: const Offset(0, 0), // Shadow direction
                        ),
                      ],
                    ),
                  ),
                  // Inner gradient SOS button
                  GestureDetector(
                    onTap: () {
                      // Toggle status when tapped
                      setState(() {
                        sosStatus = sosStatus == "Kamu aman sekarang"
                            ? "SOS aktif"
                            : "Kamu aman sekarang";
                      });
                    },
                    child: Container(
                      height: 200,
                      width: 200,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF4AC35E), // Warna atas ke tengah
                            Color(0xFF5AF469), // Warna tengah ke bawah
                          ],
                          stops: [0.5, 1.0], // Mengatur gradien
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "SOS",
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(0.2),
                                  offset: const Offset(2, 2),
                                  blurRadius: 5,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            sosStatus,
                            style: const TextStyle(
                              fontSize: 16,
                              color: AppColors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              sosStatus,
              style: const TextStyle(
                fontSize: 18,
                color: AppColors.gray700, // Menggunakan warna AppColors
              ),
            ),
          ],
        ),
      ),
    );
  }
}
