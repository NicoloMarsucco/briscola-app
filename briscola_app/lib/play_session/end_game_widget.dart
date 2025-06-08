import 'package:briscola_app/audio/audio_controller.dart';
import 'package:briscola_app/audio/sounds.dart';
import 'package:briscola_app/game_internals/playing_card.dart';
import 'package:briscola_app/play_session/board_widget.dart';
import 'package:briscola_app/play_session/play_screen_controller.dart';
import 'package:briscola_app/style/custom_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../style/app_button_widget.dart';
import '../style/palette.dart';

class EndGameWidget extends StatelessWidget {
  final GameResult result;
  final int points;
  final List<MovingCardData> _cardWidgetsCreated;
  final Set<PlayingCard> _widgetsOfCardsCreated;
  static const double height = 200;
  static const double width = 300;
  static const Map<GameResult, String> _message = {
    GameResult.win: "YOU WON!",
    GameResult.draw: "YOU DREW!",
    GameResult.loss: "YOU LOST!"
  };

  const EndGameWidget(
      {super.key,
      required this.result,
      required this.points,
      required List<MovingCardData> cardWidgetsCreated,
      required Set<PlayingCard> cardsCreated})
      : _cardWidgetsCreated = cardWidgetsCreated,
        _widgetsOfCardsCreated = cardsCreated;

  @override
  Widget build(BuildContext context) {
    final customTextStyles = context.watch<CustomTextStyles>();
    final palette = context.watch<Palette>();
    final controller = context.read<PlayScreenController>();
    final audioController = context.read<AudioController>();

    audioController
        .playSfx(result == GameResult.win ? SfxType.cheer : SfxType.gameOver);

    return Center(
      child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
              border: Border.all(width: 3),
              color: Colors.white,
              borderRadius: BorderRadius.circular(16)),
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildRainbowEndGameMessage(
                  _message[result] ?? "", customTextStyles.endGameTitle),
              Text(
                "POINTS: $points",
                style: customTextStyles.endGameMessage,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                AppButtonWidget(
                  text: "MAIN MENU",
                  onPressed: () {
                    audioController.stopAllSound();
                    audioController.startOrResumeMusic();
                    GoRouter.of(context).go('/');
                  },
                  palette: palette,
                  textStyles: customTextStyles,
                ),
                AppButtonWidget(
                  text: "NEW GAME",
                  onPressed: () {
                    audioController.stopAllSound();
                    _cardWidgetsCreated.clear();
                    _widgetsOfCardsCreated.clear();
                    controller.startNewGame();
                  },
                  palette: palette,
                  textStyles: customTextStyles,
                )
              ])
            ],
          ))),
    );
  }

  static Widget _buildRainbowEndGameMessage(
      String message, TextStyle baseStyle) {
    final Gradient rainbowGradient = LinearGradient(
      colors: [
        Colors.red,
        Colors.orange,
        Colors.yellow,
        Colors.green,
        Colors.blue,
        Colors.indigo,
        Colors.purple,
      ],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    );

    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (Rect bounds) {
        return rainbowGradient.createShader(bounds);
      },
      child: Text(
        message,
        style: baseStyle,
        textAlign: TextAlign.center,
      ),
    );
  }
}

enum GameResult { win, loss, draw }
