import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_list/data/constants.dart';

class Settings {
  static ValueNotifier<Color> themeColor = ValueNotifier(
    KColors.themeColorOptions.first,
  );
  static ValueNotifier<bool> useDarkBrightness = ValueNotifier(true);

  static Future<void> loadSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    themeColor.value = KColors
        .themeColorOptions[prefs.getInt(KPrefKeys.colorThemeIndexKey) ?? 0];
    useDarkBrightness.value =
        prefs.getBool(KPrefKeys.useDarkBrightnessKey) ?? true;
  }
}
