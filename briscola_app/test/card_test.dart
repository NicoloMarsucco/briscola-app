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
}
