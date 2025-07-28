import 'package:briscola_app/settings/settings.dart';
import 'package:briscola_app/style/custom_text_styles.dart';
import 'package:briscola_app/style/palette.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  static const double _horizontalPadding = 20;
  static const double _horizontalPaddingRows = 8;
  static const SizedBox _gap = SizedBox(
    height: 10,
  );

  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsController>();
    final palette = context.watch<Palette>();
    final customTextStyles = context.watch<CustomTextStyles>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: palette.defaultWhite,
            )),
      ),
      backgroundColor: palette.primaryColor,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: _horizontalPadding),
        child: ListView(
          children: [
            const _SettingsHeader(heading: "Audio"),
            ValueListenableBuilder<bool>(
                valueListenable: settings.musicOn,
                builder: (context, musicOn, child) => _SettingsSwitchLine(
                      title: "Music",
                      value: musicOn,
                      onChanged: (_) => settings.toggleMusicOn(),
                    )),
            ValueListenableBuilder<bool>(
                valueListenable: settings.soundsOn,
                builder: (context, soundsOn, child) => _SettingsSwitchLine(
                      title: "Sound effects",
                      value: soundsOn,
                      onChanged: (_) => settings.toggleSoundsOn(),
                    )),
            _gap,
            const _SettingsHeader(heading: "Visuals"),
            ValueListenableBuilder<bool>(
                valueListenable: settings.showCardsLeft,
                builder: (context, showCardsLeft, child) => _SettingsSwitchLine(
                      title: "Show cards left",
                      value: showCardsLeft,
                      onChanged: (_) => settings.toggleShowCardsLeft(),
                    ))
          ],
        ),
      ),
    );
  }
}

/// Header with horizontal line separator for the
/// [SettingsScreen] page.
class _SettingsHeader extends StatelessWidget {
  final String heading;

  const _SettingsHeader({super.key, required this.heading});

  @override
  Widget build(BuildContext context) {
    final style = context.watch<CustomTextStyles>().settingsHeader;
    final color = context.watch<Palette>().defaultWhite;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          heading,
          style: style,
        ),
        Divider(
          color: color,
          thickness: 1.2,
        )
      ],
    );
  }
}

class _SettingsSwitchLine extends StatelessWidget {
  final String title;
  final bool value;
  final ValueChanged<bool>? onChanged;

  const _SettingsSwitchLine(
      {required this.title, required this.value, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: SettingsScreen._horizontalPaddingRows),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.watch<CustomTextStyles>().settingsEntry,
            ),
          ),
          Transform.scale(
              scale: 0.95,
              child: CupertinoSwitch(
                value: value,
                onChanged: onChanged,
                thumbColor: Colors.white, // always white thumb
              ))
        ],
      ),
    );
  }
}
