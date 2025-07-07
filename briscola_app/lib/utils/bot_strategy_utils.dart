// Helper methods for the various strategies.

import 'package:briscola_app/game_internals/game_history.dart';
import 'package:briscola_app/game_internals/playing_card.dart';

/// Retrieves the cards which are available.
List<PlayingCard> getAvailableCards(List<PlayingCard?> hand) {
  return hand.whereType<PlayingCard>().toList(growable: false);
}

/// Returns `true` if it is the first player of the round, `false` otherwise.
bool isFirstPlayer(List<Move> history) {
  return history.isEmpty || history.last.moveType == MoveType.collect;
}

/// Finds the lowest cards (first by points, then by rank).
PlayingCard findLowest(Iterable<PlayingCard> cards) {
  return cards.reduce((a, b) {
    if (a.points < b.points) return a;
    if (a.points > b.points) return b;
    // points equal: use rank as tie-breaker
    return a.rank < b.rank ? a : b;
  });
}
