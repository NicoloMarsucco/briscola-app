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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
              onPressed: () => GoRouter.of(context).go('/settings'),
              icon: Icon(
                Icons.settings,
                color: palette.defaultWhite,
              ))
        ],
      ),
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
                  _showDifficultyDialog(context, customTextStyles);
                  //GoRouter.of(context).go('/play');
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

  Future<void> _showDifficultyDialog(
      BuildContext context, CustomTextStyles textStyles) async {
    await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text(
            'Select difficulty:',
            style: textStyles.buttonText,
            textAlign: TextAlign.center,
          ),
          children: [
            difficultyOption(
                context: context,
                text: "Easy",
                color: Colors.green,
                textStyles: textStyles,
                difficultyId: "easy"),
            difficultyOption(
                context: context,
                text: "Medium",
                color: Colors.orange,
                textStyles: textStyles,
                difficultyId: 'medium'),
          ],
        );
      },
    );
  }

  Widget difficultyOption({
    required BuildContext context,
    required String text,
    required Color color,
    required CustomTextStyles textStyles,
    required String difficultyId,
  }) {
    return SimpleDialogOption(
      padding: EdgeInsets.zero,
      child: Center(
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () {
            Navigator.pop(context);
            context
                .goNamed('play', pathParameters: {'difficulty': difficultyId});
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Text(
              text,
              style: textStyles.buttonText.copyWith(color: color),
            ),
          ),
        ),
      ),
    );
  }
}
