import 'package:flutter/material.dart';

import 'custom_text_styles.dart';
import 'palette.dart';

class AppButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? textColor;
  final Palette palette;
  final CustomTextStyles textStyles;
  static const double _horizontalPadding = 8;
  static const double _topPadding = 5.5;
  static const double _elevation = 5;
  static const Color _defaultTextColor = Colors.black;

  const AppButtonWidget(
      {super.key,
      required this.text,
      required this.onPressed,
      required this.palette,
      required this.textStyles,
      this.textColor});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: palette.defaultButtonBackground,
          overlayColor: palette.defaultButtonOverlayColor,
          padding: EdgeInsets.only(
              left: _horizontalPadding,
              right: _horizontalPadding,
              top: _topPadding),
          elevation: _elevation),
      onPressed: onPressed,
      child: Text(
        text,
        style: textStyles.buttonText
            .copyWith(color: textColor ?? _defaultTextColor),
      ),
    );
  }
}
