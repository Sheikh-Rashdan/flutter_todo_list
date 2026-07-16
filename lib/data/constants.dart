import 'package:flutter/material.dart';

class KColors {
  static Color defaultCategoryColor = Color(0xFF9C958C);
  static List<Color> themeColorOptions = [
    Colors.purple,
    Colors.pink,
    Colors.red,
    Colors.amber,
    Colors.green,
    Colors.lightBlue,
    Colors.deepPurple,
  ];
}

class KPrefKeys {
  static const String useDarkBrightnessKey = "USE_DARK_BRIGHTNESS";
  static const String colorThemeIndexKey = "COLOR_THEME_INDEX";
}
