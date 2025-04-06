import 'package:briscola_app/game_internals/round_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../game_internals/player.dart';
import 'playing_card_widget.dart';

class PlayerHandWidget extends StatelessWidget {
  final Player player;
  final bool showCards;
  final bool areCardsDraggable;
  static const double height = 150;

  PlayerHandWidget(
      {super.key,
      required this.player,
      required this.showCards,
      required this.areCardsDraggable});

  @override
  Widget build(BuildContext context) {
    final round = context.watch<RoundManager>();

    return SizedBox(
      height: height,
      child: Container(
        color: Colors.amber,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ...player.hand.map((card) =>
                PlayingCardWidget(card: card, cardType: CardType.briscola)),
          ],
        ),
      ),
    );
  }
}
