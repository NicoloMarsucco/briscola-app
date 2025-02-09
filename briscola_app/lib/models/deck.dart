import 'dart:collection';

import 'package:briscola_app/models/card.dart';

class Deck {
  final _deck = ListQueue<Card>();

  Deck() {
    _prepareDeck();
  }

  _prepareDeck() {
    List<Card> listOfCards = [];
    for (Suit suit in Suit.values) {
      for (int rank = 1; rank < 11; rank++) {
        listOfCards.add(Card(rank: rank, suit: suit));
      }
    }
    listOfCards.shuffle();
    _deck.addAll(listOfCards);
  }

  Card drawTopCard() => _deck.removeFirst();

  Card get peekLastCard => _deck.last;

  int get cardsLeft => _deck.length;
}
