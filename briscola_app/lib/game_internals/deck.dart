import 'dart:collection';

import 'package:briscola_app/game_internals/playing_card.dart';

class Deck {
  final _deck = ListQueue<PlayingCard>();

  Deck() {
    _prepareDeck();
  }

  _prepareDeck() {
    List<PlayingCard> listOfCards = [];
    for (Suit suit in Suit.values) {
      for (int rank = 1; rank < 11; rank++) {
        listOfCards.add(PlayingCard(rank: rank, suit: suit));
      }
    }
    listOfCards.shuffle();
    _deck.addAll(listOfCards);
  }

  PlayingCard drawTopCard() => _deck.removeFirst();

  PlayingCard get peekLastCard => _deck.last;

  int get cardsLeft => _deck.length;
}
