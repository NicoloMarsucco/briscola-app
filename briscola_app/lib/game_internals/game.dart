import 'package:briscola_app/game_internals/deck.dart';
import 'package:briscola_app/game_internals/game_history.dart';
import 'package:briscola_app/game_internals/round_manager.dart';
import 'player.dart';
import 'playing_card.dart';

class Game {
  final List<Player> _players;
  final Deck deck = Deck();
  late final GameHistory gameHistory;
  late Suit _suitOfBriscola;
  late final RoundManager _roundManager;
  bool _isFirstRound = true;

  Game({required List<Player> players}) : _players = players {
    _getSuitOfBriscola();
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

  void _getSuitOfBriscola() {
    _suitOfBriscola = deck.peekLastCard.suit;
  }

  List<Player> get players => List.unmodifiable(_players);

  RoundManager get roundManager => _roundManager;

  Suit get suitOfBriscola => _suitOfBriscola;

  Future<void> startGame() async {
    while (!_players.first.isHandEmpty || _isFirstRound) {
      await _roundManager.startRound();
      _isFirstRound = false;
    }
    _roundManager.playScreenController
        .showEndOfGameWindow(_players.last.points);
  }

  // API to start a new game
  void startNewGame() {
    deck.prepareDeck();
    _getSuitOfBriscola();
    _isFirstRound = true;
    gameHistory.reset(deck.peekLastCard);
    _roundManager.prepareForNewGame();
    startGame();
  }
}
