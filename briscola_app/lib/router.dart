import 'package:briscola_app/audio/audio_controller.dart';
import 'package:briscola_app/game_internals/bot.dart';
import 'package:briscola_app/game_internals/game.dart';
import 'package:briscola_app/game_internals/human_player.dart';
import 'package:briscola_app/game_internals/strategies/bot_strategy.dart';
import 'package:briscola_app/main_menu/main_menu_screen.dart';
import 'package:briscola_app/play_session/play_session_screen.dart';
import 'package:briscola_app/settings/settings_screen.dart';
import 'package:briscola_app/transitions/fade_transitions_page.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      pageBuilder: (context, state) {
        return FadeTransitionPage(key: state.pageKey, child: MainMenuScreen());
      },
      routes: [
        GoRoute(
          name: 'play',
          path: 'play/:difficulty',
          pageBuilder: (context, state) {
            final difficulty = state.pathParameters['difficulty'] ?? 'easy';

            // Pause music
            final audioController =
                Provider.of<AudioController>(context, listen: false);
            audioController.stopAllSound();

            final botPlayer =
                Bot(name: 'Bot', difficulty: Difficulty.fromString(difficulty));
            final humanPlayer = HumanPlayer(name: 'Bob');
            final game = Game(players: [botPlayer, humanPlayer]);

            return FadeTransitionPage(
              key: state.pageKey,
              child: MultiProvider(providers: [
                ChangeNotifierProvider.value(
                    value: game.roundManager.playScreenController),
              ], child: PlaySessionScreen(game: game)),
            );
          },
        ),
        GoRoute(
          path: 'settings',
          pageBuilder: (context, state) {
            return FadeTransitionPage(
                key: state.pageKey, child: const SettingsScreen());
          },
        )
      ],
    ),
  ],
);
