import 'package:flutter/material.dart';

class NutritionPage extends StatefulWidget {
  final List<Map<String, String>>
      foodItems; // List of food items with their details

  const NutritionPage({
    super.key,
    required this.foodItems,
  });

  @override
  NutritionPageState createState() => NutritionPageState();
}

class NutritionPageState extends State<NutritionPage> {
  @override
  Widget build(BuildContext context) {
    // Calculate total sugar and calories
    final totalSugar = _calculateTotalSugar();
    final totalCalories = _calculateTotalCalories();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nutrition'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildContainer(
                  title: 'Total Sugar',
                  value: '$totalSugar g', // Display total sugar
                ),
                _buildContainer(
                  title: 'Total Calories',
                  value: '$totalCalories kcal', // Display total calories
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4, // Number of columns
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: widget.foodItems.length, // Number of food items
                itemBuilder: (context, index) {
                  final foodItem = widget.foodItems[index];
                  return _buildSlot(foodItem);
                },
              ),
            ),
          ],
        ),
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
    return totalSugar.toStringAsFixed(1); // Format to 1 decimal place
  }

  // Calculate total calories from the list of food items
  String _calculateTotalCalories() {
    double totalCalories = 0.0;
    for (var item in widget.foodItems) {
      final calories = double.tryParse(item['calories'] ?? '0') ?? 0;
      totalCalories += calories;
    }
    return totalCalories.toStringAsFixed(1); // Format to 1 decimal place
  }

  Widget _buildContainer({required String title, required String value}) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.teal,
        borderRadius: BorderRadius.circular(8.0),
      ),
      width: 150,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 16.0),
          ),
          const SizedBox(height: 8.0),
          Text(
            value,
            style: const TextStyle(color: Colors.white, fontSize: 24.0),
          ),
        ],
      ),
    );
  }

  Widget _buildSlot(Map<String, String> foodItem) {
    return GestureDetector(
      onTap: () => _showFoodDetails(foodItem), // Show details when tapped
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8.0),
          color: Colors.transparent,
        ),
        child: Center(
          child: Image.network(
            foodItem['imagePath'] ?? '',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  void _showFoodDetails(Map<String, String> foodItem) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(foodItem['name'] ?? 'Food Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.network(foodItem['imagePath'] ?? ''),
              const SizedBox(height: 10),
              Text('Sugar: ${foodItem['sugar'] ?? '0 g'}'),
              Text('Calories: ${foodItem['calories'] ?? '0 kcal'}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
