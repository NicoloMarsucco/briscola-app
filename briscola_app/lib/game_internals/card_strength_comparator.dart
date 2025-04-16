import 'playing_card.dart';

/// A class to check whether, when a new card is played, is stronger than
/// the currently strongest card on the table
class CardStrengthComparator {
  static bool isStronger(
      {required PlayingCard? strongestCardOnTheTable,
      required PlayingCard cardPlayed,
      required Suit suitOfBriscola}) {
    // If first card, it is the strongest on the table
    if (strongestCardOnTheTable == null) {
      return true;
    }

    // If the cards are of the same suit and the new one has more
    // points, it has to be stronger, otherwise not (regardless of whether
    // not it is a briscola)
    if (cardPlayed.suit == strongestCardOnTheTable.suit) {
      if (cardPlayed.points == 0 && strongestCardOnTheTable.points == 0) {
        return cardPlayed.rank > strongestCardOnTheTable.rank;
      }
      return cardPlayed.points > strongestCardOnTheTable.points;
    }

    // If of different suits, only a briscola can win.
    // If this is the case, it does not matter the number of point
    // cause we have already checked the case in which both cards are briscolas
    return cardPlayed.suit == suitOfBriscola;
  }
}
