import 'package:flutter/material.dart';
import 'package:mavis/home/home.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mavis/Goals/ChallengePage.dart';
import 'package:mavis/notifications/notifications.dart';
import 'package:mavis/profile/profile.dart';
import 'package:mavis/Scanner/scanner.dart';
import 'package:mavis/constants/colors.dart';
import 'package:mavis/afterEat/AfterEat.dart';
import 'package:mavis/Sos/Sos.dart';
import 'package:mavis/ConctactScreen/ContactScreen.dart';
import 'package:mavis/Medikasi/Medikasi.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Tambahkan ini untuk SharedPreferences
import '../healthsummary.dart'; // Import healthsummary.dart

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;
  String _userName = ''; // Default nama pengguna kosong

  late final List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    _loadUserName(); // Memuat nama dari SharedPreferences
    _widgetOptions = <Widget>[
      HomePage(), // Pass the initial name to HomePage
      HealthSummaryPage(),
      const Center(),
      Notifications(),
      Profile(
          currentName: _userName,
          updateName:
              _updateUserName), // Pass the initial name and the update function to Profile
      AfterMealScreen(),
      SOSScreen(),
    ];
  }

  // Fungsi untuk memuat nama dari SharedPreferences
  Future<void> _loadUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('userName') ?? ''; // Memuat nama dari lokal
      _widgetOptions[0] = HomePage(); // Memperbarui HomePage
      _widgetOptions[4] = Profile(
        currentName: _userName,
        updateName: _updateUserName,
      ); // Memperbarui Profile dengan nama terbaru
    });
  }

  // Fungsi untuk memperbarui nama dari Profile dan menyimpan ke SharedPreferences
  void _updateUserName(String newName) async {
    setState(() {
      _userName = newName;
      // Memperbarui widget dengan nama yang baru
      _widgetOptions[0] = HomePage(); // Perbarui HomePage
      _widgetOptions[4] = Profile(
          currentName: _userName,
          updateName: _updateUserName); // Perbarui Profile
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userName', newName); // Simpan nama ke SharedPreferences
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
          color: AppColors.white,
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
            backgroundColor: AppColors.white,
            selectedItemColor: AppColors.baseColor1,
            unselectedItemColor: AppColors.gray300,
            type: BottomNavigationBarType.fixed,
            selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 11,
              color: AppColors.baseColor1,
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
                label: '',
                icon: icon('home'),
                activeIcon: icon('home-active'),
              ),
              BottomNavigationBarItem(
                label: '',
                icon: icon('clock'),
                activeIcon: icon('clock-active'),
              ),
              const BottomNavigationBarItem(
                label: '',
                icon: Padding(
                  padding: EdgeInsets.all(0),
                ),
              ),
              BottomNavigationBarItem(
                label: '',
                icon: icon('notification'),
                activeIcon: icon('notification-active'),
              ),
              BottomNavigationBarItem(
                label: '',
                icon: icon('user'),
                activeIcon: icon('user-active'),
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
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF4AC35E), // Warna atas
                  Color(0xFF5AF469), // Warna bawah
                ],
              ),
            ),
            child: FittedBox(
              child: FloatingActionButton(
                onPressed: () {
                  showDialog(
                    barrierDismissible: true,
                    context: context,
                    builder: (_) => const Scanner(),
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
