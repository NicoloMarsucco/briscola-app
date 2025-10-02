import 'package:briscola_app/game_internals/game_history.dart';
import 'package:briscola_app/game_internals/playing_card.dart';
import 'package:briscola_app/game_internals/strategies/expectimax_strategy.dart';
import 'package:briscola_app/game_internals/strategies/random_strategy.dart';
import 'package:briscola_app/game_internals/strategies/simple_strategy.dart';

abstract class BotStrategy {
  static BotStrategy fromLevel(Difficulty difficulty) {
    switch (difficulty) {
      case Difficulty.easy:
        return RandomStrategy();
      case Difficulty.medium:
        return SimpleStrategy();
      case Difficulty.hard:
        return ExpectimaxStrategy();
    }
  }

  void setUpBotStrategy(GameHistory gameHistory);

  Future<PlayingCard> chooseCardToPlay(List<PlayingCard?> hand);
}

enum Difficulty {
  easy,
  medium,
  hard;

  static Difficulty fromString(String s) {
    return Difficulty.values.firstWhere((d) => d.name == s.toLowerCase(),
        orElse: () => Difficulty.easy);
  }
}
