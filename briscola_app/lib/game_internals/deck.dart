import 'dart:collection';

import 'package:briscola_app/game_internals/playing_card.dart';

/// A deck of 40 Neapolitan cards.
class Deck {
  /// Queue storing the current deck of cards (top = first).
  final Queue<PlayingCard> _deck;

  /// Creates a [Deck] from a list of cards in the order provided.
  /// If [cardsToUse] is not provided, a full shuffled deck is generated.
  Deck({List<PlayingCard>? cardsToUse})
      : _deck = Queue.of(cardsToUse ?? generateFullDeck(shuffle: true));

  /// Generates a full 40-card Briscola deck.
  ///
  /// Each suit contains cards from rank 1 (Ace) to 10.
  /// Set [shuffle] to true to randomize the order (default: true).
  static List<PlayingCard> generateFullDeck({bool shuffle = true}) {
    final List<PlayingCard> listOfCards = [];
    for (Suit suit in Suit.values) {
      for (int rank = 1; rank <= 10; rank++) {
        listOfCards.add(PlayingCard(rank: rank, suit: suit));
      }
    }
    if (shuffle) {
      listOfCards.shuffle();
    }
    return listOfCards;
  }

  /// Draws and removes the top card from the deck.
  PlayingCard drawTopCard() => _deck.removeFirst();

  /// Returns the last card in the deck without removing it.
  PlayingCard get peekLastCard => _deck.last;

  /// Returns the number of cards left in the deck.
  int get cardsLeft => _deck.length;
}
