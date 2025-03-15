import 'package:briscola_app/game_internals/round_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../game_internals/player.dart';

class PlayerInfoWidget extends StatelessWidget {
  final Player player;
  static const double height = 40;

  PlayerInfoWidget({required this.player, super.key});

  @override
  Widget build(BuildContext context) {
    final round = context.watch<RoundManager>();
    return SizedBox(
      height: height,
      child: Text(
        'Player: ${player.name} \n points: ${player.points}',
        style: TextStyle(color: Colors.white),
        textAlign: TextAlign.center,
      ),
    );
  }
}
