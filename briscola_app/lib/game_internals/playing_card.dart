enum Suit { bastoni, coppe, denari, spade }

class PlayingCard {
  final int rank;
  final Suit suit;
  final int points;
  final String imagePath;
  static final dummyCard = PlayingCard(
      rank: 0,
      suit: Suit.bastoni); // A dummy card useful for initilaizing stuff

  PlayingCard({required this.rank, required this.suit})
      : imagePath = 'assets/cards/$rank-${suit.name}.jpg',
        points = _getPoints(rank);

  static int _getPoints(int rank) {
    switch (rank) {
      case 1:
        return 11;
      case 3:
        return 10;
      case 8:
        return 2;
      case 9:
        return 3;
      case 10:
        return 4;
      default:
        return 0;
    }
  }

  @override
  String toString() {
    return '$rank of ${suit.name}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    if (other is! PlayingCard) {
      return false;
    }

    PlayingCard otherCard = other;
    if (otherCard.rank == rank && otherCard.suit == suit) {
      return true;
    }

    return false;
  }

  @override
  int get hashCode {
    switch (suit) {
      case Suit.bastoni:
        return rank;
      case Suit.coppe:
        return 10 + rank;
      case Suit.denari:
        return 20 + rank;
      case Suit.spade:
        return 30 + rank;
    }
  }
}
