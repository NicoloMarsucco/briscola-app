import 'dart:math';

import 'package:briscola_app/models/card.dart';
import 'package:briscola_app/models/player.dart';

class Bot extends Player {
  final _random = Random();

  Bot(String name) : super(name: name);

  @override
  Future<Card> playCard() async {
    if (super.cardsInHand == 0) {
      throw StateError('Cannot play cards if the hand is empty');
    }
    var cardToPlay = super.viewHand[_random.nextInt(super.cardsInHand)];
    super.removeCardFromHand(cardToPlay);
    return cardToPlay;
  }
}
