import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextStyles {
  // Main menu
  TextStyle get mainMenuTitle => GoogleFonts.luckiestGuy(
        color: Colors.white,
        fontSize: 70,
        fontWeight: FontWeight.w500,
        shadows: <Shadow>[
          Shadow(
            offset: const Offset(2.0, 2.0),
            blurRadius: 3.0,
            color: Colors.purple.withOpacity(0.5),
          ),
        ],
      );
}
