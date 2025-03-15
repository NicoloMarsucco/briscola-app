import 'package:briscola_app/game_internals/playing_card.dart';
import 'package:flutter/foundation.dart';

abstract class Player extends ChangeNotifier implements Comparable<Player> {
  final String name;
  int _points = 0;
  final List<PlayingCard> _hand = [];
  final List<PlayingCard> _cardsWon = [];
  static const int maxCardsInHand = 3;

  Player({required this.name});

  @nonVirtual
  void addCardToHand(PlayingCard card) {
    _hand.add(card);
    notifyListeners();
  }

  @nonVirtual
  void collectPlayedCards(Iterable<PlayingCard> cardsOnTheTable) {
    for (PlayingCard card in cardsOnTheTable) {
      _points += card.points;
      _cardsWon.add(card);
    }
  }

  @nonVirtual
  int get points => _points;

  @nonVirtual
  List<PlayingCard> get viewHand => _hand;

  @override
  @nonVirtual
  int compareTo(Player other) {
    return _points.compareTo(other._points);
  }

  @nonVirtual
  void removeCardFromHand(PlayingCard card) {
    _hand.remove(card);
    notifyListeners();
  }

  Future<PlayingCard> playCard();

  @override
  String toString() {
    return name;
  }
}
