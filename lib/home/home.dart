import 'package:flutter/material.dart';
import 'package:mavis/constants/colors.dart';

class HomePage extends StatelessWidget {
  final String userName = 'Admin';
  final String sleep = '8h 20m';
  final String calories = '760 kCal';
  final int heartRate = 80;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        toolbarHeight: 100,
        title: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Welcome Back',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.greySmooth,
                ),
              ),
              Text(
                '$userName!',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
                child: Text(
                  'Activity Status',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 1.0, bottom: 1.0),
                  child: Image.asset(
                    'assets/icons/Status.png',
                    width: 350,
                    height: 350,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildCard(
                    title: 'Calories',
                    subtitle: calories,
                    image: 'assets/icons/Calories-Pie.png',
                  ),
                  const SizedBox(width: 20),
                  _buildCard(
                    title: 'Sleep',
                    subtitle: sleep,
                    image: 'assets/icons/Sleep-Graph.png',
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildServiceButton(Icons.sos),
                  const SizedBox(width: 30),
                  _buildServiceButton(Icons.track_changes_outlined),
                  const SizedBox(width: 30),
                  _buildServiceButton(Icons.medication),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildServiceButton(Icons.apple),
                  const SizedBox(width: 30),
                  _buildServiceButton(Icons.restaurant),
                  const SizedBox(width: 30),
                  _buildServiceButton(Icons.more_horiz_outlined),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required String subtitle,
    required String image,
    Color? color,
  }) {
    return Container(
      width: 150,
      height: 180,
      decoration: BoxDecoration(
        color: color ?? Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              subtitle,
              style: const TextStyle(
                color: AppColors.baseColor3,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Center(
              child: Image.asset(
                image,
                fit: BoxFit.contain,
                width: 80,
                height: 80,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceButton(IconData icon,
      {Color backgroundColor = AppColors.baseColor4}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          print('Service clicked');
        },
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.all(8.0),
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 30,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
