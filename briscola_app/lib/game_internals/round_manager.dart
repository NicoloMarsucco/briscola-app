import 'dart:async';
import 'dart:math';
import 'package:briscola_app/game_internals/bot.dart';
import 'package:briscola_app/game_internals/card_strength_comparator.dart';
import 'package:briscola_app/game_internals/game_history.dart';
import 'package:briscola_app/game_internals/ordered_players.dart';
import 'package:briscola_app/play_session/play_screen_controller.dart';
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
  final PlayScreenController _playScreenController;

  final Logger _log = Logger("Round Manager");

  RoundManager({required Game game})
      : _game = game,
        _orderedPlayers = OrderedPlayers(players: game.players),
        _playScreenController =
            PlayScreenController(briscola: game.deck.peekLastCard, game: game) {
    _holderOfStrongestCard = _getRandomPlayer(_game.players);
  }

  Future<void> startRound() async {
    _log.info("---- New round ----");
    await _distributeCards();
    await _letPlayersMakeTheirPlay();
    await _collectCards();
  }

  void prepareForNewGame() {
    _playScreenController.newGame(_game.deck.peekLastCard);
    _holderOfStrongestCard = _getRandomPlayer(_game.players);
  }

  static Player _getRandomPlayer(List<Player> players) {
    final random = Random();
    return players[random.nextInt(players.length)];
  }

  Future<void> _distributeCards() async {
    if (_game.deck.cardsLeft < _game.players.length) {
      return;
    }
    if (_game.deck.cardsLeft / _game.players.length == 1) {
      _playScreenController.hideDeck();
    }
    int cardsToDistribute = 0;
    for (Player player in _game.players) {
      while (player.hand.contains(null)) {
        player.addCardToHand(_game.deck.drawTopCard());
        cardsToDistribute++;
      }
    }
    await _playScreenController.distributeCards(
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
        await _playScreenController.moveBotCardToTable(cardPlayed);
      } else {
        _log.info("Waiting for user input...");
        cardPlayed = await _playScreenController.makeUserChooseCard();
      }
      currentPlayer.removeCardFromHand(cardPlayed);
      _log.info("${currentPlayer.name} played $cardPlayed");
      _addCardToTable(cardPlayed, currentPlayer);
    }
  }

  void _addCardToTable(PlayingCard card, Player player) {
    _cardsOnTheTable.add(card);
    _game.gameHistory
        .recordMove(player: player, cards: [card], moveType: MoveType.play);
    if (CardStrengthComparator.isStronger(
        strongestCardOnTheTable: _strongestCardOnTheTable,
        cardPlayed: card,
        suitOfBriscola: _game.suitOfBriscola)) {
      _updateDetailsOfStrongestCard(card, player);
    }
  }

  void _updateDetailsOfStrongestCard(PlayingCard card, Player player) {
    _strongestCardOnTheTable = card;
    _holderOfStrongestCard = player;
  }

  Future<void> _collectCards() async {
    _log.info("Collecting cards...");
    _holderOfStrongestCard.collectPlayedCards(_cardsOnTheTable);
    _game.gameHistory.recordMove(
        player: _holderOfStrongestCard,
        cards: _cardsOnTheTable,
        moveType: MoveType.collect);
    await _playScreenController.collectCards(
        cardsOnTheTable, _holderOfStrongestCard is Bot);
    _cardsOnTheTable.clear();
    _strongestCardOnTheTable = null;
  }

  List<PlayingCard> get cardsOnTheTable => List.unmodifiable(_cardsOnTheTable);

  Player get startingPlayer => _holderOfStrongestCard;

  PlayScreenController get playScreenController => _playScreenController;

  List<Player> get orderedPlayers {
    return _orderedPlayers.getOrderedPlayers(_holderOfStrongestCard);
  }
}

enum RoundPhase { distribution, play, collection }
