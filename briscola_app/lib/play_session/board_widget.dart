import 'dart:async';
import 'package:briscola_app/game_internals/human_player.dart';
import 'package:briscola_app/game_internals/player.dart';
import 'package:briscola_app/game_internals/playing_card.dart';
import 'package:briscola_app/play_session/card_positions.dart';
import 'package:briscola_app/play_session/card_positions_controller.dart';
import 'package:briscola_app/play_session/deck_widget.dart';
import 'package:briscola_app/play_session/end_game_widget.dart';
import 'package:briscola_app/play_session/moving_card_widget.dart';
import 'package:briscola_app/play_session/play_screen_animation_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flip_card/controllers/flip_card_controllers.dart';
import 'package:provider/provider.dart';

class BoardWidget extends StatefulWidget {
  const BoardWidget({super.key});

  @override
  State<StatefulWidget> createState() => _BoardWidgetState();
}

class _BoardWidgetState extends State<BoardWidget> {
  final CardPositions _positions = CardPositions();
  final CardPositionsController _positionController = CardPositionsController();

  final List<MovingCardData> _cardsWidgetsCreated = [];
  final Set<PlayingCard> _widgetsOfCardsCreated = {};
  bool _isDistributing = false;
  bool _isCollecting = false;
  bool _isPlaying = false;
  bool _hasInitializedPositions = false;

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
    final orderderPlayers =
        context.read<PlayScreenAnimationController>().orderedPlayers;
    final completer =
        context.read<PlayScreenAnimationController>().distributionCompleter;
    final numberOfCardsToDistribute =
        context.read<PlayScreenAnimationController>().numberOfCardsToDistribute;
    int cardsAlreadyDistributed = 0;
    for (Player player in orderderPlayers) {
      for (PlayingCard? card in player.hand) {
        // If card is last one we must tell backend we are done

        if (card == null || !_widgetsOfCardsCreated.add(card)) {
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

  Future<void> _playBotCard() async {
    if (_isPlaying) {
      return;
    }
    _isPlaying = true;
    final PlayingCard cardPlayed =
        context.read<PlayScreenAnimationController>().cardPlayedByBot;
    final widgetPointer =
        _cardsWidgetsCreated.firstWhere((item) => item.card == cardPlayed);
    widgetPointer.onMoveEnd =
        context.read<PlayScreenAnimationController>().botPlayCompleter;
    setState(() {
      widgetPointer.position = _positions.getPosition(BoardLocations.table, 0);
    });
    await Future.delayed(Duration(milliseconds: 200));
    widgetPointer.controller.flipcard();
    _positionController.freeHandSpot(true, cardPlayed);
    _isPlaying = false;
  }

  Future<void> _playUserChosenCard(PlayingCard cardPlayed) async {
    if (_isPlaying) {
      return;
    }
    _isPlaying = true;
    final controllerCompleter =
        context.read<PlayScreenAnimationController>().userPlayCompleter;
    final widgetPointer =
        _cardsWidgetsCreated.firstWhere((item) => item.card == cardPlayed);
    final momentaryCompleter = Completer<void>();
    widgetPointer.onMoveEnd = momentaryCompleter;
    setState(() {
      widgetPointer.position = _positions.getPosition(BoardLocations.table, 1);
    });
    await momentaryCompleter.future;
    controllerCompleter.complete(cardPlayed);
    _isPlaying = false;
    _positionController.freeHandSpot(false, cardPlayed);
  }

  Future<void> _collectCards() async {
    if (_isCollecting) {
      return;
    }
    _isCollecting = true;
    final List<PlayingCard> cardsToCollect =
        context.read<PlayScreenAnimationController>().cardsToCollect;
    final List<MovingCardData> widgetsToCollect = [];
    for (int i = 0; i < cardsToCollect.length; i++) {
      widgetsToCollect.add(_cardsWidgetsCreated
          .firstWhere((movingcard) => movingcard.card == cardsToCollect[i]));
    }
    widgetsToCollect.last.onMoveEnd =
        context.read<PlayScreenAnimationController>().cardsCollectionCompleter;
    final isWinnerBot =
        context.read<PlayScreenAnimationController>().isWinnerPlayerBot;
    final targetBoardLocations = isWinnerBot
        ? BoardLocations.northPlayerPile
        : BoardLocations.southPlayerPile;
    final targetDestination = _positions.getPosition(targetBoardLocations);
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      for (MovingCardData card in widgetsToCollect) {
        card.position = targetDestination;
      }
    });
    _widgetsOfCardsCreated.removeAll(widgetsToCollect.map((item) => item.card));
    _isCollecting = false;
  }

  @override
  Widget build(BuildContext context) {
    //Flags to trigger animations
    bool shouldDistribute = context.select<PlayScreenAnimationController, bool>(
        (controller) => controller.shouldDistribute);
    bool shouldPlayBotCard =
        context.select<PlayScreenAnimationController, bool>(
            (controller) => controller.shouldPlayBotCard);
    bool shouldUserChooseCard =
        context.select<PlayScreenAnimationController, bool>(
            (controller) => controller.shouldUserChooseCard);
    bool shouldCollectCards =
        context.select<PlayScreenAnimationController, bool>(
            (controller) => controller.shouldCollectCards);
    bool shouldShowEndOfGameWindow =
        context.select<PlayScreenAnimationController, bool>(
            (controller) => controller.shouldShowEndOfGameWindow);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (shouldDistribute && !_isDistributing) {
        _distributeCards();
      } else if (shouldPlayBotCard && !_isPlaying) {
        _playBotCard();
      } else if (shouldCollectCards && !_isCollecting) {
        _collectCards();
      }
    });

    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/background/colorful-gradient.jpg"),
              fit: BoxFit.cover)),
      child: Stack(
        children: [
          // Deck
          Positioned(
            top: _positions.getPosition(BoardLocations.deck).top,
            left: _positions.getPosition(BoardLocations.deck).left,
            child: DeckWidget(
                briscola:
                    context.read<PlayScreenAnimationController>().briscola,
                showDeck:
                    context.read<PlayScreenAnimationController>().showDeck),
          ),
          ..._cardsWidgetsCreated.map((card) => MovingCardWidget(
              position: card.position,
              card: card.card,
              controller: card.controller,
              onMoveComplete: card.onMoveEnd,
              onTap: () async {
                if (card.isTappable && shouldUserChooseCard) {
                  await _playUserChosenCard(card.card);
                }
              })),
          if (shouldShowEndOfGameWindow)
            EndGameWidget(
              result: context.read<PlayScreenAnimationController>().result,
              points: context.read<PlayScreenAnimationController>().points,
              cardWidgetsCreated: _cardsWidgetsCreated,
              cardsCreated: _widgetsOfCardsCreated,
            )
        ],
      ),
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
