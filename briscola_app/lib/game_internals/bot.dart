import 'dart:math';

import 'package:briscola_app/game_internals/playing_card.dart';
import 'package:briscola_app/game_internals/player.dart';

class Bot extends Player {
  final _random = Random();

  Bot({required super.name});

  @override
  Future<PlayingCard> playCard() async {
    PlayingCard cardToPlay =
        super.viewHand[_random.nextInt(super.viewHand.length)];
    super.removeCardFromHand(cardToPlay);
    return cardToPlay;
  }
}
