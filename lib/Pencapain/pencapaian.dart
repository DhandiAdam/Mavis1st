import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // SharedPreferences for local storage

void main() {
  runApp(MaterialApp(
    home: TargetPage(),
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
            child: Text('Simpan'),
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
          'Target saya',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.black87,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              _buildTargetItem(
                context,
                title: 'Target langkah',
                value: stepTarget,
                onTap: () => _editTarget('Target langkah',
                    'Masukkan target langkah', _stepController, (newValue) {
                  setState(() {
                    stepTarget = '$newValue langkah';
                  });
                }),
              ),
              _buildTargetItem(
                context,
                title: 'Berat target',
                value: weightTarget,
                onTap: () => _editTarget(
                    'Berat target', 'Masukkan berat target', _weightController,
                    (newValue) {
                  setState(() {
                    weightTarget = '$newValue kg';
                  });
                }),
              ),
              _buildTargetItem(
                context,
                title: 'Target kalori',
                value: calorieTarget,
                onTap: () => _editTarget('Target kalori',
                    'Masukkan target kalori', _calorieController, (newValue) {
                  setState(() {
                    calorieTarget = '$newValue kkal';
                  });
                }),
              ),
              _buildTargetItem(
                context,
                title: 'Target tidur',
                value: sleepTarget,
                onTap: () => _editTarget(
                    'Target tidur', 'Masukkan target tidur', _sleepController,
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
          color: Colors.black54,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 16),
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
