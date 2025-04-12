import 'package:briscola_app/game_internals/player.dart';
import 'package:briscola_app/game_internals/playing_card.dart';
import 'package:flutter/foundation.dart';
import 'package:test/test.dart';

import '../../mocks/fake_player.dart';

void main() {
  group("Player", () {
    final String name = "Bob";
    final cardOne = PlayingCard(rank: 1, suit: Suit.bastoni);
    final cardTwo = PlayingCard(rank: 2, suit: Suit.bastoni);
    final cardThree = PlayingCard(rank: 3, suit: Suit.bastoni);
    late Player fakePlayer;

    setUp(() {
      fakePlayer = FakePlayer(name: name);
    });

    group("Player is initialized correctly", () {
      test("Name is initilized correctly", () {
        expect(fakePlayer.name, name);
      });

      test("Player hand is initially empty", () {
        expect(fakePlayer.isHandEmpty, isTrue);
      });

      test("Player hand should initially only contain null", () {
        final hand = fakePlayer.hand;
        final List<PlayingCard?> expected = [null, null, null];
        expect(listEquals(hand, expected), isTrue);
      });
    });

    test("Adding card to hand works properly", () {
      fakePlayer.addCardToHand(cardOne);
      fakePlayer.addCardToHand(cardTwo);
      final List<PlayingCard?> expected = [cardOne, cardTwo, null];
      expect(listEquals(fakePlayer.hand, expected), isTrue);
    });

    test("Removing card from hand functions properly", () {
      fakePlayer.addCardToHand(cardOne);
      fakePlayer.addCardToHand(cardTwo);
      fakePlayer.addCardToHand(cardThree);
      fakePlayer.removeCardFromHand(cardTwo);
      final List<PlayingCard?> expected = [cardOne, null, cardThree];
      expect(fakePlayer, equals(expected));
    });

    group("Card collection functions properly", () {
      setUp(() {
        fakePlayer.collectPlayedCards([cardOne, cardTwo]);
      });

      test("Points are added correctly", () {
        expect(fakePlayer.points, 11);
      });

      test("Cards collected are stored proerly", () {
        final cardsCollected = fakePlayer.cardsWon;
        expect(cardsCollected, equals([cardOne, cardTwo]));
      });
    });

    group("CompareTo method works correctly", () {
      late FakePlayer other;

      setUp(() {
        other = FakePlayer(name: "Alice");
      });

      test("CompareTo works correctly if this player had more points", () {
        fakePlayer.collectPlayedCards([cardOne]);
        expect(fakePlayer.compareTo(other), greaterThan(0));
      });

      test(
          "CompareTo method wors correctly if playres have the same number of points",
          () {
        expect(fakePlayer.compareTo(other), 0);
      });

      test("CompareTo works correctly if other player has more points", () {
        other.collectPlayedCards([cardOne]);
        expect(fakePlayer.compareTo(other), lessThan(0));
      });
    });
  });
}
