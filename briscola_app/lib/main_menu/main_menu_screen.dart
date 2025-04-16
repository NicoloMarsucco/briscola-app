import 'package:briscola_app/style/app_button_widget.dart';
import 'package:briscola_app/style/custom_text_styles.dart';
import 'package:briscola_app/style/palette.dart';
import 'package:briscola_app/style/responsive_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();
    final customTextStyles = context.watch<CustomTextStyles>();

    return Scaffold(
      backgroundColor: palette.backgroundMain,
      body: ResponsiveScreen(
        squarishMainArea: Center(
          child: Text(
            'Briscola \nApp',
            textAlign: TextAlign.center,
            style: customTextStyles.mainMenuTitle,
          ),
        ),
        rectangularMenuArea: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            AppButtonWidget(
              text: "Play",
              onPressed: () {
                GoRouter.of(context).go('/play');
              },
              palette: palette,
              textStyles: customTextStyles,
            ),
            SizedBox(height: 50)
          ],
        ),
        backgroundImage: "assets/background/colorful-gradient.jpg",
      ),
    );
  }
}
