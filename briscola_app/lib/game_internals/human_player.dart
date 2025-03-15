import 'dart:async';

import 'package:briscola_app/game_internals/player.dart';
import 'package:briscola_app/game_internals/playing_card.dart';

class HumanPlayer extends Player {
  HumanPlayer({required super.name});

  Completer<PlayingCard>? _completer;

  @override
  Future<PlayingCard> playCard() {
    _completer = Completer<PlayingCard>();
    return _completer!.future;
  }

  void onCardSelected(PlayingCard card) {
    if (_completer != null && !_completer!.isCompleted) {
      _completer!.complete(card);
      removeCardFromHand(card);
    }
  }
}
