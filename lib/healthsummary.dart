import 'package:flutter/material.dart';
import 'nutrition/nutrition.dart';
import 'Scanner/scanner.dart';

class HealthSummaryPage extends StatelessWidget {
  final String heartRate;
  final String bloodOxygen;
  final String bloodGlucose;
  final String bloodPressure;
  final String bodyTemperature;
  final String respiratoryRate;

  const HealthSummaryPage({
    required this.heartRate,
    required this.bloodOxygen,
    required this.bloodGlucose,
    required this.bloodPressure,
    required this.bodyTemperature,
    required this.respiratoryRate,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Summary'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  _buildSummaryCard(
                    title: 'Heart Rate (BPM)',
                    value: heartRate,
                    normalRange: 'Normal: 60-100 BPM',
                  ),
                  _buildSummaryCard(
                    title: 'Blood Oxygen (%)',
                    value: bloodOxygen,
                    normalRange: 'Normal: 95-100%',
                  ),
                  _buildSummaryCard(
                    title: 'Blood Glucose (mg/dl)',
                    value: bloodGlucose,
                    normalRange: 'Normal: 70-140 mg/dl (before meal)',
                  ),
                  _buildSummaryCard(
                    title: 'Blood Pressure (mmHg)',
                    value: bloodPressure,
                    normalRange: 'Normal: 90/60 - 120/80 mmHg',
                  ),
                  _buildSummaryCard(
                    title: 'Body Temperature (°C)',
                    value: bodyTemperature,
                    normalRange: 'Normal: 36.1°C - 37.2°C',
                  ),
                  _buildSummaryCard(
                    title: 'Respiratory Rate (breath/min)',
                    value: respiratoryRate,
                    normalRange: 'Normal: 12-20 breaths/min',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal, // Background color
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NutritionPage(
                            foodItems: [], // Pass an empty list initially or modify as needed
                          ),
                        ),
                      );
                    },
                    child: const Text('Go to Nutrition'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange, // Background color
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Scanner(),
                        ),
                      );
                    },
                    child: const Text('Food Scanner'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String value,
    required String normalRange,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 5.0, // Added elevation for shadow effect
      child: ListTile(
        contentPadding: const EdgeInsets.all(16.0),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('Value: $value\n$normalRange'),
      ),
    );
  }
}
