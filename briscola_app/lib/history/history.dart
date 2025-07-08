import 'package:briscola_app/history/persistence/history_persistence.dart';
import 'package:briscola_app/history/persistence/local_storage_history_persistence.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

class HistoryController extends ChangeNotifier {
  static final _log = Logger('HistoryController');

  /// The map tracking the history.
  final Map<DateTime, int> _history = {};

  Map<DateTime, int> get history => Map.unmodifiable(_history);

  /// The persistence store that is used to save the hisory.
  final HistoryPersistence _store;

  /// Creates a new instance of [HistoryController] backed by [store].
  HistoryController({HistoryPersistence? store})
      : _store = store ?? LocalStorageHistoryPersistence() {
    _loadStateFromPersistence();
  }

  /// Records a game happening at [now].
  void recordGame(DateTime now) {
    DateTime formattedDate = DateTime(now.year, now.month, now.day);
    _history[formattedDate] = (_history[formattedDate] ?? 0) + 1;
    _log.fine("Game recorded!");
    _store.saveHistory(history: _history);
    notifyListeners();
  }

  /// Asynchronously loads values from the injected persistence store.
  Future<void> _loadStateFromPersistence() async {
    _history.addAll(await _store.getHistory());
    notifyListeners();
    _log.fine(() => "Loaded history: $_history");
  }
}
