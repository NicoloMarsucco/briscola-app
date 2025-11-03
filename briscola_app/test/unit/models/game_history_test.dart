import 'package:briscola_app/game_internals/player.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:briscola_app/game_internals/game_history.dart';
import 'package:briscola_app/game_internals/playing_card.dart';

class FakePlayer extends Player {
  FakePlayer(String name) : super(name: name);
}

void main() {
  group('GameHistory', () {
    final lastCard = PlayingCard(rank: 1, suit: Suit.bastoni);
    final player = FakePlayer('Test Player');
    final card1 = PlayingCard(rank: 3, suit: Suit.denari);
    final card2 = PlayingCard(rank: 7, suit: Suit.spade);

    test('isNextMoveFirstRoundMove is true initially', () {
      final history = GameHistory(lastCard: lastCard);
      expect(history.isNextMoveFirstRoundMove, isTrue);
    });

    test('recordMove adds a move to the history', () {
      final history = GameHistory(lastCard: lastCard);
      history.recordMove(
        player: player,
        cards: [card1],
        moveType: MoveType.play,
      );

      expect(history.history.length, 1);
      expect(history.history.first.cards.first, card1);
      expect(history.history.first.player, player);
    });

    test('lastMove returns the most recent move', () {
      final history = GameHistory(lastCard: lastCard);

      final cards = [card1, card2];

      history.recordMove(
        player: player,
        cards: cards,
        moveType: MoveType.collect,
      );

      final last = history.lastMove;
      expect(last.cards, equals(cards));
      expect(last.moveType, MoveType.collect);
    });

    test('isNextMoveFirstRoundMove becomes true after collect move', () {
      final history = GameHistory(lastCard: lastCard);

      history.recordMove(
        player: player,
        cards: [card1],
        moveType: MoveType.play,
      );

      expect(history.isNextMoveFirstRoundMove, isFalse);

      history.recordMove(
        player: player,
        cards: [card2],
        moveType: MoveType.collect,
      );

      expect(history.isNextMoveFirstRoundMove, isTrue);
    });

    test('history returns an unmodifiable list', () {
      final history = GameHistory(lastCard: lastCard);
      history.recordMove(
        player: player,
        cards: [card1],
        moveType: MoveType.play,
      );

      final moves = history.history;
      expect(
          () => moves.add(
              Move(player: player, cards: [card2], moveType: MoveType.play)),
          throwsUnsupportedError);
    });

    test('notifies listeners on recordMove', () {
      final history = GameHistory(lastCard: lastCard);
      bool wasNotified = false;

      history.addListener(() {
        wasNotified = true;
      });

      history.recordMove(
        player: player,
        cards: [card1],
        moveType: MoveType.play,
      );

      expect(wasNotified, isTrue);
    });
  });
}
