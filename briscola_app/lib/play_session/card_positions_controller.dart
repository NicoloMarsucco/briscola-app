// Class which tells us where each card should go
import 'package:briscola_app/game_internals/human_player.dart';
import 'package:briscola_app/game_internals/playing_card.dart';
import 'package:briscola_app/play_session/card_positions.dart';

import '../game_internals/bot.dart';
import '../game_internals/player.dart';

class CardPositionsController {
  final List<PlayingCard?> _botHandShown =
      List.filled(Player.maxCardsInHand, null);
  final List<PlayingCard?> _humanHandShown =
      List.filled(Player.maxCardsInHand, null);
  final Set<PlayingCard> _cardsDistributed = {};

  CardPositionsController();

  bool isAlreadyDistributed(PlayingCard card) {
    return _cardsDistributed.contains(card);
  }

  PositionKey whereToDistributeCards(Player player, PlayingCard card) {
    final targetArray = player is Bot ? _botHandShown : _humanHandShown;
    final index = targetArray.indexOf(null);
    targetArray[index] = card;
    _cardsDistributed.add(card);
    final location = player is HumanPlayer
        ? BoardLocations.southPlayerHand
        : BoardLocations.northPlayerHand;
    return PositionKey(boardLocation: location, index: index);
  }

  void freeHandSpot(Player player, PlayingCard card) {
    final targetHand = player is Bot ? _botHandShown : _humanHandShown;
    final index = targetHand.indexOf(card);
    if (index >= 0) {
      targetHand[index] = null;
    }
    _cardsDistributed.remove(card);
  }
}

class PositionKey {
  final BoardLocations boardLocation;
  final int index;

  PositionKey({required this.boardLocation, this.index = 0});
}

enum PlayerType { bot, human }
