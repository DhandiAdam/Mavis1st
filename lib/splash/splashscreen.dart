import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:mavis/main_navigation.dart';

class MySplash extends StatefulWidget {
  const MySplash({super.key});

  @override
  State<MySplash> createState() => _MySplashState();
}

class _MySplashState extends State<MySplash> {
  @override
  Widget build(BuildContext context) {
    return FlutterSplashScreen.fadeIn(
      backgroundColor: Colors.white,
      childWidget: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 150,
            width: 300,
            child: Image.asset("assets/mavis.png"),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 200,
            width: 250,
            child: Image.asset("assets/2222.png"),
          ),
        ],
      ),
      nextScreen: const MainNavigation(),
    );
  }
}
