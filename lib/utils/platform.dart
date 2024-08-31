import 'package:flutter/material.dart';

class Platform {
  static late TargetPlatform type;

  void init(BuildContext context) {
    type = Theme.of(context).platform;
  }
}
