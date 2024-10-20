import 'package:flutter/material.dart';
import 'package:mavis/PanduanFoto/Salah.dart';

class PanduanFotoResepScreen extends StatelessWidget {
  const PanduanFotoResepScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: const Text(
          'Tanya Apoteker',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Cara yang tepat untuk memotret resep obat',
              style: TextStyle(fontSize: 16, color: Colors.black),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // Border with image inside and check icon in the center
            Stack(
              clipBehavior: Clip.none, // Ensure elements are not clipped
              alignment: Alignment.bottomCenter,
              children: [
                // Border with image
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      'assets/icons/MedicationB.png', // Placeholder image
                      fit: BoxFit
                          .contain, // Ensure the image doesn't get cut off
                    ),
                  ),
                ),
                // Check icon centered
                Positioned(
                  bottom: -35, // More space to ensure full visibility
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.green, width: 2),
                    ),
                    padding: const EdgeInsets.all(4.0),
                    child: const Icon(
                      Icons.check_circle,
                      color: Colors.green,
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
                  // Navigasi ke TanyaApotekerSalahScreen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TanyaApotekerSalahScreen(),
                    ),
                  );
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
