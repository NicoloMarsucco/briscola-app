import 'dart:async';
import 'package:briscola_app/audio/audio_controller.dart';
import 'package:briscola_app/audio/sounds.dart';
import 'package:briscola_app/game_internals/human_player.dart';
import 'package:briscola_app/game_internals/player.dart';
import 'package:briscola_app/game_internals/playing_card.dart';
import 'package:briscola_app/play_session/card_positions.dart';
import 'package:briscola_app/play_session/card_positions_controller.dart';
import 'package:briscola_app/play_session/deck_widget.dart';
import 'package:briscola_app/play_session/end_game_widget.dart';
import 'package:briscola_app/play_session/moving_card_widget.dart';
import 'package:briscola_app/play_session/play_screen_controller.dart';
import 'package:briscola_app/play_session/playing_card_widget.dart';
import 'package:briscola_app/settings/settings.dart';
import 'package:briscola_app/style/custom_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flip_card/controllers/flip_card_controllers.dart';
import 'package:provider/provider.dart';

/// The board where the game is played.
class BoardWidget extends StatefulWidget {
  const BoardWidget({super.key});

  @override
  State<StatefulWidget> createState() => _BoardWidgetState();
}

class _BoardWidgetState extends State<BoardWidget> {
  /// The coordinates of the locations where cards may go.
  final CardPositions _positions = CardPositions();

  final CardPositionsController _positionController = CardPositionsController();

  final List<MovingCardData> _cardsWidgetsCreated = [];
  final Set<PlayingCard> _widgetsOfCardsCreated = {};
  bool _isDistributing = false;
  bool _isCollecting = false;
  bool _isPlaying = false;

  /// Time to allow [PlayingCardWidget]s to be rendered.
  static const _timeForCardToBuild = Duration(milliseconds: 50);

  static const _pauseBetweenCardsDistribution = Duration(milliseconds: 200);

