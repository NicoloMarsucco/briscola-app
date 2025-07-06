import 'package:briscola_app/audio/audio_controller.dart';
import 'package:briscola_app/game_internals/bot.dart';
import 'package:briscola_app/game_internals/game.dart';
import 'package:briscola_app/game_internals/human_player.dart';
import 'package:briscola_app/main_menu/main_menu_screen.dart';
import 'package:briscola_app/play_session/play_session_screen.dart';
import 'package:briscola_app/settings/settings_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) {
        return MainMenuScreen();
      },
      routes: [
        GoRoute(
          path: 'play',
          builder: (context, state) {
            // Pause music
            final audioController =
                Provider.of<AudioController>(context, listen: false);
            audioController.stopAllSound();

            final botPlayer = Bot(name: 'Bot');
            final humanPlayer = HumanPlayer(name: 'Bob');
            final game = Game(players: [botPlayer, humanPlayer]);

            return MultiProvider(providers: [
              ChangeNotifierProvider.value(
                  value: game.roundManager.playScreenController),
            ], child: PlaySessionScreen(game: game));
          },
        ),
        GoRoute(
          path: 'settings',
          builder: (context, state) =>
              const SettingsScreen(key: Key('settings')),
        )
      ],
    ),
  ],
);
