import 'package:flutter/material.dart';
import 'package:todo_list/data/constants.dart';

class SettingsValueNotifiers {
  static ValueNotifier<Color> themeColor = ValueNotifier(
    KColors.themeColorOptions[0],
  );
}
