import 'package:flutter/material.dart';
import '../healthsummary.dart'; // Pastikan path ini sesuai dengan lokasi healthsummary.dart

class Together extends StatefulWidget {
  const Together({super.key});

  @override
  TogetherState createState() => TogetherState();
}

class TogetherState extends State<Together> {
  final _heartRateController = TextEditingController();
  final _bloodOxygenController = TextEditingController();
  final _bloodGlucoseController = TextEditingController();
  final _bloodPressureController = TextEditingController();
  final _bodyTemperatureController = TextEditingController();
  final _respiratoryRateController = TextEditingController();

  @override
  void dispose() {
    _heartRateController.dispose();
    _bloodOxygenController.dispose();
    _bloodGlucoseController.dispose();
    _bloodPressureController.dispose();
    _bodyTemperatureController.dispose();
    _respiratoryRateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Input Data'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildInputField(
              controller: _heartRateController,
              label: 'Heart Rate (BPM)',
              hint: 'Normal: 60-100 BPM',
            ),
            _buildInputField(
              controller: _bloodOxygenController,
              label: 'Blood Oxygen (%)',
              hint: 'Normal: 95-100%',
            ),
            _buildInputField(
              controller: _bloodGlucoseController,
              label: 'Blood Glucose (mg/dl)',
              hint: 'Normal: 70-140 mg/dl (before meal)',
            ),
            _buildInputField(
              controller: _bloodPressureController,
              label: 'Blood Pressure (mmHg)',
              hint: 'Normal: 90/60 - 120/80 mmHg',
            ),
            _buildInputField(
              controller: _bodyTemperatureController,
              label: 'Body Temperature (°C)',
              hint: 'Normal: 36.1°C - 37.2°C',
            ),
            _buildInputField(
              controller: _respiratoryRateController,
              label: 'Respiratory Rate (breath/min)',
              hint: 'Normal: 12-20 breaths/min',
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HealthSummaryPage(
                      heartRate: _heartRateController.text,
                      bloodOxygen: _bloodOxygenController.text,
                      bloodGlucose: _bloodGlucoseController.text,
                      bloodPressure: _bloodPressureController.text,
                      bodyTemperature: _bodyTemperatureController.text,
                      respiratoryRate: _respiratoryRateController.text,
                    ),
                  ),
                );
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: const OutlineInputBorder(),
        ),
        keyboardType: TextInputType.number,
      ),
    );
  }
}
