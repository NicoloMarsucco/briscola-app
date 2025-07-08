import 'dart:convert';

import 'package:briscola_app/history/persistence/history_persistence.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageHistoryPersistence extends HistoryPersistence {
  final Future<SharedPreferences> instanceFuture =
      SharedPreferences.getInstance();

  @override
  Future<Map<DateTime, int>> getHistory() async {
    // We must reformate the date as year-month-day othetrtwise it won't work.
    final prefs = await instanceFuture;
    final jsonString = prefs.getString('history');

    if (jsonString == null) {
      return {};
    }

    Map<String, dynamic> decoded = jsonDecode(jsonString);

    final Map<DateTime, int> result = {};

    for (var entry in decoded.entries) {
      final parsedDate = DateTime.parse(entry.key);
      final formattedDate =
          DateTime(parsedDate.year, parsedDate.month, parsedDate.day);
      result[formattedDate] = entry.value as int;
    }

    return result;
  }

  @override
  Future<void> saveHistory({required Map<DateTime, int> history}) async {
    // Must convert to JSON file and then save.
    final prefs = await instanceFuture;

    final stringKeyMap = {
      for (final entry in history.entries)
        entry.key.toIso8601String(): entry.value
    };

    await prefs.setString('history', jsonEncode(stringKeyMap));
  }
}
