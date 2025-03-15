import 'dart:developer' as dev;
import 'package:briscola_app/style/custom_text_styles.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

import 'app_lifecycle/app_lifecycle.dart';
import 'router.dart';
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
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
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
        Provider(create: (context) => Palette()),
        Provider(create: (context) => CustomTextStyles())
      ],
      child: Builder(builder: (context) {
        final palette = context.watch<Palette>();

        return MaterialApp.router(
          title: 'Briscola app',
          theme: ThemeData(scaffoldBackgroundColor: palette.background),
          routerConfig: router,
        );
      }),
    ));
  }
}
