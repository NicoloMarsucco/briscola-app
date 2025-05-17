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
            offset: const Offset(2.0, 2.0),
            blurRadius: 3.0,
            color: Colors.grey,
          ),
        ],
      );

  TextStyle get endGameMessage =>
      GoogleFonts.luckiestGuy(fontSize: 20, color: Colors.black);

  TextStyle get endGameTitle => GoogleFonts.luckiestGuy(
        fontSize: 48,
      );

  TextStyle get buttonText => GoogleFonts.luckiestGuy(
        fontSize: 20,
      );

  /// The font of the quote on the homepage.
  TextStyle get homeScreenQuote => GoogleFonts.ubuntu(
      color: Colors.white, fontSize: 20, fontStyle: FontStyle.italic);

  /// The font of the quote signature on the homepage.
  TextStyle get homeScreenSignature => GoogleFonts.ubuntu(
      color: Colors.white, fontSize: 20, fontStyle: FontStyle.normal);
}
