import 'package:briscola_app/game_internals/game_history.dart';
import 'package:briscola_app/game_internals/playing_card.dart';
import 'package:briscola_app/game_internals/strategies/expectimax_strategy.dart';
import 'package:briscola_app/game_internals/strategies/random_strategy.dart';
import 'package:briscola_app/game_internals/strategies/simple_strategy.dart';

abstract class BotStrategy {
  static BotStrategy fromLevel(String difficulty) {
    switch (difficulty) {
      case "easy":
        return RandomStrategy();
      case "medium":
        return SimpleStrategy();
      case "hard":
        return ExpectimaxStrategy();
      default:
        return RandomStrategy();
    }
  }

  void setUpBotStrategy(GameHistory gameHistory) {}

  Future<PlayingCard> chooseCardToPlay(List<PlayingCard?> hand);
}
