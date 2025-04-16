// Class to record the history of the game
import 'package:briscola_app/game_internals/player.dart';
import 'package:briscola_app/game_internals/playing_card.dart';
import 'package:tuple/tuple.dart';

class GameHistory {
  final List<Tuple2<Player, PlayingCard>> _history = [];
  PlayingCard _lastCard;
  final int numberOfPlayers;

  GameHistory({required PlayingCard lastCard, required this.numberOfPlayers})
      : _lastCard = lastCard;

  void recordMove(Player player, PlayingCard card) {
    _history.add(Tuple2(player, card));
  }

  void reset(PlayingCard lastCard) {
    _history.clear();
    _lastCard = lastCard;
  }

  List<Tuple2<Player, PlayingCard>> get viewHistory =>
      List.unmodifiable(_history);
}
