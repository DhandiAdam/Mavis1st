import 'package:flutter/material.dart';
import 'package:mavis/constants/colors.dart';

LinearGradient appGradient() {
  return const LinearGradient(
    colors: [
      AppColors.gradient1,
      AppColors.gradient2,
    ],
    begin: FractionalOffset(0, 0),
    end: FractionalOffset(2.5, 0),
    stops: [0, 1],
    tileMode: TileMode.clamp,
  );
}

LinearGradient recommendationGradient(Color color1, Color color2) {
  return LinearGradient(
    colors: [
      color1,
      color2,
    ],
    begin: const FractionalOffset(0, 0),
    end: const FractionalOffset(2.5, 0),
    stops: const [0, 1],
    tileMode: TileMode.clamp,
  );
}
