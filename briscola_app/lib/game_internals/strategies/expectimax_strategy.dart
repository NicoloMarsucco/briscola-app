import 'dart:math';

import 'package:briscola_app/game_internals/card_strength_comparator.dart';
import 'package:briscola_app/game_internals/game_history.dart';
import 'package:briscola_app/game_internals/playing_card.dart';
import 'package:briscola_app/game_internals/strategies/bot_strategy.dart';
import 'package:briscola_app/game_internals/strategies/game_observer.dart';
import 'package:briscola_app/game_internals/strategies/random_strategy.dart';
import 'package:briscola_app/game_internals/strategies/simple_strategy.dart';

import '../deck.dart';
import '../player.dart';

class ExpectimaxStrategy extends BotStrategy {
  late GameObserver _gameObserver;
  late GameHistory _gameHistory;
  static const int simulationsPerCard = 100000;
  static const int depth = 6;
  static const double penaltyForBeingFirst = 1.0;
  static const double penaltyForBeingBriscola = 3.0;

  @override
  Future<PlayingCard> chooseCardToPlay(List<PlayingCard?> hand) async {
    final List<PlayingCard> cardsInHand =
        hand.whereType<PlayingCard>().toList();

    double maxScore = -99999999;
    PlayingCard bestCard = cardsInHand.first;
    final List<PlayingCard> possibleOpponentCards =
        _gameObserver.snapshotOpponentCardPossibilities(cardsInHand).toList();

    final List<PlayingCard> currentTable = _gameHistory.history.isEmpty ||
            (_gameHistory.lastMove.moveType == MoveType.collect)
        ? []
        : _gameHistory.lastMove.cards;

    for (PlayingCard card in cardsInHand) {
      double score = 0;
      for (int i = 0; i < simulationsPerCard; i++) {
        final myselfSimulated =
            SimulatedPlayer(name: "me", botStrategy: RandomStrategy());
        final opponentSimulated =
            SimulatedPlayer(name: "opponent", botStrategy: RandomStrategy());
        final sim = Simulation(
            myself: myselfSimulated,
            myHand: cardsInHand,
            cardsToUse: possibleOpponentCards,
            opponent: opponentSimulated,
            gameHistory: _gameHistory,
            table: currentTable,
            briscola: _gameHistory.lastCard.suit,
            cardPlayed: card);
        await sim.evolve(depth);
        score += myselfSimulated.points.toDouble() -
            opponentSimulated.points.toDouble();
        if (sim.nextPlayer == myselfSimulated && !sim.isGameFinished) {
          score -= penaltyForBeingFirst;
        }
        if (card.suit == _gameHistory.lastCard.suit) {
          score -= penaltyForBeingBriscola;
        }
      }
      score /= simulationsPerCard;
      if (score > maxScore) {
        maxScore = score;
        bestCard = card;
      }
    }
    return bestCard;
  }

  @override
  void setUpBotStrategy(GameHistory gameHistory) {
    _gameHistory = gameHistory;
    _gameObserver = GameObserver(gameHistory);
  }
}

class SimulatedPlayer extends Player {
  SimulatedPlayer({required super.name, required super.botStrategy});
}

class Simulation {
  final SimulatedPlayer _myself;
  final SimulatedPlayer _opponent;
  final GameHistory _gameHistory;
  final PlayingCard cardPlayed;
  final Deck _deck;
  final Suit briscola;
  final String id = _generateRandomId(4);
  final List<PlayingCard> _table = [];
  final List<Player> _orderedPlayers = [];

  Simulation(
      {required SimulatedPlayer myself,
      required List<PlayingCard?> myHand,
      required List<PlayingCard> cardsToUse,
      required SimulatedPlayer opponent,
      required GameHistory gameHistory,
      required List<PlayingCard> table,
      required this.briscola,
      required this.cardPlayed})
      : _myself = myself,
        _opponent = opponent,
        _gameHistory = gameHistory,
        _deck = Deck(cardsToUse: cardsToUse) {
    _myself.subscribePlayerToGameHistory(gameHistory);
    _opponent.subscribePlayerToGameHistory(gameHistory);
    myHand
        .whereType<PlayingCard>()
        .forEach((card) => myself.addCardToHand(card));
    _setUpOpponentsHand();
    _table.addAll(table);
    _orderedPlayers.addAll([_myself, _opponent]);
  }

