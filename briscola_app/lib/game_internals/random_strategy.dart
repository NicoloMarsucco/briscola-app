import 'dart:math';

import 'package:briscola_app/game_internals/bot_strategy.dart';
import 'package:briscola_app/game_internals/playing_card.dart';

// A bot which plays randomly
class RandomStrategy extends BotStrategy {
  static final Random _random = Random();

  @override
  Future<PlayingCard> chooseCardToPlay(List<PlayingCard?> hand) async {
    final availableCards = hand.whereType<PlayingCard>().toList();
    return availableCards[_random.nextInt(availableCards.length)];
  }
}
