import 'package:flutter/material.dart';
import 'package:mavis/home/home.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mavis/together/together.dart';
import 'package:mavis/fitness/fitness.dart';
import 'package:mavis/profile/profile.dart';
import 'package:mavis/foodScan/foodScanner.dart';
import 'package:mavis/constants/colors.dart';
import 'package:mavis/styles/style.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;
  late final List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    _widgetOptions = <Widget>[
      const MyHomePage(),
      Together(),
      const Center(),
      Fitness(),
      Profile(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions[_selectedIndex],
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: floatingMenu(context),
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: Container(
        height: Theme.of(context).platform == TargetPlatform.iOS ? 90 : 72,
        decoration: BoxDecoration(
          color: AppColors.primary,
          boxShadow: [
            BoxShadow(
              color: AppColors.gray700,
              spreadRadius:
                  Theme.of(context).platform == TargetPlatform.iOS ? 10 : 1,
              blurRadius: 36,
              offset: const Offset(0, 36),
            ),
          ],
        ),
        child: ClipRRect(
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            key: const Key('bottomNavigationBar'),
            backgroundColor: AppColors.navigation,
            selectedItemColor: AppColors.primary,
            unselectedItemColor: AppColors.gray300,
            type: BottomNavigationBarType.fixed,
            selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 11,
              color: AppColors.primary,
            ),
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 11,
              color: AppColors.gray300,
            ),
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            items: [
              BottomNavigationBarItem(
                label: 'Home',
                icon: icon('home'),
                activeIcon: icon('home-black'),
              ),
              BottomNavigationBarItem(
                label: 'Together',
                icon: icon('flag'),
                activeIcon: icon('flag-black'),
              ),
              const BottomNavigationBarItem(
                label: '',
                icon: Padding(
                  padding: EdgeInsets.all(0),
                ),
              ),
              BottomNavigationBarItem(
                label: 'Fitness',
                icon: icon('fitness'),
                activeIcon: icon('fitness-black'),
              ),
              BottomNavigationBarItem(
                label: 'Profile',
                icon: icon('user'),
                activeIcon: icon('user-black'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget floatingMenu(BuildContext context) {
    return Container(
      width: 70,
      height: 70,
      margin: const EdgeInsets.only(top: 33),
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: appGradient(),
            ),
            child: FittedBox(
              child: FloatingActionButton(
                onPressed: () {
                  showDialog(
                    barrierDismissible: true,
                    context: context,
                    builder: (_) => const FoodScannerPage(),
                  );
                },
                elevation: 0,
                heroTag: 'scan',
                backgroundColor: Colors.transparent,
                hoverColor: Colors.transparent,
                focusColor: Colors.transparent,
                foregroundColor: Colors.transparent,
                splashColor: Colors.transparent,
                shape: const CircleBorder(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/scan.svg',
                      width: 28,
                      height: 28,
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget icon(String iconName) {
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 4),
      child: SvgPicture.asset(
        'assets/icons/$iconName.svg',
      ),
    );
  }
}
