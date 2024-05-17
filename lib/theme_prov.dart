import 'package:f_pr/app_colors.dart';
import 'package:flutter/material.dart';



class ThemeProvider extends ChangeNotifier {
  bool isDarkTheme = true;

  ThemeData theme = ThemeData(
    scaffoldBackgroundColor: AppColors.bgColorNight,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.abColorNight,
      elevation: 0,
    ),
    
  );

  void changeTheme() {
    isDarkTheme = !isDarkTheme;

    theme = ThemeData(
      scaffoldBackgroundColor: isDarkTheme ? AppColors.bgColorNight : AppColors.bgColorLight,
      appBarTheme: AppBarTheme(
        backgroundColor: isDarkTheme ? AppColors.abColorNight : AppColors.abColorLight,
        elevation: 0,
      ),
      
    );

    notifyListeners();
  }
}
