import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:mavis/constants/colors.dart';
import 'package:mavis/nutrition/nutrition.dart';
import 'dart:async';

class Scanner extends StatefulWidget {
  const Scanner({super.key});

  @override
  ScannerState createState() => ScannerState();
}

class ScannerState extends State<Scanner> with SingleTickerProviderStateMixin {
  CameraController? _cameraController;
  late List<CameraDescription> _cameras;
  int _selectedCameraIndex = 0;
  bool _isFlashOn = false;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    initializeCamera();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);
  }

  Future<void> initializeCamera() async {
    _cameras = await availableCameras();
    _cameraController =
        CameraController(_cameras[_selectedCameraIndex], ResolutionPreset.high);
    await _cameraController!.initialize();
    if (!mounted) return;
    setState(() {});
  }

  void _toggleFlash() async {
    if (_cameraController != null) {
      _isFlashOn = !_isFlashOn;
      await _cameraController!
          .setFlashMode(_isFlashOn ? FlashMode.torch : FlashMode.off);
      setState(() {});
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text('Identify the food', textAlign: TextAlign.center),
        ),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(
              _isFlashOn ? Icons.flash_on : Icons.flash_off,
              color: Colors.white,
            ),
            onPressed: _toggleFlash,
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: CameraPreview(_cameraController!),
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Stack(
                    children: [
                      Positioned(
                        top: _animation.value * 230,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 2,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: AppColors.white,
                  backgroundColor: AppColors.gradient3,
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
                child: const Icon(Icons.camera_alt_outlined, size: 30),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showFoodInfo(BuildContext context, String imagePath) {
    const String canEatText = 'You can eat this!';
    const String mainFoodName = 'Rice';
    const String descriptionContent =
        'Rice is uncooked rice that has been cooked by boiling or steaming. The process of boiling or steaming rice is also known as cooking. Cooking is necessary to enhance the aroma of the rice and make it softer while maintaining its consistency.';
    const String nutritionTitle = 'nasi putih';

    final List<Map<String, String>> nutritionInfo = [
      {
        'label': 'Carbohydrate',
        'value': '39.8 g / 100 g',
        'icon': 'Icons.fastfood',
        'color': 'Colors.green',
      },
      {
        'label': 'Lemak',
        'value': '0.3 g / 100 g',
        'icon': 'Icons.water_drop_outlined',
        'color': 'Colors.blue',
      },
      {
        'label': 'Protein',
        'value': '3 g / 100 g',
        'icon': 'Icons.wb_sunny_outlined',
        'color': 'Colors.orangeAccent',
      },
    ];

    final List<Map<String, String>> aliasNameInfo = [
      {
        'label': 'Fried Rice',
      },
      {
        'label': 'Rice',
      },
      {
        'label': 'Oryza Sativa',
      },
    ];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.5,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 100,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.check_outlined,
                            color: AppColors.baseColor1,
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Text(
                            canEatText,
                            style: TextStyle(
                              color: AppColors.baseColor1,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Center(
                      child: Text(
                        mainFoodName,
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: aliasNameInfo.map((info) {
                        return _buildTagChip(info['label']!);
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Description',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      descriptionContent,
                      style: TextStyle(fontSize: 12),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      'From Nilai Gizi, Kandungan gizi $nutritionTitle',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.gray600,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: nutritionInfo.map((info) {
                        return _buildNutritionInfo(
                          icon: _getIconFromString(info['icon']!),
                          label: info['label']!,
                          value: info['value']!,
                          color: _getColorFromString(info['color']!),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 30),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: AppColors.baseColor4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 20.0),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NutritionPage(
                                foodItems: [
                                  {
                                    'imagePath': imagePath,
                                    'name': 'Rice',
                                    'sugar': '0.1',
                                    'calories': '130',
                                  },
                                ],
                              ),
                            ),
                          );
                        },
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.bookmark_outline, size: 20),
                            SizedBox(width: 8),
                            Text('Save what you eat!',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                )),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  IconData _getIconFromString(String iconName) {
    switch (iconName) {
      case 'Icons.fastfood':
        return Icons.fastfood;
      case 'Icons.water_drop_outlined':
        return Icons.water_drop_outlined;
      case 'Icons.wb_sunny_outlined':
        return Icons.wb_sunny_outlined;
      default:
        return Icons.dehaze_outlined;
    }
  }

  Color _getColorFromString(String colorString) {
    switch (colorString) {
      case 'Colors.green':
        return AppColors.baseColor1;
      case 'Colors.blue':
        return Colors.blue;
      case 'Colors.orangeAccent':
        return Colors.orangeAccent;
      default:
        return AppColors.baseColor1;
    }
  }

  Widget _buildTagChip(String label) {
    return Chip(
      label: Text(
        label,
        style: const TextStyle(color: Colors.black45),
      ),
      backgroundColor: AppColors.gray300,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: Colors.transparent),
      ),
    );
  }

  Widget _buildNutritionInfo({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color),
        const SizedBox(height: 5),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        Text(value, style: const TextStyle(fontSize: 14)),
      ],
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
