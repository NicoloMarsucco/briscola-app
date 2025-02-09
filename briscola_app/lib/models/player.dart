import 'package:briscola_app/models/card.dart';
import 'package:flutter/foundation.dart';

abstract class Player implements Comparable<Player> {
  final String name;
  int _points = 0;
  final List<Card> _hand = [];
  final List<Card> _cardsWon = [];

  Player({required this.name});

  @nonVirtual
  void addCardToHand(Card card) {
    if (_hand.length >= 3) {
      throw StateError('A player cannot have more than 3 cards');
    }
    _hand.add(card);
  }

  @nonVirtual
  void collectPlayedCards(Iterable<Card> cardsOnTheTable) {
    for (Card card in cardsOnTheTable) {
      _points += card.points;
      _cardsWon.add(card);
    }
  }

  @nonVirtual
  int get points => _points;

  @nonVirtual
  int get cardsInHand => _hand.length;

  @nonVirtual
  List<Card> get viewHand => _hand;

  @override
  @nonVirtual
  int compareTo(Player other) {
    return _points.compareTo(other._points);
  }

  @nonVirtual
  void removeCardFromHand(Card card) {
    _hand.remove(card);
  }

  Future<Card> playCard();
}
