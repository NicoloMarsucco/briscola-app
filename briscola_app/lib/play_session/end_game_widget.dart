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
  static const double height = 300;
  static const double width = 280;
  static const double buttonWidth = 200;
  static const Map<GameResult, String> _message = {
    GameResult.win: "You won!",
    GameResult.draw: "You drew!",
    GameResult.loss: "You lost!"
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
              color: Colors.white, borderRadius: BorderRadius.circular(30)),
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _message[result] ?? "",
                style: customTextStyles.endGameMessage.copyWith(fontSize: 40),
              ),
              Text(
                "Points: $points",
                style: customTextStyles.endGameMessage,
              ),
              SizedBox(
                height: 30,
              ),
              SizedBox(
                width: buttonWidth,
                child: AppButtonWidget(
                  text: "Main Menu",
                  onPressed: () {
                    audioController.stopAllSound();
                    audioController.startOrResumeMusic();
                    GoRouter.of(context).go('/');
                  },
                  palette: palette,
                  textStyles: customTextStyles,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: buttonWidth,
                child: AppButtonWidget(
                  text: "New Game",
                  onPressed: () {
                    audioController.stopAllSound();
                    _cardWidgetsCreated.clear();
                    _widgetsOfCardsCreated.clear();
                    controller.startNewGame();
                  },
                  palette: palette,
                  textStyles: customTextStyles,
                ),
              )
            ],
          ))),
    );
  }
}

enum GameResult { win, loss, draw }
