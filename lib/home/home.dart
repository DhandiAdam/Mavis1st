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
              Row(
                children: [
                  const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 25.0, vertical: 0.0),
                    child: Text(
                      'Activity Status',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(right: 25.0),
                    child: _buildServicSos(Image.asset(
                      'assets/icons/SOS.png', // Ganti dengan path gambar kamu
                      width: 60,
                      height: 60,
                    )),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Center(
                child: Image.asset(
                  'assets/icons/Status.png',
                  fit: BoxFit.contain,
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
                  _buildServiceButton(Image.asset(
                    'assets/icons/Food.png',
                    width: 40,
                    height: 40,
                  )),
                  const SizedBox(width: 30),
                  _buildServiceButton(Image.asset(
                    'assets/icons/Hungry.png',
                    width: 40,
                    height: 40,
                  )),
                  const SizedBox(width: 30),
                  _buildServiceButton(Image.asset(
                    'assets/icons/Goal.png',
                    width: 40,
                    height: 40,
                  )),
                  const SizedBox(width: 30),
                  _buildServiceButton(Image.asset(
                    'assets/icons/Pill.png',
                    width: 40,
                    height: 40,
                  )),
                ],
              )
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

  Widget _buildServiceButton(Widget icon,
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
            gradient: LinearGradient(
              colors: [
                AppColors.gradientStart,
                AppColors.gradientEnd
              ], // Warna gradient
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: icon,
          ),
        ),
      ),
    );
  }

  Widget _buildServicSos(Widget icon,
      {Color backgroundColor = AppColors.baseColor4}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          print('Service clicked');
        },
        borderRadius: BorderRadius.circular(30), // Membuat oval
        child: Container(
          padding: const EdgeInsets.all(8.0),
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.gradientsosStart,
                AppColors.gradientsosEnd
              ], // Warna gradient
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(30), // Membuat oval
          ),
          child: Center(
            child: icon,
          ),
        ),
      ),
    );
  }
}
