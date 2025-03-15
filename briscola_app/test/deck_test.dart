import 'package:briscola_app/game_internals/playing_card.dart';
import 'package:briscola_app/game_internals/deck.dart';
import 'package:test/test.dart';

void main() {
  test('Deck is initialized correctly with 40 cards', () {
    var deck = Deck();
    expect(deck.cardsLeft, 40);
  });

  group('Peeking the last card functions correctly', () {
    test('Peeking method returns a card', () {
      var deck = Deck();
      expect(deck.peekLastCard, isA<PlayingCard>());
    });

    test('Peeking a card does not modify deck length', () {
      var deck = Deck();
      deck.peekLastCard;
      expect(deck.cardsLeft, 40);
    });
  });

  group('Draw card method works correctly', () {
    test('Drawing a card should return a card', () {
      var deck = Deck();
      expect(deck.drawTopCard(), isA<PlayingCard>());
    });

    test('Should be possible to draw 40 cards', () {
      var deck = Deck();
      for (int i = 0; i < 40; i++) {
        deck.drawTopCard();
      }
      expect(deck.cardsLeft, 0);
    });
  });
}
