import 'dart:async';

import 'package:briscola_app/game_internals/bot.dart';
import 'package:briscola_app/game_internals/human_player.dart';
import 'package:briscola_app/game_internals/player.dart';
import 'package:briscola_app/game_internals/playing_card.dart';
import 'package:briscola_app/game_internals/round_manager.dart';
import 'package:briscola_app/play_session/card_distribution_provider.dart';
import 'package:briscola_app/play_session/card_positions.dart';
import 'package:briscola_app/play_session/card_positions_controller.dart';
import 'package:briscola_app/play_session/deck_widget.dart';
import 'package:briscola_app/play_session/moving_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flip_card/controllers/flip_card_controllers.dart';
import 'package:provider/provider.dart';

import '../game_internals/game.dart';

class BoardWidget extends StatefulWidget {
  const BoardWidget({super.key});

  @override
  State<StatefulWidget> createState() => _BoardWidgetState();
}

class _BoardWidgetState extends State<BoardWidget> {
  final CardPositions _positions = CardPositions();
  final CardPositionsController _positionController = CardPositionsController();

  final List<MovingCardData> _cardsWidgetsCreated = [];
  bool _isDistributing = false;
  bool _isCollecting = false;
  bool _isPlaying = false;

  bool _hasUserPlayed = false;
  bool _hasBotPlayed = false;
  bool _hasInitializedPositions = false;
  final List<MovingCardData> _cardsOnTheTable = [];

  RoundPhase _currentPhase = RoundPhase.distribution;

