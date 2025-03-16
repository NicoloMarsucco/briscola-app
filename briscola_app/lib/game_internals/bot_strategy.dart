import 'package:briscola_app/game_internals/game_history.dart';
import 'package:briscola_app/game_internals/playing_card.dart';

abstract class BotStrategy {
  late final GameHistory _gameHistory;

  set gameHistory(GameHistory gameHistory) {
    _gameHistory = gameHistory;
  }

  Future<PlayingCard> chooseCardToPlay(List<PlayingCard?> hand);
}
