// Class to record the history of the game
import 'package:briscola_app/game_internals/player.dart';
import 'package:briscola_app/game_internals/playing_card.dart';
import 'package:tuple/tuple.dart';

class GameHistory {
  final List<Tuple2<Player, PlayingCard>> _history = [];
  final PlayingCard lastCard;
  final int numberOfPlayers;

  GameHistory({required this.lastCard, required this.numberOfPlayers});

  void recordMove(Player player, PlayingCard card) {
    _history.add(Tuple2(player, card));
  }

  List<Tuple2<Player, PlayingCard>> get viewHistory =>
      List.unmodifiable(_history);
}
