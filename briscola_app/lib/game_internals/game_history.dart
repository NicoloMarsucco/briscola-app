// Class to record the history of the game
import 'package:briscola_app/game_internals/player.dart';
import 'package:briscola_app/game_internals/playing_card.dart';
import 'package:flutter/material.dart';

/// Tracks the history of the game.
class GameHistory {
  final List<Move> _moves = [];
  final PlayingCard lastCard;
  final int numberOfPlayers;

  GameHistory({required this.lastCard, required this.numberOfPlayers});

  void recordMove(
      {required Player player,
      required List<PlayingCard> cards,
      required MoveType moveType}) {
    _moves.add(Move(player: player, cards: cards, moveType: moveType));
  }

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
