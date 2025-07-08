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

  MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();
    final customTextStyles = context.watch<CustomTextStyles>();
    var theme = Theme.of(context);
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
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(child: _heatMapCalendar(context)),
            SizedBox(
              height: 50,
            ),
            SizedBox(
              width: 150,
              child: AppButtonWidget(
                text: "Play",
                onPressed: () {
                  _showDifficultyDialog(context, customTextStyles);
                },
                palette: palette,
                textStyles: customTextStyles,
              ),
            )
          ],
        ));
  }

  Future<void> _showDifficultyDialog(
      BuildContext context, CustomTextStyles textStyles) async {
    await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text(
            'Select difficulty:',
            style: textStyles.buttonText,
            textAlign: TextAlign.center,
          ),
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
    _log.info("The map is now: $map");

    return HeatmapCalendar<num>(
      startDate: DateTime(now.year, now.month, now.day - 100),
      endedDate: DateTime(now.year, now.month, now.day),
      firstDay: DateTime.monday,
      colorMap: Palette.heatmapColorsMap,
      selectedMap: map,
      monthLabelItemBuilder: (context, date, defaultFormat) {
        return Text(
          DateFormat(defaultFormat).format(date),
          style: const TextStyle(
            fontFamily:
                'Montserrat', // 🎯 **Specify your desired font family here**
            fontSize:
                14.0, // You can adjust the size here too, overriding `monthLabelFontSize`
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple, // Example color
          ),
        );
      },
      cellSize: const Size.square(16.0),
      colorTipCellSize: const Size.square(12.0),
      style: const HeatmapCalendarStyle.defaults(
        cellValueFontSize: 6.0,
        cellRadius: BorderRadius.all(Radius.circular(4.0)),
        weekLabelValueFontSize: 12.0,
        monthLabelFontSize: 12.0,
      ),
      layoutParameters: const HeatmapLayoutParameters.defaults(
        monthLabelPosition: CalendarMonthLabelPosition.top,
        weekLabelPosition: CalendarWeekLabelPosition.right,
        colorTipPosition: CalendarColorTipPosition.bottom,
      ),
    );
  }
}
