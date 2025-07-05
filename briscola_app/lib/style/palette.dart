import 'package:flutter/material.dart';

class Palette {
  Color get background => const Color.fromARGB(255, 6, 3, 35);
  Color get playingTableCloth => const Color.fromARGB(255, 255, 0, 217);

  // Main menu
  Color get backgroundMain => const Color.fromARGB(255, 6, 3, 35);

  /// The primary colour used throughout the app.
  static const Color defaultBlue = Color.fromARGB(255, 6, 3, 35);

  /// The colour used for text shadows
  static const Color primaryShadow = Colors.red;

  // Buttons
  Color get defaultButtonBackground => const Color.fromRGBO(255, 255, 255, 1);
  Color get defaultButtonOverlayColor => const Color.fromARGB(255, 255, 0, 0);
}
