import 'package:flutter/material.dart';
import 'package:health_app/splashscreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Camera Scan Prototype',
      home:
          MySplash(), // Pastikan MySplash sesuai dengan class yang akan dipanggil
      debugShowCheckedModeBanner: false,
    );
  }
}
