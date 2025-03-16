import 'package:briscola_app/game_internals/human_player.dart';
import 'package:flutter/material.dart';

import '../game_internals/player.dart';
import '../game_internals/playing_card.dart';

class PlayingCardWidget extends StatelessWidget {
  static const double width = 68.75;
  static const double height = 109.25;
  static const double borderRadius = 5;
  static const String pathToBackCardImage = "assets/cards/card-back.jpg";
  final bool isCardVisible;
  final bool isCardDraggable;

  final PlayingCard? card;

  const PlayingCardWidget(
      {required this.card,
      required this.isCardVisible,
      required this.isCardDraggable,
      super.key});

  @override
  Widget build(BuildContext context) {
    if (card == null) {
      return SizedBox(
        height: height,
        width: width,
      );
    }

    final cardWidget = DefaultTextStyle(
      style: const TextStyle(fontSize: 16, color: Colors.black),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: Center(
            child: Image.asset(
              isCardVisible ? card!.imagePath : pathToBackCardImage,
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
    );

    if (isCardDraggable) {
      return Draggable(
        data: PlayingCardDragData(card!),
        feedback: Transform.rotate(
          angle: 0.1,
          child: cardWidget,
        ),
        childWhenDragging: Opacity(
          opacity: 0.5,
          child: cardWidget,
        ),
        child: cardWidget,
      );
    } else {
      return cardWidget;
    }
  }
}

@immutable
class PlayingCardDragData {
  final PlayingCard card;

  const PlayingCardDragData(this.card);
}
