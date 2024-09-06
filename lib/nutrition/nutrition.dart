import 'package:flutter/material.dart';
import 'package:mavis/constants/colors.dart';
import 'package:mavis/main_navigation.dart';
import 'package:mavis/styles/style.dart';
import 'dart:io';

class NutritionPage extends StatefulWidget {
  final List<Map<String, String>> foodItems;

  const NutritionPage({
    super.key,
    required this.foodItems,
  });

  @override
  NutritionPageState createState() => NutritionPageState();
}

class NutritionPageState extends State<NutritionPage> {
  String _selectedPeriod = 'Weekly';

  @override
  Widget build(BuildContext context) {
    final totalSugar = _calculateTotalSugar();
    final totalCalories = _calculateTotalCalories();
    final today = _changeDateTime(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Nutrition',
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
                  "Meal Nutritions",
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
                      items:
                          ['Weekly', 'Monthly', 'Yearly'].map((String value) {
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
              child: ListView.builder(
                itemCount: widget.foodItems.length,
                itemBuilder: (context, index) {
                  final foodItem = widget.foodItems[index];
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
        leading: foodItem['imagePath'] != null
            ? Image.file(
                File(foodItem['imagePath']!),
                width: 40,
                height: 40,
                fit: BoxFit.cover,
              )
            : const Icon(Icons.image, size: 40),
        title: Text(
          foodItem['name'] ?? 'Food',
          style:
              const TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
        ),
        subtitle: Text(
          'Today | ${foodItem['time'] ?? 'No time'}',
          style: const TextStyle(color: Colors.black54),
        ),
        onTap: () => _showFoodDetails(context, foodItem),
      ),
    );
  }

  // Calculate total sugar from the list of food items
  String _calculateTotalSugar() {
    double totalSugar = 0.0;
    for (var item in widget.foodItems) {
      final sugar = double.tryParse(item['sugar'] ?? '0') ?? 0;
      totalSugar += sugar;
    }
    return totalSugar.toStringAsFixed(1);
  }

  // Calculate total calories from the list of food items
  String _calculateTotalCalories() {
    double totalCalories = 0.0;
    for (var item in widget.foodItems) {
      final calories = double.tryParse(item['calories'] ?? '0') ?? 0;
      totalCalories += calories;
    }
    return totalCalories.toStringAsFixed(1);
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
                    label: 'Carbohydrate',
                    value: foodItem['carbohydrate'] ?? '0',
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