  // Animation times
  static const _timeForCardToBuild = Duration(milliseconds: 50);
  static const _pauseBetweenCardsDistribution = Duration(milliseconds: 200);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_hasInitializedPositions) {
      _positions.initialize(context); // Safe here
      _hasInitializedPositions = true;
    }
  }

  Future<void> _distributeCards() async {
    if (_isDistributing) {
      return;
    }
    _isDistributing = true;
    final deckPosition = _positions.getPosition(BoardLocations.deck);
    final orderderPlayers = context.read<RoundManager>().orderedPlayers;
    final completer = context.read<CardDistributionProvider>().completer;
    final numberOfCardsToDistribute =
        context.read<CardDistributionProvider>().cardsToDistribute;
    int cardsAlreadyDistributed = 0;
    for (Player player in orderderPlayers) {
      for (PlayingCard? card in player.hand) {
        // If card is last one we must tell backend we are done

        if (card == null) {
          continue;
        }
        cardsAlreadyDistributed++;

        final targetPosition = _positions.transformPositionKey(
            _positionController.whereToDistributeCards(player, card));

        // Create the cards
        final cardData = MovingCardData(
          card: card,
          position: deckPosition,
          isTappable: player is HumanPlayer,
        );

        if (cardsAlreadyDistributed == numberOfCardsToDistribute) {
          cardData.onMoveEnd = completer;
        }

        setState(() {
          _cardsWidgetsCreated.add(cardData);
        });

        // Wait for card to be created
        await Future.delayed(_timeForCardToBuild);

        // Distribute card
        setState(() {
          cardData.position = targetPosition;
        });

        if (player is HumanPlayer) {
          await Future.delayed(Duration(milliseconds: 200));
          cardData.controller.flipcard();
        }

        await Future.delayed(_pauseBetweenCardsDistribution);
      }
    }
    _isDistributing = false;
  }

  // Future<void> _distributeCards(
  //     {required List<Player> players,
  //     required CardPositions cardPositions,
  //     required Player startingPlayer}) async {
  //   // Animation constants
  //   const delayBetweenCards = Duration(milliseconds: 200);
  //   const timeForCardToBuild = Duration(milliseconds: 50);

  //   //Positioning
  //   final initialPosition =
  //       cardPositions.getCurrentPosition(BoardLocations.deck);

  //   if (_isDistributing) {
  //     return;
  //   }
  //   _isDistributing = true;

  //   final orderedPlayers = _getDistributionOrder(startingPlayer, players);
  //   for (Player player in orderedPlayers) {
  //     for (PlayingCard? card in player.hand) {
  //       if (card == null || _positionController.isAlreadyDistributed(card)) {
  //         continue;
  //       }
  //       final targetPosition = cardPositions.transformPositionKey(
  //           _positionController.whereToDistributeCards(player, card));

  //       final cardData = MovingCardData(
  //         card: card,
  //         position: initialPosition,
  //         isTappable: player is HumanPlayer,
  //       );

  //       _cardsWidgetsCreated.add(cardData);

  //       setState(() {});
  //       await Future.delayed(timeForCardToBuild);

  //       setState(() {
  //         cardData.position = targetPosition;
  //       });

  //       if (player is HumanPlayer) {
  //         await Future.delayed(Duration(milliseconds: 200));
  //         cardData.controller.flipcard();
  //       }

  //       await Future.delayed(delayBetweenCards);
  //     }
  //   }
  //   _isDistributing = false;
  //   setState(() {
  //     _updatePhase();
  //   });
  // }

  void _updatePhase() {
    switch (_currentPhase) {
      case RoundPhase.distribution:
        _currentPhase = RoundPhase.play;
      case RoundPhase.play:
        _currentPhase = RoundPhase.collection;
      case RoundPhase.collection:
        _currentPhase = RoundPhase.distribution;
    }
  }

  List<Player> _getDistributionOrder(
      Player startingPlayer, List<Player> allPlayers) {
    final List<Player> order = [];
    order.add(startingPlayer);
    order.add(allPlayers.firstWhere((player) => player != startingPlayer));
    return order;
  }

  Future<void> _playCard(
      PlayingCard card, CardPositions positions, Player player) async {
    if (_isDistributing ||
        _isCollecting ||
        _isPlaying ||
        _cardsWidgetsCreated.length < Player.maxCardsInHand * 2) {
      return;
    }
    _isPlaying = true;

    final cardWidget = _cardsWidgetsCreated.firstWhere((c) => c.card == card);
    final index = player is Bot ? 0 : 1;
    final target = positions.getPosition(BoardLocations.table, index);
    final completer = Completer<void>();
    cardWidget.onMoveEnd = completer;
    _positionController.freeHandSpot(player, card);
    _cardsOnTheTable.add(cardWidget);
    setState(() {
      cardWidget.position = target;
      if (player is Bot) {
        cardWidget.controller.flipcard();
        _hasBotPlayed = true;
      } else {
        _hasUserPlayed = true;
        player.userPlaysCard(card);
      }
    });
    await completer.future;
    _isPlaying = false;
    if (_hasBotPlayed && _hasUserPlayed) {
      setState(() {
        _updatePhase();
      });
    }
  }

  // Future<void> _collectCards(Player winner, CardPositions positions) async {
  //   if (_isCollecting) {
  //     return;
  //   }
  //   _isCollecting = true;

  //   final winnerLocation = winner is Bot
  //       ? BoardLocations.northPlayerPile
  //       : BoardLocations.southPlayerPile;
  //   final target = positions.getCurrentPosition(winnerLocation);
  //   await Future.delayed(Duration(milliseconds: 1000));
  //   final Completer<void> moveCompleter = Completer<void>();
  //   _cardsOnTheTable.first.onMoveEnd = moveCompleter;
  //   setState(() {
  //     if (_cardsOnTheTable.isNotEmpty) {
  //       _cardsOnTheTable.first.position = target;
  //       _cardsOnTheTable.last.position = target;
  //     }
  //   });
  //   await moveCompleter.future;
  //   if (_cardsOnTheTable.isNotEmpty) {
  //     _cardsWidgetsCreated
  //         .removeWhere((item) => _cardsOnTheTable.contains(item));
  //     _cardsOnTheTable.clear();
  //   }
  //   _hasBotPlayed = false;
  //   _hasUserPlayed = false;
  //   _isCollecting = false;
  //   setState(() {
  //     _updatePhase();
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final players = context.read<Game>().players;
    //final botPlayer = players[0];
    final humanPlayer = players[0];
    final round = context.read<RoundManager>();

    final distributionProvider = context.watch<CardDistributionProvider>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (distributionProvider.shouldDistribute && !_isDistributing) {
        _distributeCards().then((_) {
          distributionProvider.resetTrigger(); // avoid infinite loop
        });
      }
    });

    // // Distribution
    // if (_currentPhase == RoundPhase.distribution) {
    //   _distributeCards(
    //       startingPlayer: round.startingPlayer,
    //       players: players,
    //       cardPositions: positions);
    // }

    // //Bot play
    // if ((_currentPhase == RoundPhase.play &&
    //     round.startingPlayer is Bot &&
    //     !_hasBotPlayed)) {
    //   _playCard(round.cardsOnTheTable.last, positions, botPlayer);
    // }

    // if (_currentPhase == RoundPhase.collection) {
    //   _collectCards(round.startingPlayer, positions);
    // }

    return Stack(
      children: [
        // Deck
        Positioned(
          top: _positions.getPosition(BoardLocations.deck).top,
          left: _positions.getPosition(BoardLocations.deck).left,
          child: DeckWidget(),
        ),
        ..._cardsWidgetsCreated.map((card) => MovingCardWidget(
            position: card.position,
            card: card.card,
            controller: card.controller,
            onMoveComplete: card.onMoveEnd,
            onTap: () async {
              if (card.isTappable && round.isWaitingForInput) {
                await _playCard(card.card, _positions, humanPlayer);
              }
              // if (!_hasBotPlayed) {
              //   botPlayer.makeBotChooseCard();
              //   final cardPlayedByBot = round.cardsOnTheTable
              //       .firstWhere((item) => item != card.card);
              //   _playCard(cardPlayedByBot, positions, botPlayer);
              // }
            },
            key: card.key))
      ],
    );
  }
}

class MovingCardData {
  final PlayingCard card;
  Position position;
  final Key key;
  final FlipCardController controller = FlipCardController();
  final bool isTappable;
  Completer<void>? onMoveEnd;

  MovingCardData(
      {required this.card, required this.position, required this.isTappable})
      : key = ValueKey(card.toString());
}
