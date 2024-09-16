import 'package:flutter/material.dart';
import 'package:mavis/constants/colors.dart';
import 'package:mavis/main_navigation.dart';
import 'package:mavis/styles/style.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class NutritionPage extends StatefulWidget {
  final List<Map<String, String>> foodItems;

  const NutritionPage({
    super.key,
    this.foodItems = const [],
  });

  @override
  NutritionPageState createState() => NutritionPageState();
}

class NutritionPageState extends State<NutritionPage> {
  String _selectedPeriod = 'Mingguan';
  List<Map<String, String>> _foodItems = [];

  @override
  void initState() {
    super.initState();
    _loadFoodItems();
  }

  Future<void> _loadFoodItems() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? savedFoodItems = prefs.getStringList('food_items');

    if (savedFoodItems != null) {
      setState(() {
        try {
          _foodItems = savedFoodItems.map((item) {
            final Map<String, dynamic> decoded = jsonDecode(item);
            return decoded.map((key, value) => MapEntry(key, value.toString()));
          }).toList();
        } catch (e) {
          // ignore: avoid_print
          print('Error decoding JSON: $e');
        }
      });
    }
  }

  Future<void> _deleteFoodItem(Map<String, String> foodItem) async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? savedFoodItems = prefs.getStringList('food_items');

    if (savedFoodItems != null) {
      String jsonFoodItem = jsonEncode(foodItem);
      savedFoodItems.removeWhere((item) => item == jsonFoodItem);

      await prefs.setStringList('food_items', savedFoodItems);

      setState(() {
        _foodItems.remove(foodItem);
      });
    }
  }

  String _getDayText(String? day) {
    if (day == null) return 'Unknown day';

    final today = DateTime.now();
    final currentDayName = _getDayName(today.weekday);

    if (day.toLowerCase() == currentDayName.toLowerCase()) {
      return 'Hari ini';
    } else {
      return day;
    }
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
    final today = _changeDateTime(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Nutrisi',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
          ),
        ),
        centerTitle: true,
        foregroundColor: Colors.white,
        leading: Container(
          margin: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: AppColors.greySmooth,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Center(
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new),
              color: AppColors.gray600,
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MainNavigation(),
                  ),
                  (route) => false,
                );
              },
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Nutrisi Makanan",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                DropdownButtonHideUnderline(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 5.0, vertical: 0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      gradient: appGradient(),
                    ),
                    child: DropdownButton<String>(
                      value: _selectedPeriod,
                      items: ['Mingguan', 'Bulanan', 'Tahunan']
                          .map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: const TextStyle(color: AppColors.white),
                          ),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _selectedPeriod = newValue!;
                        });
                      },
                      iconEnabledColor: AppColors.white,
                      dropdownColor: AppColors.gradient2,
                      style: const TextStyle(color: AppColors.white),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Image.asset(
              'assets/icons/Graph-nutrition.png',
              fit: BoxFit.cover,
              width: double.infinity,
              height: 200,
            ),
            const SizedBox(height: 20),
            Text(
              today,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _foodItems.isEmpty
                  ? const Center(
                      child: Text('Data Kosong'),
                    )
                  : ListView.builder(
                      itemCount: _foodItems.length,
                      itemBuilder: (context, index) {
                        final foodItem = _foodItems[index];
                        return _buildFoodItemCard(foodItem);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFoodItemCard(Map<String, String> foodItem) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 5,
      shadowColor: Colors.black.withOpacity(0.5),
      child: ListTile(
        leading: SizedBox(
          width: 40,
          height: 40,
          child: foodItem['imagePath'] != null
              ? Image.file(
                  File(foodItem['imagePath']!),
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                )
              : const Icon(Icons.image, size: 40),
        ),
        title: Text(
          foodItem['name'] ?? 'Makanan',
          style:
              const TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
        ),
        subtitle: Text(
          '${_getDayText(foodItem['day'])} | ${foodItem['time'] ?? 'No time'}',
          style: const TextStyle(color: Colors.black54),
        ),
        trailing: IconButton(
          icon: Image.asset(
            'assets/icons/delete.png',
            width: 40,
            height: 40,
          ),
          onPressed: () {
            _showDeleteConfirmationDialog(foodItem);
          },
        ),
        onTap: () => _showFoodDetails(context, foodItem),
      ),
    );
  }

  void _showDeleteConfirmationDialog(Map<String, String> foodItem) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Konfirmasi Hapus"),
          content: const Text("Apakah Anda yakin ingin menghapus makanan ini?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Batal"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteFoodItem(foodItem);
              },
              child: const Text("Hapus", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  // Show food details in a dialog
  void _showFoodDetails(BuildContext context, Map<String, String> foodItem) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
              Center(
                child: Text(
                  foodItem['name'] ?? 'Food Details',
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: foodItem['imagePath'] != null
                    ? Image.file(
                        File(foodItem['imagePath']!),
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      )
                    : const Icon(Icons.image, size: 100),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildNutritionInfo(
                    icon: Icons.fastfood,
                    label: 'Karbohidrat',
                    value: foodItem['karbohidrat'] ?? '0',
                    color: Colors.green,
                  ),
                  _buildNutritionInfo(
                    icon: Icons.water_drop_outlined,
                    label: 'Lemak',
                    value: foodItem['lemak'] ?? '0',
                    color: Colors.blue,
                  ),
                  _buildNutritionInfo(
                    icon: Icons.wb_sunny_outlined,
                    label: 'Protein',
                    value: foodItem['protein'] ?? '0',
                    color: Colors.orangeAccent,
                  ),
                ],
              ),
            ],
          ),
        );
      },
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
        Text('$value g / 100 g', style: const TextStyle(fontSize: 14)),
      ],
    );
  }

  String _changeDateTime(DateTime date) {
    final month = date.month;
    final year = date.year;
    final day = date.day;
    final monthName = month == 1
        ? 'Januari'
        : month == 2
            ? 'Februari'
            : month == 3
                ? 'Maret'
                : month == 4
                    ? 'April'
                    : month == 5
                        ? 'Mei'
                        : month == 6
                            ? 'Juni'
                            : month == 7
                                ? 'Juli'
                                : month == 8
                                    ? 'Agustus'
                                    : month == 9
                                        ? 'September'
                                        : month == 10
                                            ? 'Oktober'
                                            : month == 11
                                                ? 'November'
                                                : 'Desember';
    return '$day $monthName $year';
  }
}
