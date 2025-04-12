import 'package:briscola_app/game_internals/bot.dart';
import 'package:briscola_app/game_internals/game.dart';
import 'package:briscola_app/game_internals/human_player.dart';
import 'package:briscola_app/main_menu/main_menu_screen.dart';
import 'package:briscola_app/play_session/play_session_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) {
        return const MainMenuScreen();
      },
      routes: [
        GoRoute(
          path: 'play',
          builder: (context, state) {
            final botPlayer = Bot(name: 'Bot');
            final humanPlayer = HumanPlayer(name: 'Bob');
            final game = Game(players: [botPlayer, humanPlayer]);

            return MultiProvider(
              providers: [
                ChangeNotifierProvider.value(value: game),
                ChangeNotifierProvider.value(value: botPlayer),
                ChangeNotifierProvider.value(value: humanPlayer),
                ChangeNotifierProvider.value(value: game.roundManager),
                ChangeNotifierProvider.value(
                    value: game.roundManager.cardDistributionProvider),
              ],
              child: const PlaySessionScreen(),
            );
          },
        ),
      ],
    ),
  ],
);
