import 'package:flutter/material.dart';
import 'package:mavis/main_navigation.dart'; // Import MainNavigation widget

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Mavis',
      home: MainNavigation(), // Set MainNavigation as the home widget
      debugShowCheckedModeBanner: false,
    );
  }
}
