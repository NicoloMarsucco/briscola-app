import 'package:briscola_app/game_internals/game_history.dart';
import 'package:briscola_app/game_internals/playing_card.dart';
import 'package:briscola_app/game_internals/strategies/random_strategy.dart';
import 'package:briscola_app/game_internals/strategies/simple_strategy.dart';

abstract class BotStrategy {
  GameHistory? gameHistory;

  static BotStrategy fromLevel(String difficulty) {
    if (difficulty == "easy") {
      return RandomStrategy();
    } else {
      return SimpleStrategy();
    }
  }

  Future<PlayingCard> chooseCardToPlay(List<PlayingCard?> hand);
}