  /// The number of cards left in the deck.
  int _cardsLeft = 40;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _positions.initialize(context);
  }

  Future<void> _distributeCards() async {
    if (_isDistributing) {
      return;
    }

    final audioController = context.read<AudioController>();

    _isDistributing = true;
    final deckPosition = _positions.getPosition(BoardLocations.deck);
    final orderderPlayers = context.read<PlayScreenController>().orderedPlayers;
    final completer =
        context.read<PlayScreenController>().distributionCompleter;
    final numberOfCardsToDistribute =
        context.read<PlayScreenController>().numberOfCardsToDistribute;
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
        audioController.playSfx(SfxType.deal);
        setState(() {
          _cardsLeft--;
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
    final isDeckShown = context.read<PlayScreenController>().showDeck;
    final PlayingCard cardPlayed =
        context.read<PlayScreenController>().cardPlayedByBot;
    final widgetPointer =
        _cardsWidgetsCreated.firstWhere((item) => item.card == cardPlayed);
    widgetPointer.onMoveEnd =
        context.read<PlayScreenController>().botPlayCompleter;
    setState(() {
      widgetPointer.position = _positions.getPosition(
          isDeckShown ? BoardLocations.table : BoardLocations.tableWithNoDeck,
          0);
    });
    _playCardDroppedSound();
    await Future.delayed(Duration(milliseconds: 100));
    widgetPointer.controller.flipcard();
    _positionController.freeHandSpot(true, cardPlayed);
    _isPlaying = false;
  }

  Future<void> _playUserChosenCard(PlayingCard cardPlayed) async {
    if (_isPlaying) {
      return;
    }
    _isPlaying = true;
    final isDeckShown = context.read<PlayScreenController>().showDeck;
    final controllerCompleter =
        context.read<PlayScreenController>().userPlayCompleter;
    final widgetPointer =
        _cardsWidgetsCreated.firstWhere((item) => item.card == cardPlayed);
    final momentaryCompleter = Completer<void>();
    widgetPointer.onMoveEnd = momentaryCompleter;
    setState(() {
      widgetPointer.position = _positions.getPosition(
          isDeckShown ? BoardLocations.table : BoardLocations.tableWithNoDeck,
          1);
    });
    _playCardDroppedSound();
    await momentaryCompleter.future;
    controllerCompleter.complete(cardPlayed);
    _isPlaying = false;
    _positionController.freeHandSpot(false, cardPlayed);
  }

  Future<void> _playCardDroppedSound() async {
    final audioController = context.read<AudioController>();
    Future.delayed(const Duration(milliseconds: 80));
    audioController.playSfx(SfxType.drop);
  }

  Future<void> _collectCards() async {
    if (_isCollecting) {
      return;
    }
    _isCollecting = true;
    final List<PlayingCard> cardsToCollect =
        context.read<PlayScreenController>().cardsToCollect;
    final List<MovingCardData> widgetsToCollect = [];
    for (int i = 0; i < cardsToCollect.length; i++) {
      widgetsToCollect.add(_cardsWidgetsCreated
          .firstWhere((movingcard) => movingcard.card == cardsToCollect[i]));
    }
    widgetsToCollect.last.onMoveEnd =
        context.read<PlayScreenController>().cardsCollectionCompleter;
    final isWinnerBot = context.read<PlayScreenController>().isWinnerPlayerBot;
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
    final settings = context.watch<SettingsController>();
    final controller = context.watch<PlayScreenController>();

    bool shouldDistribute = context.select<PlayScreenController, bool>(
        (controller) => controller.shouldDistribute);
    bool shouldPlayBotCard = context.select<PlayScreenController, bool>(
        (controller) => controller.shouldPlayBotCard);
    bool shouldUserChooseCard = context.select<PlayScreenController, bool>(
        (controller) => controller.shouldUserChooseCard);
    bool shouldCollectCards = context.select<PlayScreenController, bool>(
        (controller) => controller.shouldCollectCards);
    bool shouldShowEndOfGameWindow = context.select<PlayScreenController, bool>(
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

    if (shouldShowEndOfGameWindow) {
      // Reset in case of a new game.
      _cardsLeft = 40;
    }

    return Stack(
      children: [
        // Deck
        Positioned(
          top: _positions.getPosition(BoardLocations.deck).top,
          left: _positions.getPosition(BoardLocations.deck).left,
          child: DeckWidget(
              briscola: context.read<PlayScreenController>().briscola,
              showDeck: context.read<PlayScreenController>().showDeck),
        ),
        ..._cardsWidgetsCreated.map((card) => MovingCardWidget(
            position: card.position,
            card: card.card,
            controller: card.controller,
            onMoveComplete: card.onMoveEnd,
            onTap: () async {
              if (card.isTappable &&
                  shouldUserChooseCard &&
                  !controller.hasUserChosenCard) {
                controller.hasUserChosenCard = true;
                await _playUserChosenCard(card.card);
              }
            })),
        Positioned(
          top: _positions.getPosition(BoardLocations.deck).top +
              (PlayingCardWidget.height - _CardsLeft.size) / 2,
          left: _positions.getPosition(BoardLocations.deck).left +
              (PlayingCardWidget.width - _CardsLeft.size) / 2,
          child: ValueListenableBuilder<bool>(
              valueListenable: settings.showCardsLeft,
              builder: (context, showCardsLeft, child) {
                if (showCardsLeft &&
                    context.read<PlayScreenController>().showDeck) {
                  return _CardsLeft(_cardsLeft);
                }
                return SizedBox();
              }),
        ),
        if (shouldShowEndOfGameWindow)
          EndGameWidget(
            result: context.read<PlayScreenController>().result,
            points: context.read<PlayScreenController>().points,
            cardWidgetsCreated: _cardsWidgetsCreated,
            cardsCreated: _widgetsOfCardsCreated,
          )
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

/// Counter showing the number of cards left.
class _CardsLeft extends StatelessWidget {
  final int number;
  static const double size = 70;

  const _CardsLeft(this.number);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.black, width: 2)),
      alignment: Alignment.center,
      child: Text(
        number.toString(),
        style: context.read<CustomTextStyles>().cardsLeft,
      ),
    );
  }
}
