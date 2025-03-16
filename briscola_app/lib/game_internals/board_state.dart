import 'package:briscola_app/game_internals/playing_area.dart';

import 'game.dart';

class BoardState {
  final PlayingArea areaOne = PlayingArea();
  final Game game;

  BoardState({required this.game}) {
    game.addListener(_handleGameChange); // Listen to changes in Game
  }

  void _handleGameChange() {}

  void dispose() {
    areaOne.dispose();
  }
}
