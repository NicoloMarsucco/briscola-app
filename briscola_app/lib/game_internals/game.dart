import 'package:briscola_app/game_internals/deck.dart';
import 'package:briscola_app/game_internals/game_history.dart';
import 'package:briscola_app/game_internals/round_manager.dart';
import 'player.dart';
import 'playing_card.dart';

class Game {
  final List<Player> _players;
  final Deck deck = Deck();
  late final GameHistory gameHistory;
  late final Suit suitOfBriscola;
  late final RoundManager _roundManager;
  bool _isFinished = false;
  bool _isFirstRound = true;

  Game({required List<Player> players}) : _players = players {
    suitOfBriscola = deck.peekLastCard.suit;
    gameHistory = GameHistory(
        lastCard: deck.peekLastCard, numberOfPlayers: players.length);
    _subscribeBotsToHistory();
    _roundManager = RoundManager(game: this);
  }

  void _subscribeBotsToHistory() {
    for (Player player in players) {
      if (player.isBot) {
        player.subscribePlayerToGameHistory(gameHistory);
      }
    }
  }

  List<Player> get players => List.unmodifiable(_players);

  RoundManager get roundManager => _roundManager;

  Future<void> startGame() async {
    while (!_players.first.isHandEmpty || _isFirstRound) {
      await _roundManager.startRound();
      _isFirstRound = false;
    }
    _isFinished = true;
  }

  bool get isFinished => _isFinished;
}
