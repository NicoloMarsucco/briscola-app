import 'dart:ui';

import 'package:flutter/material.dart';

class Palette {
  Color get background => const Color.fromARGB(255, 6, 3, 35);
  Color get playingTableCloth => const Color.fromARGB(255, 255, 0, 217);

  // Main menu
  Color get backgroundMain => const Color.fromARGB(255, 6, 3, 35);

  /// The primary colour used throughout the app.
  @Deprecated("Use [primaryColor] for consistency")
  static const Color defaultBlue = Color.fromARGB(255, 6, 3, 35);

  /// The main colour used throughout the app.
  Color get primaryColor => const Color.fromARGB(255, 6, 3, 35);

  /// The colour used for text shadows
  static const Color primaryShadow = Colors.red;

  // Default shade of white
  Color get defaultWhite => const Color.fromRGBO(255, 255, 255, 1);

  // Buttons
  Color get defaultButtonBackground => const Color.fromRGBO(255, 255, 255, 1);
  Color get defaultButtonOverlayColor => Colors.deepPurple;

  /// Heatmap colors.
  static final Map<int, Color> heatmapColorsMap = _generateHeatmapColorsMap(10);

  static Map<int, Color> _generateHeatmapColorsMap(int max) {
    final steps = 5;
    final chosenColor = Colors.deepPurple;
    final Map<int, Color> map = {};
    final dOpacity = 1 / steps;
    final dGames = (max - 1) / (steps - 1);
    map[1] = chosenColor.withOpacity(dOpacity);
    map[max] = chosenColor;
    for (int i = 2; i < steps; i++) {
      int gamesNumber = (1 + dGames * (i - 1)).toInt();
      map[gamesNumber] = chosenColor.withOpacity(dOpacity * i);
    }
    return map;
  }
}
