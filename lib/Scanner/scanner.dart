import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:mavis/constants/colors.dart';
import 'package:mavis/nutrition/nutrition.dart';
import 'package:mavis/afterEat/AfterEat.dart';
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

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

  String _getDayName(int weekday) {
    switch (weekday) {
      case 1:
        return 'Senin';
      case 2:
        return 'Selasa';
      case 3:
        return 'Rabu';
      case 4:
        return 'Kamis';
      case 5:
        return 'Jumat';
      case 6:
        return 'Sabtu';
      case 7:
        return 'Minggu';
      default:
        return 'Unknown';
    }
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
                    final DateTime currentTime = DateTime.now();
                    if (context.mounted) {
                      _showFoodInfo(context, image.path, currentTime);
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

  void _showFoodInfo(
      BuildContext context, String imagePath, DateTime captureTime) {
    const String canEatText = 'Anda boleh makan ini!';
    const String mainFoodName = 'Nasi';
    const String karbohidrat = '40';
    const String lemak = '0';
    const String protein = '4';
    const String Kalori = '175';
    const String descriptionContent =
        'Nasi adalah beras mentah yang telah dimasak dengan cara direbus atau dikukus. Proses merebus atau mengukus beras juga dikenal dengan istilah memasak. Memasak diperlukan untuk meningkatkan aroma beras dan membuatnya lebih lembut sekaligus mempertahankan konsistensinya.';
    const String nutritionTitle = 'Nasi Putih';

    final List<Map<String, String>> nutritionInfo = [
      {
        'label': 'Karbohidrat',
        'value': '40',
        'icon': 'assets/icons/Carbo.png',
        'color': 'Colors.green',
      },
      {
        'label': 'Lemak',
        'value': '0',
        'icon': 'assets/icons/lemak2.png',
        'color': 'Colors.blue',
      },
      {
        'label': 'Protein',
        'value': '4',
        'icon': 'assets/icons/Protein.png',
        'color': 'Colors.orangeAccent',
      },
      {
        'label': 'Kalori',
        'value': '175',
        'icon': 'assets/icons/kalori_daging.png',
        'color': 'Colors.orangeAccent',
      },
    ];

    final List<Map<String, String>> aliasNameInfo = [
      {
        'label': 'Nasi Putih',
      },
      {
        'label': 'Nasi',
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
                      'Deskripsi',
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
                      'From Nilai Gizi, Kandungan Gizi $nutritionTitle',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.gray600,
                      ),
                    ),

                    // Garis horizontal di bawah teks
                    const SizedBox(height: 10),
                    const Divider(
                      color: Colors.grey, // warna garis
                      thickness: 1.5, // ketebalan garis
                    ),

                    const SizedBox(height: 10),

                    // Grid 2x2 untuk menampilkan ikon nutrisi
                    Column(
                      children: [
                        // Baris pertama (2 item)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: nutritionInfo.sublist(0, 2).map((info) {
                            return _buildNutritionInfo(
                              icon: _getImageFromString(
                                  info['icon']!), // Menggunakan gambar
                              label: info['label']!,
                              value: info['value']!,
                              color: _getColorFromString(info['color']!),
                            );
                          }).toList(),
                        ),
                        const SizedBox(
                            height: 20), // Jarak antara baris pertama dan kedua

                        // Baris kedua (2 item)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: nutritionInfo.sublist(2, 4).map((info) {
                            return _buildNutritionInfo(
                              icon: _getImageFromString(
                                  info['icon']!), // Menggunakan gambar
                              label: info['label']!,
                              value: info['value']!,
                              color: _getColorFromString(info['color']!),
                            );
                          }).toList(),
                        ),
                      ],
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

                          final Map<String, String> foodItem = {
                            'imagePath': imagePath,
                            'name': mainFoodName,
                            'karbohidrat': karbohidrat,
                            'lemak': lemak,
                            'protein': protein,
                            'time': '${captureTime.hour}:${captureTime.minute}',
                            'day': _getDayName(captureTime.weekday),
                          };
                          _saveFoodItem(foodItem);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NutritionPage(
                                foodItems: [foodItem],
                              ),
                            ),
                          );
                        },
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.bookmark_outline, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Simpan apa yang Anda makan!',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
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

  Widget _buildNutritionInfo({
    required Widget icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        // Container untuk membungkus icon
        Container(
          decoration: BoxDecoration(
            color:
                color.withOpacity(0.1), // Warna background sesuai dengan color
            borderRadius: BorderRadius.circular(15), // Membuat sudut rounded
          ),
          padding: const EdgeInsets.all(16), // Memperbesar padding untuk icon
          child: icon, // Menampilkan gambar/icon
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16, // Memperbesar teks label
          ),
        ),
        Text(
          '$value g / 100 g',
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Future<void> _saveFoodItem(Map<String, String> foodItem) async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? savedFoodItems = prefs.getStringList('food_items');
    savedFoodItems ??= [];

    savedFoodItems.insert(0, json.encode(foodItem));

    await prefs.setStringList('food_items', savedFoodItems);
  }

  Widget _getImageFromString(String imagePath) {
    return Image.asset(
      imagePath,
      height: 60, // Sesuaikan ukuran gambar
      width: 60,
      fit: BoxFit.contain, // Agar gambar proporsional
    );
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
}
