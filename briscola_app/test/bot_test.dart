import 'package:briscola_app/models/bot.dart';
import 'package:briscola_app/models/card.dart';
import 'package:test/test.dart';

void main() {
  test('Bot should work correctly', () {
    var bot = Bot('bot');
    bot.addCardToHand(PlayingCard(rank: 1, suit: Suit.bastoni));
    bot.addCardToHand(PlayingCard(rank: 2, suit: Suit.bastoni));
    bot.addCardToHand(PlayingCard(rank: 3, suit: Suit.bastoni));
    var cardPlayed1 = bot.playCard();
    var cardPlayed2 = bot.playCard();
    var cardPlayed3 = bot.playCard();
    expect(bot.cardsInHand, 0);
  });
}
