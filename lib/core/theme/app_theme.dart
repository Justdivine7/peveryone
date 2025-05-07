import 'package:flutter/material.dart';
import 'package:peveryone/core/theme/app_colors.dart';

class AppTheme {
  static ThemeData lightThemeData() {
    return ThemeData(
      brightness: Brightness.light,
      fontFamily: 'Outfit',
      indicatorColor: AppColors.lightGrey,
      hoverColor: AppColors.darkGold,
      splashColor: AppColors.splashScreenBlack,
      highlightColor: AppColors.lightGold,
      scaffoldBackgroundColor: AppColors.lightBackground,
      focusColor: AppColors.textGrey,
      disabledColor: AppColors.textDarkGrey,
      cardColor: AppColors.cardColor,
      canvasColor: AppColors.greenColor,
    );
  }

  static ThemeData darkThemeData() {
    return ThemeData(
      brightness: Brightness.dark,
      fontFamily: 'Outfit',
      indicatorColor: AppColors.lightGrey,
      hoverColor: AppColors.darkGold,
      splashColor: AppColors.splashScreenBlack,
      highlightColor: AppColors.lightGold,
      scaffoldBackgroundColor: AppColors.lightBackground,
      focusColor: AppColors.textGrey,
      disabledColor: AppColors.textDarkGrey,
      cardColor: AppColors.cardColor,
      canvasColor: AppColors.greenColor,
    );
  }
}
