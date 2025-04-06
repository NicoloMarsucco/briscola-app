// Class which tells us where each card should go
import 'package:briscola_app/game_internals/playing_card.dart';
import 'package:briscola_app/play_session/card_positions.dart';

import '../game_internals/player.dart';

class CardPositionsController {
  final Map<PlayerType, List<PlayingCard?>> _handsCardShown = {};
  final Map<PlayerType, Set<PlayingCard>> _cardsDistributed = {};

  CardPositionsController() {
    _initializeHandCardsShown();
    _initializeCardsDistributedSet();
  }

  void _initializeHandCardsShown() {
    for (PlayerType playerType in PlayerType.values) {
      _handsCardShown.putIfAbsent(playerType, () => []);
      _handsCardShown[playerType] = List.filled(Player.maxCardsInHand, null);
    }
  }

  void _initializeCardsDistributedSet() {
    for (PlayerType type in PlayerType.values) {
      _cardsDistributed.putIfAbsent(type, () => {});
    }
  }

  bool isAlreadyDistributed(PlayerType type, PlayingCard card) {
    return _cardsDistributed[type]!.contains(card);
  }

  PositionKey whereToDistributeCards(PlayerType type, PlayingCard card) {
    int index = _handsCardShown[type]!.indexOf(null);
    BoardLocations location = type == PlayerType.human
        ? BoardLocations.southPlayerHand
        : BoardLocations.northPlayerHand;
    _handsCardShown[type]![index] = card;
    _cardsDistributed[type]!.add(card);
    return PositionKey(boardLocation: location, index: index);
  }
}

class PositionKey {
  final BoardLocations boardLocation;
  final int index;

  PositionKey({required this.boardLocation, this.index = 0});
}

enum PlayerType { bot, human }
