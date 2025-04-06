import 'package:briscola_app/game_internals/bot.dart';
import 'package:briscola_app/game_internals/player.dart';
import 'package:briscola_app/game_internals/playing_card.dart';
import 'package:briscola_app/game_internals/round_manager.dart';
import 'package:briscola_app/play_session/card_positions.dart';
import 'package:briscola_app/play_session/card_positions_controller.dart';
import 'package:briscola_app/play_session/deck_widget.dart';
import 'package:briscola_app/play_session/moving_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../game_internals/game.dart';

class BoardWidget extends StatefulWidget {
  const BoardWidget({super.key});

  @override
  State<StatefulWidget> createState() => _BoardWidgetState();
}

class _BoardWidgetState extends State<BoardWidget> {
  final CardPositionsController _positionController = CardPositionsController();

  final List<MovingCardData> _cardsWidgetsCreated = [];
  final Set<PlayingCard> _cardsShown = {};
  bool _isDistributing = false;

  void _distributeCards(
      {required List<PlayingCard?> backendBotHand,
      required List<PlayingCard?> backendHumanHand,
      required CardPositions cardPositions,
      required PlayerType startingPlayer}) async {
    const delayBetweenCards = Duration(milliseconds: 200);
    const timeForCardToBuild = Duration(milliseconds: 50);
    final initialPosition =
        cardPositions.getCurrentPosition(BoardLocations.deck);

    if (_isDistributing) {
      return;
    }
    _isDistributing = true;

    final order = _getDistributionOrder(startingPlayer);
    for (PlayerType type in order) {
      final hand = type == PlayerType.human ? backendHumanHand : backendBotHand;
      for (PlayingCard? card in hand) {
        if (card == null || _cardsShown.contains(card)) {
          continue;
        }
        final targetPosition = cardPositions.transformPositionKey(
            _positionController.whereToDistributeCards(type, card));

        final cardData = MovingCardData(
          card: card,
          position: initialPosition,
        );

        _cardsWidgetsCreated.add(cardData);
        _cardsShown.add(card);

        setState(() {});
        await Future.delayed(timeForCardToBuild);

        setState(() {
          cardData.position = targetPosition;
        });

        await Future.delayed(delayBetweenCards);
      }
    }
  }

  static List<PlayerType> _getDistributionOrder(PlayerType type) {
    return type == PlayerType.human
        ? [PlayerType.human, PlayerType.bot]
        : [PlayerType.bot, PlayerType.human];
  }

  PlayerType _determineFirstPlayerType(Player firstPlayer) {
    return firstPlayer is Bot ? PlayerType.bot : PlayerType.human;
  }

  @override
  Widget build(BuildContext context) {
    final players = context.watch<Game>().players;
    final botPlayer = players[0];
    final humanPlayer = players[1];
    final round = context.watch<RoundManager>();

    final positions = CardPositions(
        height: MediaQuery.sizeOf(context).height,
        width: MediaQuery.sizeOf(context).width);

    _distributeCards(
        startingPlayer: _determineFirstPlayerType(round.startingPlayer),
        backendBotHand: botPlayer.hand,
        backendHumanHand: humanPlayer.hand,
        cardPositions: positions);

    return Stack(
      children: [
        // Deck
        Positioned(
          top: positions.getCurrentPosition(BoardLocations.deck).top,
          left: positions.getCurrentPosition(BoardLocations.deck).left,
          child: DeckWidget(),
        ),
        ..._cardsWidgetsCreated.map((card) => MovingCardWidget(
            position: card.position, card: card.card, key: card.key))
      ],
    );
  }
}

class MovingCardData {
  final PlayingCard card;
  Position position;
  final bool isVisible = false;
  final Key key;

  MovingCardData({required this.card, required this.position})
      : key = ValueKey(card.toString());
}
