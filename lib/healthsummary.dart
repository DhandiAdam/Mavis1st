import 'package:flutter/material.dart';

class HealthSummaryPage extends StatefulWidget {
  @override
  _HealthSummaryPageState createState() => _HealthSummaryPageState();
}

class _HealthSummaryPageState extends State<HealthSummaryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Perangkat',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          _buildDeviceCard(
            context,
            'assets/icons/Galaxy_Watch4.png', // Sesuaikan path gambar jam tangan
            'Samsung Galaxy Active2', // Nama perangkat pertama
            true, // Perangkat menyala
            68, // Persentase baterai
          ),
          const SizedBox(height: 20),
          _buildDeviceCard(
            context,
            'assets/icons/Glaaxy watch Fe.png', // Path gambar jam tangan Apple
            'Glaaxy watch Fe', // Nama perangkat kedua
            false, // Perangkat mati
            0, // Baterai kosong, perangkat mati
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceCard(BuildContext context, String imagePath,
      String deviceName, bool isOn, int batteryPercentage) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isOn ? Colors.blue.shade50 : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            Image.asset(
              imagePath,
              width: 60,
              height: 60,
            ),
            const SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  deviceName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.battery_full,
                      color: isOn ? Colors.green : Colors.grey,
                      size: 20,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      isOn ? '$batteryPercentage%' : 'Mati',
                      style: TextStyle(
                        fontSize: 14,
                        color: isOn ? Colors.black : Colors.red,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
