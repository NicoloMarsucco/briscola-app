// Class to record the history of the game
import 'package:briscola_app/game_internals/player.dart';
import 'package:briscola_app/game_internals/playing_card.dart';
import 'package:flutter/material.dart';

/// Tracks the history of the game.
class GameHistory extends ChangeNotifier {
  /// The list of moves which have taken place in the game.
  final List<Move> _moves = [];

  /// The card at the bottom of the deck (i.e. the card which determines the
  /// suit of briscola).
  final PlayingCard lastCard;

  /// Creates a new [GameHistory] instance with the given [lastCard]
  /// (i.e. the card which determines the suit of briscola).
  GameHistory({required this.lastCard});

  /// Records a move (see [MoveType] for all the move types available),
  /// as well as the list of [cards] involved.
  ///
  /// Notifies listeners that the game state has changed.
  void recordMove(
      {required Player player,
      required List<PlayingCard> cards,
      required MoveType moveType}) {
    _moves.add(Move(player: player, cards: cards, moveType: moveType));
    notifyListeners();
  }

  /// Returns `true` if the next move will be the first of the round,
  /// `false` otherwise.
  bool get isNextMoveFirstRoundMove {
    return _moves.isEmpty || (_moves.last.moveType == MoveType.collect);
  }

  /// Returns the last move recorded in the game.
  Move get lastMove => _moves.last;

  /// Returns an unmodifiable list of all moves recorded in the game.
  List<Move> get history => List.unmodifiable(_moves);
}

/// Represents a move by a player.
@immutable
class Move {
  final Player player;
  final List<PlayingCard> cards;
  final MoveType moveType;

  const Move(
      {required this.player, required this.cards, required this.moveType});

  @override
  String toString() {
    if (moveType == MoveType.play) {
      return "${player.name} played ${cards.first}";
    } else {
      return "${player.name} collected $cards";
    }
  }
}

enum MoveType { play, collect }
