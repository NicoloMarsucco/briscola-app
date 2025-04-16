import 'package:briscola_app/game_internals/playing_card.dart';
import 'package:briscola_app/game_internals/deck.dart';
import 'package:test/test.dart';

void main() {
  group("Deck", () {
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

    test("Deck should contain 40 unique cards", () {
      final Set<PlayingCard> set = {};
      final deck = Deck();
      while (deck.cardsLeft > 0) {
        final card = deck.drawTopCard();
        final wasAdded = set.add(card);
        expect(wasAdded, isTrue, reason: 'Duplicate card found: $card');
      }
      expect(set.length, 40);
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

    group('Prepare deck method works correctly when called for a new game', () {
      late Deck deck;
      setUp(() {
        deck = Deck();
      });

      test('New deck should contain 40 cards', () {
        deck.prepareDeck();
        expect(deck.cardsLeft, 40);
      });

      test("Order of cards of the new deck should be different", () {
        final List<PlayingCard> cardsFirstDeck = [];
        final List<PlayingCard> cardsSecondDeck = [];
        while (deck.cardsLeft > 0) {
          cardsFirstDeck.add(deck.drawTopCard());
        }
        deck.prepareDeck();
        while (deck.cardsLeft > 0) {
          cardsSecondDeck.add(deck.drawTopCard());
        }
        expect(cardsFirstDeck, isNot(equals(cardsSecondDeck)));
      });
    });
  });
}
