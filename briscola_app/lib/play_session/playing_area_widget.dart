import 'dart:math';

import 'package:briscola_app/game_internals/game.dart';
import 'package:briscola_app/game_internals/playing_card.dart';
import 'package:briscola_app/game_internals/round_manager.dart';
import 'package:briscola_app/play_session/playing_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlayingAreaWidget extends StatefulWidget {
  const PlayingAreaWidget({super.key});

  @override
  State<StatefulWidget> createState() => _PlayingAreaWidgetState();
}

class _PlayingAreaWidgetState extends State<PlayingAreaWidget> {
  static const double height = 200;

  @override
  Widget build(BuildContext context) {
    final game = context.watch<Game>();
    final round = context.watch<RoundManager>();
    final humanPlayer = game.players.last;

    return SizedBox(
      height: height,
      child: Stack(
        children: [
          DragTarget<PlayingCardDragData>(
            builder: (context, candidateData, rejectedData) {
              return SizedBox.expand(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ...round.cardsOnTheTable.map((card) => PlayingCardWidget(
                        card: card,
                        isCardVisible: true,
                        isCardDraggable: false))
                  ],
                ),
              );
            },
            onAccept: (dragData) {
              setState(() {
                humanPlayer.userPlaysCard(dragData.card);
              });
            },
          ),
          if (game.isFinished)
            Center(
              child: Text(
                _getTextEnd(botPoints: game.players[0].points),
                style: TextStyle(color: Colors.white),
              ),
            ),
          if (game.deck.cardsLeft >= 1)
            Positioned(
                left: (PlayingCardWidget.height - PlayingCardWidget.width) / 2 +
                    PlayingCardWidget.height * 0.1,
                top: (height - PlayingCardWidget.height) / 2,
                child: Transform.rotate(
                  angle: pi / 2,
                  child: PlayingCardWidget(
                    card: game.deck.peekLastCard,
                    isCardVisible: true,
                    isCardDraggable: false,
                  ),
                )),
          if (game.deck.cardsLeft >= 2)
            Positioned(
              left: 0,
              top: (height - PlayingCardWidget.height) / 2,
              child: PlayingCardWidget(
                card: PlayingCard(rank: 1, suit: Suit.bastoni),
                isCardVisible: false,
                isCardDraggable: false,
              ),
            ),
        ],
      ),
    );
  }

  static String _getTextEnd({required int botPoints}) {
    if (botPoints > 60) {
      return "You lost!";
    } else if (botPoints < 60) {
      return "You won!";
    } else {
      return "It's a draw!";
    }
  }
}
