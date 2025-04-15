import 'package:briscola_app/style/custom_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EndGameWidget extends StatelessWidget {
  final GameResult result;
  final int points;
  static const double height = 200;
  static const double width = 300;
  static const Map<GameResult, String> _message = {
    GameResult.win: "You won!",
    GameResult.draw: "You drew!",
    GameResult.loss: "You lost!"
  };

  const EndGameWidget({super.key, required this.result, required this.points});

  @override
  Widget build(BuildContext context) {
    final customTextStyles = context.watch<CustomTextStyles>();
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
                "Points: $points",
                style: customTextStyles.endGameMessage,
              )
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
