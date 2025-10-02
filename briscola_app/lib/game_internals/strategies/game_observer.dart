import 'dart:collection';

import 'package:briscola_app/game_internals/game_history.dart';
import 'package:briscola_app/game_internals/playing_card.dart';

import '../deck.dart';

/// Tracks a [GameHistory] object to see which cards have not been played
/// yet.
class GameObserver {
  /// The game history being tracked.
  final GameHistory _gameHistory;

  /// The cards which have yet to be played.
  final Set<PlayingCard> _cardsUnplayed =
      HashSet.of(Deck.generateFullDeck(shuffle: false));

  /// Creates a new instance of [GameObserver] that listens to updates
  /// in the game recorded by [_gameHistory].
  ///
  /// Automatically subscribes to [_gameHistory] changes and reacts
  /// when the game state is updated.
  GameObserver(this._gameHistory) {
    _gameHistory.addListener(_onHistoryUpdated);
  }

  /// The method called when the tracked [_gameHistory] notifies its
  /// listeners.
  ///
  /// Removes from [_cardsUnplayed] the cards which have just been played.
  /// The collection of cards is ignored since collecting cards does not
  /// decrease the set of unplayed cards.
  void _onHistoryUpdated() {
    if (_gameHistory.lastMove.moveType == MoveType.play) {
      _cardsUnplayed.removeAll(_gameHistory.lastMove.cards);
    }
  }

  ///
  Set<PlayingCard> snapshotOpponentCardPossibilities(List<PlayingCard> hand) {
    assert(_cardsUnplayed.containsAll(hand));
    _cardsUnplayed.removeAll(hand);
    try {
      return Set.unmodifiable(_cardsUnplayed);
    } finally {
      _cardsUnplayed.addAll(hand);
    }
  }

  void dispose() {
    _gameHistory.removeListener(_onHistoryUpdated);
  }
}
