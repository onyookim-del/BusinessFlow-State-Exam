import 'package:flutter/material.dart';
import 'package:businessflow/constants/app_colors.dart';

class AppTextStyles {
  static final TextStyle px12blue = TextStyle(
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w600,
    color: AppColors.inactive,
    fontSize: 12,
  );

  static final TextStyle cuprtsmall = TextStyle(
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
    color: AppColors.secondary,
    fontSize: 11,
  );

  static final TextStyle px10blue = TextStyle(
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w400,
    color: AppColors.tertiary,
    fontSize: 10,
  );

  static const TextStyle title = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.textDark,
  );

  static const TextStyle body = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textDark,
  );

  static const TextStyle button = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textLight,
  );
}

