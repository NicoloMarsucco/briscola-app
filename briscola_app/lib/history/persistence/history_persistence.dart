/// An interface of persistance stores for the history of games.
/// (Used for the heatmap on the main page).
abstract class HistoryPersistence {
  Future<Map<DateTime, int>> getHistory();
  Future<void> saveHistory({required Map<DateTime, int> history});
}
