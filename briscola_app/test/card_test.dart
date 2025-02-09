import 'package:briscola_app/models/card.dart';
import 'package:test/test.dart';

void main() {
  group('Test card initializes correctly', () {
    test('Card initializes correctly for an ace of bastoni', () {
      var card = Card(rank: 1, suit: Suit.bastoni);
      expect(card.rank, 1);
      expect(card.suit, Suit.bastoni);
      expect(card.points, 11);
      expect(card.imagePath, 'assets/images/cards/1-bastoni.png');
    });

    test('Card initializes correctly for a king of spade', () {
      var card = Card(rank: 10, suit: Suit.spade);
      expect(card.rank, 10);
      expect(card.suit, Suit.spade);
      expect(card.points, 4);
      expect(card.imagePath, 'assets/images/cards/10-spade.png');
    });
  });

  test('Card toString method works correctly', () {
    var card = Card(rank: 2, suit: Suit.denari);
    expect(card.toString(), '2 of denari');
  });

  group('== operator works correctly', () {
    test('== should return true if two cards are the same', () {
      var card1 = Card(rank: 1, suit: Suit.coppe);
      var card2 = Card(rank: 1, suit: Suit.coppe);
      expect(card1 == card2, true);
    });

    test('== should return false if two cards are different', () {
      var card1 = Card(rank: 4, suit: Suit.coppe);
      var card2 = Card(rank: 4, suit: Suit.bastoni);
      expect(card1 == card2, false);
    });
  });

  test("Hashcode should not produce duplicated in a deck", () {
    var hashes = <int>{};
    for (int rank = 1; rank < 11; rank++) {
      for (Suit suit in Suit.values) {
        hashes.add(Card(rank: rank, suit: suit).hashCode);
      }
    }
    expect(hashes.length, 40);
  });
}
