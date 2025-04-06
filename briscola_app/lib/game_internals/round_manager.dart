import 'dart:async';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import 'game.dart';
import 'player.dart';
import 'playing_card.dart';

class RoundManager extends ChangeNotifier {
  final Game _game;

  final List<PlayingCard> _cardsOnTheTable = [];
  PlayingCard? _strongestCardOnTheTable;
  late Player _holderOfStrongestCard;
  RoundPhase _phase = RoundPhase.distribution;

  final Logger _log = Logger("Round Manager");

  RoundManager({required Game game}) : _game = game {
    _holderOfStrongestCard = _game.players.first;
  }

  Future<void> startRound() async {
    _distributeCards();
    await _letPlayersMakeTheirPlay();
    _collectCards();
    _resetCompleters();
  }

  void _distributeCards() {
    _phase = RoundPhase.distribution;
    if (_game.deck.cardsLeft < _game.players.length) {
      return;
    }
    for (Player player in _game.players) {
      while (player.hand.contains(null)) {
        player.addCardToHand(_game.deck.drawTopCard());
      }
    }
    notifyListeners();
  }

  Future<void> _letPlayersMakeTheirPlay() async {
    _phase = RoundPhase.play;
    final indexOfStartingPlayer = _game.players.indexOf(_holderOfStrongestCard);

    for (int i = 0; i < _game.players.length; i++) {
      final currentPlayer =
          _game.players[(indexOfStartingPlayer + i) % _game.players.length];

      final PlayingCard cardPlayed;
      if (currentPlayer.isBot) {
        cardPlayed = await currentPlayer.makeBotChooseCard();
      } else {
        cardPlayed = await currentPlayer.waitForPlayerMove();
      }
      currentPlayer.removeCardFromHand(cardPlayed);
      _log.info("${currentPlayer.name} played $cardPlayed");
      _addCardToTable(cardPlayed, currentPlayer);
      if (currentPlayer.isBot && i == _game.players.length - 1) {
        await Future.delayed(Duration(seconds: 2));
      }
    }
  }

  void _addCardToTable(PlayingCard card, Player player) {
    _cardsOnTheTable.add(card);
    if (_isStrongestCardOnTheTable(card)) {
      _updateDetailsOfStrongestCard(card, player);
    }
    notifyListeners();
  }

  bool _isStrongestCardOnTheTable(PlayingCard card) {
    // If first card, it is the strongest on the table
    if (_strongestCardOnTheTable == null) {
      return true;
    }

    // If the cards are of the same suit and the new one has more
    // points, it has to be stronger, otherwise not (regardless of wheter or not
    // it a briscola)
    if (card.suit == _strongestCardOnTheTable!.suit) {
      if (card.points == 0 && _strongestCardOnTheTable!.points == 0) {
        return card.rank > _strongestCardOnTheTable!.rank;
      }
      return card.points > _strongestCardOnTheTable!.points;
    }

    // If of different suits, only a briscola can win.
    // If this is the case, it does not matter the number of point
    // cause we have already checked the case in which both cards are briscolas
    return card.suit == _game.suitOfBriscola;
  }

  void _updateDetailsOfStrongestCard(PlayingCard card, Player player) {
    _strongestCardOnTheTable = card;
    _holderOfStrongestCard = player;
    _log.info(
        "Strongest card is now $_strongestCardOnTheTable played by $_holderOfStrongestCard");
  }

  void _collectCards() {
    _phase = RoundPhase.collection;
    _holderOfStrongestCard.collectPlayedCards(_cardsOnTheTable);
    _cardsOnTheTable.clear();
    _strongestCardOnTheTable = null;
    notifyListeners();
  }

  List<PlayingCard> get cardsOnTheTable => List.unmodifiable(_cardsOnTheTable);

  void _resetCompleters() {
    for (Player player in _game.players) {
      player.resetCompleter();
    }
  }

  RoundPhase get phase => _phase;

  Player get startingPlayer => _holderOfStrongestCard;
}

enum RoundPhase { distribution, play, collection }