  void _setUpOpponentsHand() {
    int cardsToGiveOpponent =
        min(_myself.hand.whereType<PlayingCard>().length, _deck.cardsLeft);
    for (int i = 0; i < cardsToGiveOpponent; i++) {
      _opponent.addCardToHand(_deck.drawTopCard());
    }
  }

  Future<void> evolve(int numberOfRounds) async {
    assert(numberOfRounds >= 1);
    for (int i = 0; i < numberOfRounds; i++) {
      if (_myself.hand.whereType<PlayingCard>().isEmpty) {
        return;
      }
      await _simulateRound(i);
    }
  }

  void _prepareOrderedPlayerForNextRound(Player winner) {
    if (_orderedPlayers.first != winner) {
      _swapOrderedPlayers();
    }
  }

  void _swapOrderedPlayers() {
    final temp = _orderedPlayers.first;
    _orderedPlayers.first = _orderedPlayers.last;
    _orderedPlayers.last = temp;
  }

  Future<void> _simulateRound(int round) async {
    if (round == 0) {
      _table.add(cardPlayed);
      _myself.removeCardFromHand(cardPlayed);
      if (_table.length == 2) {
        if (CardStrengthComparator.isStronger(
            strongestCardOnTheTable: _table.first,
            cardPlayed: cardPlayed,
            suitOfBriscola: briscola)) {
          _myself.collectPlayedCards(_table);
          _prepareOrderedPlayerForNextRound(_myself);
        } else {
          _opponent.collectPlayedCards(_table);
          _prepareOrderedPlayerForNextRound(_opponent);
        }
      } else {
        final opponentCard = await _opponent.makeBotChooseCard();
        _opponent.removeCardFromHand(opponentCard);
        if (CardStrengthComparator.isStronger(
            strongestCardOnTheTable: _table.first,
            cardPlayed: opponentCard,
            suitOfBriscola: briscola)) {
          _opponent.collectPlayedCards(_table);
          _prepareOrderedPlayerForNextRound(_opponent);
        } else {
          _myself.collectPlayedCards(_table);
          _prepareOrderedPlayerForNextRound(_myself);
        }
      }
      _table.clear();
    } else {
      _distributeCards();
      await _makePlayersPlay();
      _prepareOrderedPlayerForNextRound(_determineWinner());
      _collectCards();
      _table.clear();
    }
  }

  Player _determineWinner() {
    return CardStrengthComparator.isStronger(
            strongestCardOnTheTable: _table.first,
            cardPlayed: _table.last,
            suitOfBriscola: briscola)
        ? _orderedPlayers.last
        : _orderedPlayers.first;
  }

  void _distributeCards() {
    if (_deck.cardsLeft >= 2) {
      for (Player player in _orderedPlayers) {
        player.addCardToHand(_deck.drawTopCard());
      }
    }
  }

  Future<void> _makePlayersPlay() async {
    for (Player player in _orderedPlayers) {
      final cardPlayed = await player.makeBotChooseCard();
      player.removeCardFromHand(cardPlayed);
      _table.add(cardPlayed);
    }
  }

  void _collectCards() {
    bool hasSecondPlayerWon = CardStrengthComparator.isStronger(
        strongestCardOnTheTable: _table.first,
        cardPlayed: _table.last,
        suitOfBriscola: briscola);
    if (hasSecondPlayerWon) {
      _orderedPlayers.last.collectPlayedCards(_table);
    } else {
      _orderedPlayers.first.collectPlayedCards(_table);
    }
  }

  static String _generateRandomId(int length) {
    const chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final rand = Random();
    return List.generate(length, (_) => chars[rand.nextInt(chars.length)])
        .join();
  }

  Player get nextPlayer => _orderedPlayers.first;

  bool get isGameFinished =>
      _myself.hand.whereType<PlayingCard>().length +
          _opponent.hand.whereType<PlayingCard>().length ==
      0;
}
