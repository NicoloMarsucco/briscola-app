import 'dart:async';
import 'package:briscola_app/game_internals/bot.dart';
import 'package:briscola_app/game_internals/ordered_players.dart';
import 'package:briscola_app/play_session/play_screen_animation_controller.dart';
import 'package:logging/logging.dart';

import 'game.dart';
import 'player.dart';
import 'playing_card.dart';

class RoundManager {
  final Game _game;

  final List<PlayingCard> _cardsOnTheTable = [];
  PlayingCard? _strongestCardOnTheTable;
  late Player _holderOfStrongestCard;

  final OrderedPlayers _orderedPlayers;
  final PlayScreenAnimationController _playScreenAnimationController;

  final Logger _log = Logger("Round Manager");

  RoundManager({required Game game})
      : _game = game,
        _orderedPlayers = OrderedPlayers(players: game.players),
        _playScreenAnimationController =
            PlayScreenAnimationController(briscola: game.deck.peekLastCard) {
    _holderOfStrongestCard = _game.players.first;
  }

  Future<void> startRound() async {
    _log.info("---- New round ----");
    await _distributeCards();
    await _letPlayersMakeTheirPlay();
    await _collectCards();
  }

  Future<void> _distributeCards() async {
    if (_game.deck.cardsLeft < _game.players.length) {
      return;
    }
    if (_game.deck.cardsLeft / _game.players.length == 1) {
      _playScreenAnimationController.hideDeck();
    }
    int cardsToDistribute = 0;
    for (Player player in _game.players) {
      while (player.hand.contains(null)) {
        player.addCardToHand(_game.deck.drawTopCard());
        cardsToDistribute++;
      }
    }
    await _playScreenAnimationController.distributeCards(
        cardsToDistribute, orderedPlayers);
  }

  Future<void> _letPlayersMakeTheirPlay() async {
    final indexOfStartingPlayer = _game.players.indexOf(_holderOfStrongestCard);

    for (int i = 0; i < _game.players.length; i++) {
      final currentPlayer =
          _game.players[(indexOfStartingPlayer + i) % _game.players.length];

      final PlayingCard cardPlayed;
      if (currentPlayer.isBot) {
        cardPlayed = await currentPlayer.makeBotChooseCard();
        await _playScreenAnimationController.moveBotCardToTable(cardPlayed);
      } else {
        _log.info("Waiting for user input...");
        cardPlayed = await _playScreenAnimationController.makeUserChooseCard();
      }
      currentPlayer.removeCardFromHand(cardPlayed);
      _log.info("${currentPlayer.name} played $cardPlayed");
      _addCardToTable(cardPlayed, currentPlayer);
    }
  }

  void _addCardToTable(PlayingCard card, Player player) {
    _cardsOnTheTable.add(card);
    if (_isStrongestCardOnTheTable(card)) {
      _updateDetailsOfStrongestCard(card, player);
    }
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
  }

  Future<void> _collectCards() async {
    _log.info("Collecting cards...");
    _holderOfStrongestCard.collectPlayedCards(_cardsOnTheTable);
    await _playScreenAnimationController.collectCards(
        cardsOnTheTable, _holderOfStrongestCard is Bot);
    _cardsOnTheTable.clear();
    _strongestCardOnTheTable = null;
  }

  List<PlayingCard> get cardsOnTheTable => List.unmodifiable(_cardsOnTheTable);

  Player get startingPlayer => _holderOfStrongestCard;

  PlayScreenAnimationController get playScreenAnimationController =>
      _playScreenAnimationController;

  List<Player> get orderedPlayers {
    return _orderedPlayers.getOrderedPlayers(_holderOfStrongestCard);
  }
}

enum RoundPhase { distribution, play, collection }
