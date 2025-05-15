import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  static const TextStyle heading = TextStyle(
    fontFamily: 'Raleway',
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: AppColors.text,
    letterSpacing: -0.52,
  );

  static const TextStyle label = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.4,
    height: 1.75,
  );

  static const TextStyle button = TextStyle(
    fontFamily: 'Nunito Sans',
    fontSize: 22,
    fontWeight: FontWeight.w300,
    color: AppColors.buttonText,
  );
}
