import 'package:briscola_app/game_internals/board_state.dart';
import 'package:briscola_app/game_internals/game.dart';
import 'package:briscola_app/game_internals/playing_card.dart';
import 'package:briscola_app/play_session/board_widget.dart';
import 'package:briscola_app/style/palette.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

import 'playing_card_widget.dart';

class PlaySessionScreen extends StatefulWidget {
  const PlaySessionScreen({super.key});

  @override
  State<PlaySessionScreen> createState() => _PlaySessionScreenState();
}

class _PlaySessionScreenState extends State<PlaySessionScreen> {
  static final _log = Logger('PlaySessionScreen');

  @override
  Widget build(BuildContext context) {
    final game = context.watch<Game>();
    return Scaffold(
      appBar: AppBar(
        title: Text("${game.players[0]} vs ${game.players[1]}"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [BoardWidget()],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }
}
