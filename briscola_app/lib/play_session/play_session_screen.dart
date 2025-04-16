import 'package:briscola_app/game_internals/game.dart';
import 'package:briscola_app/play_session/board_widget.dart';
import 'package:flutter/material.dart';

class PlaySessionScreen extends StatefulWidget {
  final Game _game;

  PlaySessionScreen({super.key, required Game game}) : _game = game {
    _game.startGame();
  }

  @override
  State<PlaySessionScreen> createState() => _PlaySessionScreenState();
}

class _PlaySessionScreenState extends State<PlaySessionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BoardWidget(),
    );
  }
}
