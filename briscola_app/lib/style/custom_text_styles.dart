import 'package:briscola_app/style/palette.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextStyles {
  // Main menu
  TextStyle get mainMenuTitle => GoogleFonts.ubuntu(
        color: Colors.white,
        fontSize: 80,
        fontWeight: FontWeight.w500,
        height: 1.0,
        shadows: <Shadow>[
          Shadow(
            offset: const Offset(4.0, 4.0),
            blurRadius: 2.0,
            color: Colors.deepPurple,
          ),
        ],
      );

  /// The font of the message shown at the end of each game
  /// (like "You won!")
  TextStyle get endGameMessage =>
      GoogleFonts.ubuntu(fontSize: 20, color: Colors.white);

  TextStyle get endGameTitle => GoogleFonts.luckiestGuy(
        fontSize: 48,
      );

  /// The font of the buttons in the game
  TextStyle get buttonText => GoogleFonts.ubuntu(
        fontSize: 30,
        fontWeight: FontWeight.w700,
        color: Palette.defaultBlue,
      );

  /// The font of the settings header.
  TextStyle get settingsHeader => GoogleFonts.ubuntu(
      color: Colors.white,
      fontStyle: FontStyle.normal,
      fontSize: 30,
      fontWeight: FontWeight.bold);

  /// The font of a settings entry
  TextStyle get settingsEntry => GoogleFonts.ubuntu(
        color: Colors.white,
        fontSize: 25,
      );

  /// The font of the difficulty selection menu items
  TextStyle get difficultyMenuEntry =>
      GoogleFonts.ubuntu(fontSize: 26, fontWeight: FontWeight.bold);

  /// The font of the number of cards left.
  TextStyle get cardsLeft => GoogleFonts.ubuntu(
      fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black);

  /// The month label of the heatmap.
  TextStyle get heatmapMonthLabel => GoogleFonts.ubuntu(
      fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green);

  /// The week label of the heatmap.
  TextStyle get heatmapWeekLabel => GoogleFonts.ubuntu(
      fontSize: 13, fontWeight: FontWeight.normal, color: Colors.green);
}
