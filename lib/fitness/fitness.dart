import 'package:flutter/material.dart';

class Fitness extends StatefulWidget {
  @override
  FitnessState createState() => FitnessState();
}

class FitnessState extends State<Fitness> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fitness'),
      ),
      body: Center(
        child: Text('Fitness'),
      ),
    );
  }
}
