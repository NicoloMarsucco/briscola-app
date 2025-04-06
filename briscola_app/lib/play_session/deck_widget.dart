import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'playing_card_widget.dart';
import '../game_internals/game.dart';
import '../game_internals/playing_card.dart';

class DeckWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final game = context.watch<Game>();

    return Stack(
      children: [
        if (game.deck.cardsLeft >= 1)
          Transform.translate(
            offset: const Offset(
                (PlayingCardWidget.height - PlayingCardWidget.width) * 0.5 +
                    PlayingCardWidget.height * 0.2,
                0),
            child: Transform.rotate(
              angle: pi / 2,
              child: PlayingCardWidget(
                card: game.deck.peekLastCard,
                isCardVisible: true,
                isCardDraggable: false,
              ),
            ),
          ),
        if (game.deck.cardsLeft >= 2)
          PlayingCardWidget(
            card: PlayingCard(rank: 1, suit: Suit.bastoni),
            isCardVisible: false,
            isCardDraggable: false,
          )
      ],
    );
  }
}
