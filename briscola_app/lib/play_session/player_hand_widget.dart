import 'package:briscola_app/game_internals/round_manager.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

import '../game_internals/board_state.dart';
import '../game_internals/game.dart';
import '../game_internals/player.dart';
import 'playing_card_widget.dart';

class PlayerHandWidget extends StatelessWidget {
  final Player player;
  final bool showCards;
  final bool areCardsDraggable;
  static const double height = 150;
  final Logger _log = Logger("Hand widget");

  PlayerHandWidget(
      {super.key,
      required this.player,
      required this.showCards,
      required this.areCardsDraggable});

  @override
  Widget build(BuildContext context) {
    //final boardState = context.watch<BoardState>();
    final round = context.watch<RoundManager>();
    _log.info("Player $player has the cards: ${player.viewHand}");

    return SizedBox(
      height: height,
      child: Container(
        color: Colors.amber,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ...player.viewHand.map((card) => PlayingCardWidget(
                  card: card,
                  isCardVisible: showCards,
                  isCardDraggable: areCardsDraggable,
                )),
          ],
        ),
      ),
    );
  }
}
