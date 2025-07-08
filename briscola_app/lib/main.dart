import 'dart:developer' as dev;

import 'package:briscola_app/history/history.dart';
import 'package:briscola_app/style/custom_text_styles.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

import 'app_lifecycle/app_lifecycle.dart';
import 'audio/audio_controller.dart';
import 'router.dart';
import 'settings/settings.dart';
import 'style/palette.dart';

Future<void> main() async {
  // Basic logging setup.
  Logger.root.level = kDebugMode ? Level.FINE : Level.INFO;
  Logger.root.onRecord.listen((record) {
    dev.log(
      record.message,
      time: record.time,
      level: record.level.value,
      name: record.loggerName,
    );
  });

  WidgetsFlutterBinding.ensureInitialized();

  // Put game into full screen mode on mobile devices.
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  // Lock the game to portrait mode on mobile devices.
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLifecycleObserver(
        child: MultiProvider(
      providers: [
        Provider(create: (context) => SettingsController()),
        Provider(create: (context) => Palette()),
        Provider(create: (context) => CustomTextStyles()),
        ChangeNotifierProvider(create: (context) => HistoryController()),
        // Set up audio.
        ProxyProvider2<AppLifecycleStateNotifier, SettingsController,
            AudioController>(
          create: (context) => AudioController(),
          update: (context, lifecycleNotifier, settings, audio) {
            audio!.attachDependencies(lifecycleNotifier, settings);
            return audio;
          },
          dispose: (context, audio) => audio.dispose(),
          // Ensures that music starts immediately.
          lazy: false,
        ),
      ],
      child: Builder(builder: (context) {
        final palette = context.watch<Palette>();

        return MaterialApp.router(
          title: 'Briscola app',
          theme: ThemeData(
              scaffoldBackgroundColor: palette.background, useMaterial3: true),
          routerConfig: router,
        );
      }),
    ));
  }
}
