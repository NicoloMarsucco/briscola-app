import 'package:briscola_app/style/palette.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextStyles {
  // Main menu
  TextStyle get mainMenuTitle => GoogleFonts.ubuntu(
        color: Colors.white,
        fontSize: 70,
        fontWeight: FontWeight.w500,
        shadows: <Shadow>[
          Shadow(
            offset: const Offset(4.0, 4.0),
            blurRadius: 2.0,
            color: Colors.red,
          ),
        ],
      );

  /// The font of the message shown at the end of each game
  /// (like "You won!")
  TextStyle get endGameMessage =>
      GoogleFonts.ubuntu(fontSize: 20, color: Palette.defaultBlue);

  TextStyle get endGameTitle => GoogleFonts.luckiestGuy(
        fontSize: 48,
      );

  /// The font of the buttons in the game
  TextStyle get buttonText =>
      GoogleFonts.ubuntu(fontSize: 30, fontWeight: FontWeight.w700);

  /// The font of the quote on the homepage.
  TextStyle get homeScreenQuote => GoogleFonts.ubuntu(
          color: Colors.white,
          fontSize: 25,
          fontStyle: FontStyle.italic,
          shadows: <Shadow>[
            Shadow(
              offset: const Offset(1.4, 1.4),
              blurRadius: 3.0,
              color: Colors.red,
            ),
          ]);

  /// The font of the quote signature on the homepage.
  TextStyle get homeScreenSignature => GoogleFonts.ubuntu(
          color: Colors.white,
          fontSize: 18,
          fontStyle: FontStyle.normal,
          shadows: <Shadow>[
            Shadow(
              offset: const Offset(1.4, 1.4),
              blurRadius: 3.0,
              color: Colors.red,
            ),
          ]);
}
