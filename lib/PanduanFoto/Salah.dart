import 'package:flutter/material.dart';

class TanyaApotekerSalahScreen extends StatelessWidget {
  const TanyaApotekerSalahScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Tanya Apoteker',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),

            // Judul untuk panduan yang salah
            const Text(
              'Cara yang salah untuk memotret resep obat',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // Gambar resep dalam border abu-abu dengan tanda silang
            Stack(
              clipBehavior: Clip.none, // Ensure elements are not clipped
              alignment: Alignment.bottomCenter,
              children: [
                // Border dengan gambar salah
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1),
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey.shade300, // Abu-abu untuk versi salah
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      'assets/icons/MedicationS.png', // Gambar versi salah
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Icon silang merah di bawah gambar
                Positioned(
                  bottom: -35, // More space to ensure full visibility
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.red, width: 2),
                    ),
                    padding: const EdgeInsets.all(4.0),
                    child: const Icon(
                      Icons.close,
                      color: Colors.red,
                      size: 48,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 60), // Adjusted space

            // Button "Berikutnya"
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Tambahkan aksi untuk button "Berikutnya"
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Berikutnya',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
