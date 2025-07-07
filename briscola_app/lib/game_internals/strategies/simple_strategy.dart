import 'package:briscola_app/game_internals/card_strength_comparator.dart';
import 'package:briscola_app/game_internals/playing_card.dart';
import 'package:briscola_app/game_internals/strategies/bot_strategy.dart';
import 'package:briscola_app/utils/bot_strategy_utils.dart';

/// Plays a simple bot strategy.
///
/// The strategy is:
/// - If it is the first player:
///   - Play the lowest non-briscola card (preferably worthless).
///   - If no non-briscola cards, play the lowest briscola.
/// - Otherwise (second player):
///   - If the opponent played a low card:
///     - If you can beat it cheaply, do so.
///     - Else discard the lowest card.
///   - If the opponent played a high card:
///     - If you can win, do so.
///     - Else discard the lowest card.
///
/// Only works for 2 player games.
class SimpleStrategy extends BotStrategy {
  @override
  Future<PlayingCard> chooseCardToPlay(List<PlayingCard?> hand) async {
    final briscolaSuit = gameHistory!.lastCard.suit;
    final cardsAvailable = getAvailableCards(hand);

    final briscolas = cardsAvailable.where((card) => card.suit == briscolaSuit);
    final nonBriscolas =
        cardsAvailable.where((card) => card.suit != briscolaSuit);
    final worthlessNonBriscolas =
        nonBriscolas.where((card) => card.points == 0);

    if (isFirstPlayer(gameHistory!.history)) {
      // First player strategy
      if (worthlessNonBriscolas.isNotEmpty) {
        return findLowest(worthlessNonBriscolas);
      }
      if (nonBriscolas.isNotEmpty) {
        return findLowest(nonBriscolas);
      }
      // Only briscola left
      return findLowest(briscolas);
    } else {
      // Second player strategy
      final opponentCard = gameHistory!.history.last.cards.first;

      // Find cards that can beat opponent's card
      final beatingCards = cardsAvailable.where((card) =>
          CardStrengthComparator.isStronger(
              strongestCardOnTheTable: opponentCard,
              cardPlayed: card,
              suitOfBriscola: briscolaSuit));

      if (opponentCard.points <= 4) {
        // Opponent played a low card
        if (beatingCards.isNotEmpty) {
          // Play the cheapest winning card
          return findLowest(beatingCards);
        }
        // Can't beat or don't want to: discard the lowest card
        return findLowest(cardsAvailable);
      } else {
        // Opponent played a high card
        if (beatingCards.isNotEmpty) {
          // Try to win
          return findLowest(beatingCards);
        }
        // Can't beat: discard the lowest card
        return findLowest(cardsAvailable);
      }
    }
  }
}
