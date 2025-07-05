import 'package:briscola_app/main_menu/main_menu_quote.dart';
import 'package:briscola_app/main_menu/random_quote_provider.dart';
import 'package:briscola_app/style/app_button_widget.dart';
import 'package:briscola_app/style/custom_text_styles.dart';
import 'package:briscola_app/style/palette.dart';
import 'package:briscola_app/style/responsive_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class MainMenuScreen extends StatelessWidget {
  MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();
    final customTextStyles = context.watch<CustomTextStyles>();
    final MainMenuQuote quote = RandomQuoteProvider.getRandomQuote();

    return Scaffold(
      backgroundColor: palette.backgroundMain,
      body: ResponsiveScreen(
        squarishMainArea: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Briscola\nLab',
              textAlign: TextAlign.center,
              style: customTextStyles.mainMenuTitle,
            ),
            const SizedBox(
              height: 40,
            ),
            Text(
              quote.getFormattedQuote(),
              textAlign: TextAlign.center,
              style: customTextStyles.homeScreenQuote,
            ),
            Text(
              quote.getFormattedAuthor(),
              textAlign: TextAlign.center,
              style: customTextStyles.homeScreenSignature,
            )
          ],
        ),
        rectangularMenuArea: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              width: 150,
              child: AppButtonWidget(
                text: "Play",
                onPressed: () {
                  GoRouter.of(context).go('/play');
                },
                palette: palette,
                textStyles: customTextStyles,
              ),
            ),
            SizedBox(height: 80)
          ],
        ),
      ),
    );
  }
}
