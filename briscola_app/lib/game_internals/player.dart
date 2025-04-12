import 'dart:async';

import 'package:briscola_app/game_internals/bot_strategy.dart';
import 'package:briscola_app/game_internals/playing_card.dart';
import 'package:flutter/foundation.dart';

import 'game_history.dart';

abstract class Player implements Comparable<Player> {
  final String name;

  int _points = 0;

  final List<PlayingCard?> _hand =
      List.filled(maxCardsInHand, null, growable: false);

  final List<PlayingCard> _cardsWon = [];

  final BotStrategy? _botStrategy;

  static const int maxCardsInHand = 3;

  Player({required this.name, BotStrategy? botStrategy})
      : _botStrategy = botStrategy;

  @nonVirtual
  void subscribePlayerToGameHistory(GameHistory gameHistory) {
    if (isBot) {
      _botStrategy!.gameHistory = gameHistory;
    }
  }

  @nonVirtual
  void addCardToHand(PlayingCard card) {
    final index = _hand.indexWhere((card) => card == null);
    if (index >= 0) {
      _hand[index] = card;
    }
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
  List<PlayingCard?> get hand => List.unmodifiable(_hand);

  @override
  @nonVirtual
  int compareTo(Player other) {
    return _points.compareTo(other._points);
  }

  @nonVirtual
  void removeCardFromHand(PlayingCard card) {
    _hand[_hand.indexOf(card)] = null;
  }

  @override
  String toString() {
    return name;
  }

  @nonVirtual
  Future<PlayingCard> makeBotChooseCard() {
    return _botStrategy!.chooseCardToPlay(hand);
  }

  @nonVirtual
  bool get isHandEmpty {
    return _hand.every((card) => card == null);
  }

  @nonVirtual
  bool get isBot => _botStrategy == null ? false : true;
}
