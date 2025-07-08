import 'package:briscola_app/history/history.dart';
import 'package:briscola_app/style/app_button_widget.dart';
import 'package:briscola_app/style/custom_text_styles.dart';
import 'package:briscola_app/style/palette.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:simple_heatmap_calendar/simple_heatmap_calendar.dart';

class MainMenuScreen extends StatelessWidget {
  static final _log = Logger('MainMenuScreen');

  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();
    final customTextStyles = context.read<CustomTextStyles>();
    return Scaffold(
        backgroundColor: palette.backgroundMain,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          actions: [
            IconButton(
                onPressed: () => GoRouter.of(context).go('/settings'),
                icon: Icon(
                  Icons.settings,
                  color: palette.defaultWhite,
                ))
          ],
        ),
        extendBodyBehindAppBar: true,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Biscola\nArena",
              style: customTextStyles.mainMenuTitle,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 70,
            ),
            Center(child: _heatMapCalendar(context)),
            SizedBox(
              height: 70,
            ),
            SizedBox(
              width: 150,
              child: AppButtonWidget(
                text: "Play",
                onPressed: () {
                  _showDifficultyDialog(
                      context, customTextStyles, palette.backgroundMain);
                },
                palette: palette,
                textStyles: customTextStyles,
              ),
            )
          ],
        ));
  }

  Future<void> _showDifficultyDialog(BuildContext context,
      CustomTextStyles textStyles, Color backgroundColor) async {
    await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text(
            'Select difficulty:',
            style: textStyles.buttonText.copyWith(color: Colors.white),
            textAlign: TextAlign.center,
          ),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: const BorderSide(color: Colors.white, width: 1)),
          backgroundColor: backgroundColor,
          children: [
            difficultyOption(
                context: context,
                text: "Easy",
                color: Colors.green,
                textStyles: textStyles,
                difficultyId: "easy"),
            difficultyOption(
                context: context,
                text: "Medium",
                color: Colors.orange,
                textStyles: textStyles,
                difficultyId: 'medium'),
          ],
        );
      },
    );
  }

  Widget difficultyOption({
    required BuildContext context,
    required String text,
    required Color color,
    required CustomTextStyles textStyles,
    required String difficultyId,
  }) {
    return SimpleDialogOption(
      padding: EdgeInsets.zero,
      child: Center(
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () {
            Navigator.pop(context);
            context
                .goNamed('play', pathParameters: {'difficulty': difficultyId});
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Text(
              text,
              style: textStyles.buttonText.copyWith(color: color),
            ),
          ),
        ),
      ),
    );
  }

  Widget _heatMapCalendar(BuildContext context) {
    final now = DateTime.now();
    final map = context.watch<HistoryController>().history;
    final textStyles = context.read<CustomTextStyles>();
    _log.info("The map is now: $map");

    return HeatmapCalendar<num>(
      startDate: DateTime(now.year, now.month, now.day - 100),
      endedDate: DateTime(now.year, now.month, now.day),
      firstDay: DateTime.monday,
      colorMap: Palette.heatmapColorsMap,
      colorTipNum: 5,
      selectedMap: map,
      monthLabelItemBuilder: (context, date, defaultFormat) {
        return Text(
          DateFormat(defaultFormat).format(date),
          style: textStyles.heatmapMonthLabel,
        );
      },
      weekLabelValueBuilder: (context, protoDate, defaultFormat) {
        return Text(
          DateFormat(defaultFormat).format(protoDate),
          style: textStyles.heatmapWeekLabel,
        );
      },
      cellSize: const Size.square(17.0),
      colorTipCellSize: const Size.square(12.0),
      style: const HeatmapCalendarStyle.defaults(
        cellValueFontSize: 6.0,
        cellRadius: BorderRadius.all(Radius.circular(4.0)),
      ),
      layoutParameters: const HeatmapLayoutParameters.defaults(
        monthLabelPosition: CalendarMonthLabelPosition.top,
        weekLabelPosition: CalendarWeekLabelPosition.right,
        colorTipPosition: CalendarColorTipPosition.bottom,
      ),
      colorTipLeftHelper: Text(
        "No games",
        style: textStyles.heatmapWeekLabel.copyWith(fontSize: 11),
      ),
      colorTipRightHelper: Text(
        "Lots of games",
        style: textStyles.heatmapWeekLabel.copyWith(fontSize: 11),
      ),
    );
  }
}
