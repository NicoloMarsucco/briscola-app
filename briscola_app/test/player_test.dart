import 'package:briscola_app/models/card.dart';
import 'package:briscola_app/models/player.dart';
import 'package:test/test.dart';

class MockPlayer extends Player {
  MockPlayer() : super(name: "Mock Player");

  @override
  Future<Card> playCard() async {
    var card = await Future.delayed(
        const Duration(seconds: 2), () => Card(rank: 1, suit: Suit.bastoni));
    return card;
  }
}

void main() {
  test('Player should initialize correctly', () {
    var player = MockPlayer();
    expect(player.cardsInHand, 0);
    expect(player.points, 0);
    expect(player.name, "Mock Player");
  });

  test('Add cards to hand works properly', () {
    var player = MockPlayer();
    player.addCardToHand(Card(rank: 1, suit: Suit.bastoni));
    player.addCardToHand(Card(rank: 10, suit: Suit.coppe));
    expect(player.cardsInHand, 2);
    expect(player.points, 0);
  });

  test('Collect played cards should work properly', () {
    var player = MockPlayer();
    player.collectPlayedCards(
        [Card(rank: 1, suit: Suit.spade), Card(rank: 10, suit: Suit.spade)]);
    expect(player.points, 15);
  });

  group("compareTo method should be implemented correctly", () {
    late MockPlayer player1;
    late MockPlayer player2;

    setUp(() {
      player1 = MockPlayer();
      player2 = MockPlayer();
    });

    test('CompareTo method case: greater than', () {
      player1.collectPlayedCards([Card(rank: 1, suit: Suit.bastoni)]);
      player2.collectPlayedCards([Card(rank: 2, suit: Suit.bastoni)]);
      expect(player1.compareTo(player2), 1);
    });

    test('CompareTo method case: smaller than', () {
      player1.collectPlayedCards([Card(rank: 3, suit: Suit.bastoni)]);
      player2.collectPlayedCards([Card(rank: 1, suit: Suit.bastoni)]);
      expect(player1.compareTo(player2), -1);
    });

    test('CompareTo method case: equal', () {
      player1.collectPlayedCards([Card(rank: 3, suit: Suit.coppe)]);
      player2.collectPlayedCards([Card(rank: 3, suit: Suit.bastoni)]);
      expect(player1.compareTo(player2), 0);
    });
  });
}
