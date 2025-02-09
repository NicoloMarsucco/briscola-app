enum Suit { bastoni, coppe, denari, spade }

class Card {
  final int rank;
  final Suit suit;
  final int points;
  final String imagePath;

  Card({required this.rank, required this.suit})
      : imagePath = 'assets/images/cards/$rank-${suit.name}.png',
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
        return rank;
    }
  }

  @override
  String toString() {
    return '$rank of ${suit.name}';
  }
}
