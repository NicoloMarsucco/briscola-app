import 'package:briscola_app/game_internals/card_strength_comparator.dart';
import 'package:briscola_app/game_internals/playing_card.dart';
import 'package:test/test.dart';

void main() {
  group("Card strength comparator works correctly", () {
    test(
        "When the table is empty, the first card played should be recognised as the strongest one",
        () {
      final result = CardStrengthComparator.isStronger(
          strongestCardOnTheTable: null,
          cardPlayed: PlayingCard(rank: 1, suit: Suit.bastoni),
          suitOfBriscola: Suit.denari);
      expect(result, isTrue);
    });

    test(
        "When a card of non-briscola is played after a card of briscola, the briscola should win",
        () {
      final briscolaSuit = Suit.denari;
      final result = CardStrengthComparator.isStronger(
          strongestCardOnTheTable: PlayingCard(rank: 2, suit: briscolaSuit),
          cardPlayed: PlayingCard(rank: 1, suit: Suit.bastoni),
          suitOfBriscola: briscolaSuit);
      expect(result, isFalse);
    });

    test(
        "When a card of briscola is played after a non-briscola, the briscola should win",
        () {
      final firstCard = PlayingCard(rank: 10, suit: Suit.bastoni);
      final secondCard = PlayingCard(rank: 2, suit: Suit.denari);
      final result = CardStrengthComparator.isStronger(
          strongestCardOnTheTable: firstCard,
          cardPlayed: secondCard,
          suitOfBriscola: Suit.denari);
      expect(result, isTrue);
    });

    test(
        "When two non-briscola cards are played, the first one should win in spite of the points",
        () {
      final firstCard = PlayingCard(rank: 2, suit: Suit.spade);
      final secondCard = PlayingCard(rank: 3, suit: Suit.denari);
      final result = CardStrengthComparator.isStronger(
          strongestCardOnTheTable: firstCard,
          cardPlayed: secondCard,
          suitOfBriscola: Suit.bastoni);
      expect(result, isFalse);
    });

    test(
        "When two non-briscola 0-points cards are played, the highest should win",
        () {
      final firstCard = PlayingCard(rank: 2, suit: Suit.spade);
      final secondCard = PlayingCard(rank: 4, suit: Suit.spade);
      final result = CardStrengthComparator.isStronger(
          strongestCardOnTheTable: firstCard,
          cardPlayed: secondCard,
          suitOfBriscola: Suit.bastoni);
      expect(result, isTrue);
    });

    test("When two briscola 0-points cards are played, the highest should win",
        () {
      final firstCard = PlayingCard(rank: 2, suit: Suit.spade);
      final secondCard = PlayingCard(rank: 4, suit: Suit.spade);
      final result = CardStrengthComparator.isStronger(
          strongestCardOnTheTable: firstCard,
          cardPlayed: secondCard,
          suitOfBriscola: Suit.spade);
      expect(result, isTrue);
    });
  });
}
