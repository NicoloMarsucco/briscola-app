import 'package:briscola_app/game_internals/game.dart';
import 'package:briscola_app/play_session/board_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlaySessionScreen extends StatefulWidget {
  const PlaySessionScreen({super.key});

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

  @override
  void initState() {
    super.initState();
    final game = Provider.of<Game>(context, listen: false);
    game.startGame();
  }
}
