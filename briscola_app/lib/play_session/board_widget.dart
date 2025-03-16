import 'package:briscola_app/play_session/player_hand_widget.dart';
import 'package:briscola_app/play_session/player_info_widget.dart';
import 'package:briscola_app/play_session/playing_area_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../game_internals/game.dart';

class BoardWidget extends StatefulWidget {
  const BoardWidget({super.key});

  @override
  State<StatefulWidget> createState() => _BoardWidgetState();
}

class _BoardWidgetState extends State<BoardWidget> {
  @override
  Widget build(BuildContext context) {
    final players = context.watch<Game>().players;
    final botPlayer = players[0];
    final humanPlayer = players[1];

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PlayerInfoWidget(player: botPlayer),
        PlayerHandWidget(
          player: botPlayer,
          showCards: false,
          areCardsDraggable: false,
        ),
        PlayingAreaWidget(),
        PlayerHandWidget(
          player: humanPlayer,
          showCards: true,
          areCardsDraggable: true,
        ),
        PlayerInfoWidget(player: humanPlayer)
      ],
    );
  }
}
