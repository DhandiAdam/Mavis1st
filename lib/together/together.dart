import 'package:flutter/material.dart';

class Together extends StatefulWidget {
  @override
  _TogetherState createState() => _TogetherState();
}

class _TogetherState extends State<Together> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Together'),
      ),
      body: Center(
        child: Text('Together'),
      ),
    );
  }
}
