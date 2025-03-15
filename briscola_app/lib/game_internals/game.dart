import 'package:briscola_app/game_internals/deck.dart';
import 'package:briscola_app/game_internals/round_manager.dart';
import 'package:flutter/foundation.dart';

import 'player.dart';
import 'playing_card.dart';

class Game extends ChangeNotifier {
  static final Game _game = Game._internal();
  bool isFinished = false;

  final Deck deck = Deck();
  late final Suit suitOfBriscola;
  final List<Player> players = [];
  late final RoundManager roundManager;

  factory Game({required List<Player> players}) {
    _game._initialize(players);
    return _game;
  }

  Game._internal();

  void _initialize(List<Player> lisOfPlayers) {
    if (!_isGameInitialized()) {
      players.addAll(lisOfPlayers);
      suitOfBriscola = deck.peekLastCard.suit;
      roundManager = RoundManager(game: this);
    }

    _startGame();
  }

  void _startGame() {
    roundManager.startRound();
  }

  bool _isGameInitialized() {
    try {
      suitOfBriscola;
      return true;
    } catch (e) {
      return false;
    }
  }
}
