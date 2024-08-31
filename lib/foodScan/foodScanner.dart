import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../nutrition.dart'; // Import NutritionPage

class FoodScannerPage extends StatefulWidget {
  const FoodScannerPage({super.key});

  @override
  FoodScannerPageState createState() => FoodScannerPageState();
}

class FoodScannerPageState extends State<FoodScannerPage> {
  CameraController? _cameraController;
  late List<CameraDescription> _cameras;

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  Future<void> initializeCamera() async {
    _cameras = await availableCameras();
    _cameraController = CameraController(_cameras[0], ResolutionPreset.high);
    await _cameraController!.initialize();
    if (!mounted) return;
    setState(() {});
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Food Scanner'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: CameraPreview(_cameraController!),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.teal,
                  backgroundColor: Colors.white,
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(20),
                  elevation: 10,
                ),
                onPressed: () async {
                  try {
                    final image = await _cameraController!.takePicture();

                    if (context.mounted) {
                      _showFoodInfo(context, image.path);
                    }
                  } catch (e) {
                    debugPrint('Error: $e');
                  }
                },
                child: const Icon(Icons.camera_alt, size: 30),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showFoodInfo(BuildContext context, String imagePath) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Food Information',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              _buildInfoRow(label: 'Food', value: 'Rice'),
              _buildInfoRow(label: 'Sugar', value: '0.1 g/100g'),
              _buildInfoRow(label: 'Calories', value: '130 kcal/100g'),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.teal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NutritionPage(
                        foodItems: [
                          {
                            'imagePath': imagePath, // Pass the image path
                            'name': 'Rice', // Food name
                            'sugar': '0.1', // Sugar value
                            'calories': '130', // Calories value
                          },
                        ],
                      ),
                    ),
                  );
                },
                child: const Text('Simpan'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoRow({required String label, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
