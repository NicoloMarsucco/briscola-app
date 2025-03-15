import 'dart:async';

import 'package:briscola_app/game_internals/bot.dart';
import 'package:briscola_app/game_internals/human_player.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import 'game.dart';
import 'player.dart';
import 'playing_card.dart';

class RoundManager extends ChangeNotifier {
  final Game game;
  final List<PlayingCard> _cardsOnTheTable = [];
  PlayingCard? _strongestCardOnTheTable;
  Player _holderOfStrongestCard;
  final Logger _log = Logger("Round Manager");
  bool _isLettingBotPlaySinkIn = false;
  bool _hasBotPlayed = false;

  RoundManager({required this.game}) : _holderOfStrongestCard = game.players[0];

  void startRound() {
    _distributeCards();
    if (_holderOfStrongestCard is Bot) {
      _letBotPlay(_holderOfStrongestCard);
      _hasBotPlayed = true;
    }
    _isLettingBotPlaySinkIn = false;
    //_letPlayersMakeTheirPlay();
    //_collectCards();
    //_determineFirstPlayerNextRound();
  }

  void acceptHumanCard(PlayingCard cardPlayed) async {
    // To prevent user interacting with UI while bot is playing
    if (_isLettingBotPlaySinkIn) {
      return;
    }
    _isLettingBotPlaySinkIn = true;
    _log.info("Nico played $cardPlayed");

    game.players[1].removeCardFromHand(cardPlayed);
    _addCardToTable(cardPlayed);

    if (_isCardStronger(cardPlayed)) {
      _updateDetailsOfStrongestCard(cardPlayed, game.players[1]);
    }

    if (!_hasBotPlayed) {
      _letBotPlay(game.players[0]);
      notifyListeners();
      await Future.delayed(Duration(seconds: 2));
      _hasBotPlayed = true;
    }
    _log.info("Round won by $_holderOfStrongestCard");
    _log.info("######## New round #########");
    _collectCards();
    if (game.players[0].viewHand.isNotEmpty &&
        game.players[1].viewHand.isNotEmpty) {
      _hasBotPlayed = false;
      startRound();
    } else {
      game.isFinished = true;
    }
  }

  void _endRound() {
    _collectCards();
    if (game.deck.cardsLeft >= game.players.length) {
      startRound();
    }
  }

  void _distributeCards() {
    if (game.deck.cardsLeft < game.players.length) {
      return;
    }
    for (Player player in game.players) {
      while (player.viewHand.length < Player.maxCardsInHand) {
        player.addCardToHand(game.deck.drawTopCard());
      }
    }
    notifyListeners();
  }

  void _addCardToTable(PlayingCard card) {
    _cardsOnTheTable.add(card);
    notifyListeners();
  }

  void _letBotPlay(Player bot) async {
    PlayingCard cardPlayed = await bot.playCard();
    _log.info("Bot played $cardPlayed");
    _addCardToTable(cardPlayed);
    if (_isCardStronger(cardPlayed)) {
      _updateDetailsOfStrongestCard(cardPlayed, bot);
    }
  }
/* 
  void _letPlayersMakeTheirPlay() async {
    for (int i = 0; i < game.players.length; i++) {
      Player currentPlayer = game.players[(i + game.players.indexOf(_holderOfStrongestCard)) % game.players.length];

      PlayingCard cardPlayed;

      if (currentPlayer is Bot) {
        cardPlayed = await currentPlayer.playCard();
      } else {
        cardPlayed = await _waitForHumanToPlayTheCard();
  
      }

      _addCardToTable(cardPlayed);

      

      if (_isCardStronger(cardPlayed)) {
        _updateDetailsOfStrongestCard(cardPlayed, currentPlayer);
      }
    }
  } */

  /*   */

  bool _isCardStronger(PlayingCard card) {
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
    return card.suit == game.suitOfBriscola;
  }

  void _updateDetailsOfStrongestCard(PlayingCard card, Player player) {
    _strongestCardOnTheTable = card;
    _holderOfStrongestCard = player;
    //_log.info("Strongest card is now $_strongestCardOnTheTable played by $_holderOfStrongestCard");
  }

  void _collectCards() {
    //_log.info("Cards on the table: $_cardsOnTheTable");
    _holderOfStrongestCard.collectPlayedCards(_cardsOnTheTable);
    _cardsOnTheTable.clear();
    _strongestCardOnTheTable = null;
    notifyListeners();
  }

  List<PlayingCard> get cardsOnTheTable => _cardsOnTheTable;
}
