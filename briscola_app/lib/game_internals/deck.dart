import 'dart:collection';

import 'package:briscola_app/game_internals/playing_card.dart';

class Deck {
  final _deck = ListQueue<PlayingCard>();

  Deck() {
    prepareDeck();
  }

  void prepareDeck() {
    final listOfCards = _generateCards();
    listOfCards.shuffle();
    _deck.addAll(listOfCards);
  }

  // Method to generato 40 napolitan cards, returned in a list
  static List<PlayingCard> _generateCards() {
    final List<PlayingCard> listOfCards = [];
    for (Suit suit in Suit.values) {
      for (int rank = 1; rank < 11; rank++) {
        listOfCards.add(PlayingCard(rank: rank, suit: suit));
      }
    }
    return listOfCards;
  }

  PlayingCard drawTopCard() => _deck.removeFirst();

  PlayingCard get peekLastCard => _deck.last;

  int get cardsLeft => _deck.length;
}
