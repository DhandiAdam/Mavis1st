import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mavis/constants/colors.dart'; // Import your custom colors

void main() {
  runApp(MaterialApp(
    home: TargetPage(),
    theme: ThemeData(
      // Set overall app theme based on your color palette
      textTheme: const TextTheme(
        bodyLarge: TextStyle(
          color: Color.fromARGB(210, 250, 250, 250), // Muted white color
          shadows: [
            Shadow(
              offset: Offset(1.0, 1.0),
              blurRadius: 3.0,
              color: Color.fromARGB(80, 0, 0, 0), // Subtle shadow effect
            ),
          ],
        ),
        bodyMedium: TextStyle(
          color: Color.fromARGB(210, 250, 250, 250), // Muted white color
          shadows: [
            Shadow(
              offset: Offset(1.0, 1.0),
              blurRadius: 3.0,
              color: Color.fromARGB(80, 0, 0, 0), // Subtle shadow effect
            ),
          ],
        ),
        labelLarge: TextStyle(
          color: Color.fromARGB(210, 250, 250, 250), // Muted white color
          shadows: [
            Shadow(
              offset: Offset(1.0, 1.0),
              blurRadius: 3.0,
              color: Color.fromARGB(80, 0, 0, 0), // Subtle shadow effect
            ),
          ],
        ),
      ),
    ),
  ));
}

class TargetPage extends StatefulWidget {
  @override
  _TargetPageState createState() => _TargetPageState();
}

class _TargetPageState extends State<TargetPage> {
  TextEditingController _stepController = TextEditingController();
  TextEditingController _weightController = TextEditingController();
  TextEditingController _calorieController = TextEditingController();
  TextEditingController _sleepController = TextEditingController();

  String stepTarget = '5000 langkah';
  String weightTarget = '68 kg';
  String calorieTarget = '300 kkal';
  String sleepTarget = '6 jam';

  @override
  void initState() {
    super.initState();
    _loadSavedData(); // Load saved data when the app starts
  }

  // Load saved data from SharedPreferences
  Future<void> _loadSavedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      stepTarget = prefs.getString('stepTarget') ?? '5000 langkah';
      weightTarget = prefs.getString('weightTarget') ?? '68 kg';
      calorieTarget = prefs.getString('calorieTarget') ?? '300 kkal';
      sleepTarget = prefs.getString('sleepTarget') ?? '6 jam';
    });
  }

  // Save data to SharedPreferences
  Future<void> _saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('stepTarget', stepTarget);
    prefs.setString('weightTarget', weightTarget);
    prefs.setString('calorieTarget', calorieTarget);
    prefs.setString('sleepTarget', sleepTarget);
  }

  // Function to edit targets with placeholder
  void _editTarget(String title, String placeholder,
      TextEditingController controller, Function(String) onSave) {
    // Clear controller for showing placeholder
    controller.clear();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit $title'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: placeholder, // Display placeholder
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                onSave(controller.text);
                _saveData(); // Save data locally
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white, // White background
              shadowColor:
                  Colors.black.withOpacity(0.2), // Subtle shadow effect
              elevation: 8, // Shadow intensity
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ),
            ),
            child: Text(
              'Simpan',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black, // Text color
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Batal'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Target Saya',
          style: TextStyle(color: AppColors.white),
        ),
        backgroundColor: AppColors.baseColor1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
      ),
      body: Container(
        color: AppColors.baseColor1,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              _buildTargetItem(
                context,
                title: 'Target Langkah',
                value: stepTarget,
                onTap: () => _editTarget('Target Langkah',
                    'Masukkan target langkah', _stepController, (newValue) {
                  setState(() {
                    stepTarget = '$newValue langkah';
                  });
                }),
              ),
              _buildTargetItem(
                context,
                title: 'Berat Target',
                value: weightTarget,
                onTap: () => _editTarget(
                    'Berat Target', 'Masukkan berat target', _weightController,
                    (newValue) {
                  setState(() {
                    weightTarget = '$newValue kg';
                  });
                }),
              ),
              _buildTargetItem(
                context,
                title: 'Target Kalori',
                value: calorieTarget,
                onTap: () => _editTarget('Target Kalori',
                    'Masukkan target kalori', _calorieController, (newValue) {
                  setState(() {
                    calorieTarget = '$newValue kkal';
                  });
                }),
              ),
              _buildTargetItem(
                context,
                title: 'Target Tidur',
                value: sleepTarget,
                onTap: () => _editTarget(
                    'Target Tidur', 'Masukkan target tidur', _sleepController,
                    (newValue) {
                  setState(() {
                    sleepTarget = '$newValue jam';
                  });
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget for target items
  Widget _buildTargetItem(BuildContext context,
      {required String title,
      required String value,
      required Function() onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        decoration: BoxDecoration(
          color: Colors.white, // White background
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 3,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(color: Colors.black, fontSize: 16),
            ),
            Row(
              children: [
                Text(
                  value,
                  style: const TextStyle(color: Colors.grey, fontSize: 16),
                ),
                const Icon(Icons.chevron_right, color: Colors.grey),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
