import 'dart:collection';

import 'package:briscola_app/game_internals/playing_card.dart';

/// The deck of 40 Neapolitan cards.
class Deck {
  Queue<PlayingCard> _deck;

  Deck() : _deck = Queue.of(generateCards(shuffle: true)) {
    prepareDeck();
  }

  /// Prepares the deck for a new game (i.e. the cards are shuffled).
  void prepareDeck() {
    _deck = Queue.of(generateCards(shuffle: true));
  }

  /// Generates a full 40-card Briscola deck.
  /// Set [shuffle] to true to randomize the order (default: true).
  static List<PlayingCard> generateCards({bool shuffle = true}) {
    final List<PlayingCard> listOfCards = [];
    for (Suit suit in Suit.values) {
      for (int rank = 1; rank <= 10; rank++) {
        listOfCards.add(PlayingCard(rank: rank, suit: suit));
      }
    }
    if (shuffle) {
      listOfCards.shuffle();
    }
    return listOfCards;
  }

  PlayingCard drawTopCard() => _deck.removeFirst();

  PlayingCard get peekLastCard => _deck.last;

  int get cardsLeft => _deck.length;
}
