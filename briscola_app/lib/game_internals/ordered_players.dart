// Class to keep track of the order in which players need to play efficiently

import 'player.dart';

class OrderedPlayers {
  final List<Player> _players = [];

  OrderedPlayers({required List<Player> players}) {
    for (Player player in players) {
      _players.add(player);
    }
  }

  // TODO: fix for n > 2 players
  List<Player> getOrderedPlayers(Player startingPlayer) {
    if (startingPlayer != _players.first) {
      _players.last = _players.first;
      _players.first = startingPlayer;
    }
    return List.unmodifiable(_players);
  }
}
