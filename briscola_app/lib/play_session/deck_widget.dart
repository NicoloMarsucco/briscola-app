import 'dart:math';

import 'package:flutter/material.dart';
import 'playing_card_widget.dart';
import '../game_internals/playing_card.dart';

class DeckWidget extends StatelessWidget {
  final PlayingCard briscola;
  final bool showDeck;

  const DeckWidget({super.key, required this.briscola, required this.showDeck});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (showDeck)
          Transform.translate(
            offset: const Offset(
                (PlayingCardWidget.height - PlayingCardWidget.width) * 0.5 +
                    PlayingCardWidget.height * 0.2,
                0),
            child: Transform.rotate(
              angle: pi / 2,
              child: PlayingCardWidget(
                card: briscola,
                cardType: CardType.briscola,
              ),
            ),
          ),
        if (showDeck)
          PlayingCardWidget(
            card: PlayingCard.dummyCard,
            cardType: CardType.deck,
          )
      ],
    );
  }
}
