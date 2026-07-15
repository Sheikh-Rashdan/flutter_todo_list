import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_list/data/constants.dart';

class SettingsModel with ChangeNotifier {
  int _themeColorIndex = 0;
  bool _useDarkBrightness = true;

  int get themeColorIndex => _themeColorIndex;
  Color get themeColor => KColors.themeColorOptions[_themeColorIndex];
  bool get useDarkBrightness => _useDarkBrightness;
  Brightness get brightness =>
      _useDarkBrightness ? Brightness.dark : Brightness.light;

  SettingsModel(int? themeColorIndex, bool? useDarkBrightness) {
    _themeColorIndex = themeColorIndex ?? 0;
    _useDarkBrightness = useDarkBrightness ?? true;
  }

  void cycleThemeColor() async {
    _themeColorIndex =
        (_themeColorIndex + 1) % KColors.themeColorOptions.length;
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(KPrefKeys.colorThemeIndexKey, _themeColorIndex);
  }

  void toggleBrightness() async {
    _useDarkBrightness = !_useDarkBrightness;
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(KPrefKeys.useDarkBrightnessKey, _useDarkBrightness);
  }
}
