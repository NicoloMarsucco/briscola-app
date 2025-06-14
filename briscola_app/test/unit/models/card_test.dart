import 'package:briscola_app/game_internals/playing_card.dart';
import 'package:test/test.dart';

void main() {
  group("PlayingCard", () {
    group('Test card initializes correctly', () {
      test('PlayingCard initializes correctly for an ace of bastoni', () {
        var card = PlayingCard(rank: 1, suit: Suit.bastoni);
        expect(card.rank, 1);
        expect(card.suit, Suit.bastoni);
        expect(card.points, 11);
        expect(card.imagePath, 'assets/cards/1-bastoni.jpg');
      });

      test('PlayingCard initializes correctly for a king of spade', () {
        var card = PlayingCard(rank: 10, suit: Suit.spade);
        expect(card.rank, 10);
        expect(card.suit, Suit.spade);
        expect(card.points, 4);
        expect(card.imagePath, 'assets/cards/10-spade.jpg');
      });
    });

    test('PlayingCard toString method works correctly', () {
      var card = PlayingCard(rank: 2, suit: Suit.denari);
      expect(card.toString(), '2 of denari');
    });

    group('== operator works correctly', () {
      test('== should return true if two cards are the same', () {
        var card1 = PlayingCard(rank: 1, suit: Suit.coppe);
        var card2 = PlayingCard(rank: 1, suit: Suit.coppe);
        expect(card1 == card2, true);
      });

      test('== should return false if two cards are different', () {
        var card1 = PlayingCard(rank: 4, suit: Suit.coppe);
        var card2 = PlayingCard(rank: 4, suit: Suit.bastoni);
        expect(card1 == card2, false);
      });
    });

    test("Hashcode should not produce duplicates in a deck", () {
      var hashes = <int>{};
      for (int rank = 1; rank < 11; rank++) {
        for (Suit suit in Suit.values) {
          hashes.add(PlayingCard(rank: rank, suit: suit).hashCode);
        }
      }
      expect(hashes.length, 40);
    });
  });

  test("Dummy card getter should work as expected", () {
    var card = PlayingCard.dummyCard;
    expect(card.points, 0);
    expect(card.rank, 0);
    expect(card.suit, Suit.bastoni);
  });
}
