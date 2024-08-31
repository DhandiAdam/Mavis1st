import 'package:flutter/material.dart';
import 'package:mavis/constants/colors.dart';

LinearGradient appGradient() {
  return const LinearGradient(
    colors: [
      AppColors.scanButton,
      AppColors.scanButton,
    ],
    begin: FractionalOffset(0, 0),
    end: FractionalOffset(2.5, 0),
    stops: [0, 1],
    tileMode: TileMode.clamp,
  );
}
