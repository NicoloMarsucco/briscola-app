import 'package:briscola_app/play_session/card_positions_controller.dart';
import 'package:briscola_app/play_session/playing_card_widget.dart';
import 'package:flutter/widgets.dart';

import '../game_internals/player.dart';

/// The coordinates of the positions of the cards.
///
/// Used for the locations of the cards in [PlaySessionScreen].
class CardPositions {
  /// The datastructure to keep track of the coordinates.
  final _cardLocations = <BoardLocations, List<Position>>{};

  /// The distance from the top and bottom sides of the screen.
  ///
  /// In practice this is the vertical distance bewteen the top hand
  /// and the top of the screen, as well as the vertical distance
  /// between the hand at the bottom of the screen and the bottom of the
  /// screen.
  ///
  /// Determined at runtime as it is different for small and large screens.
  late final double _verticalPadding;

  /// The distance between the deck and the left side of the screen.
  static const double _horizontalPaddingDeck = 30;

  /// Distance between the cards on the table and the right side of the screen.
  static const double _horizontalPaddingCardsOnTheTable = 50;

  /// The distance between the cards in each hand.
  ///
  /// Refer to [_calculateHorizontalPositioning] to see how this parameter
  /// affects the distance of the cards from the left and right sides of the
  /// screen.
  ///
  /// Calculated at runtime since it changes for small and big screens.
  late final double _horizontalPaddingHand;

  /// The vertical distance between the cards on the table
  static const double _verticalOffsetCardsOnTheTable = 30;

  /// A flag of whether the positions have already been calculated.
  bool _isInitialized = false;

  /// Initializes a new instance of [CardPositions].
  ///
  /// Firstly, it initializes the padding values. Then, it fills
  /// [_cardLocations] with all the positions.
  CardPositions();

  /// Initializes all the values coordinates.
  ///
  /// This, however, only occurs if the values have not been intialized yet.
  void initialize(BuildContext context) {
    if (!_isInitialized) {
      final width = MediaQuery.of(context).size.width;
      final height = MediaQuery.of(context).size.height;
      _initializePaddings(width, height);
      _addDeckPosition(width, height);
      _addTablePosition(width, height);
      _addNorthAndSouthHands(width, height);
      _addNorthSouthPiles(width, height);
      _isInitialized = true;
    }
  }

  /// Initializes the paddings determined at runtime.
  void _initializePaddings(double width, double height) {
    _verticalPadding = height < 660 ? 30 : 60;
    _horizontalPaddingHand = width < 320 ? 30 : 60;
  }

  /// Calculates the coordinates of the deck.
  void _addDeckPosition(double width, double height) {
    final verticalDistance = (height - PlayingCardWidget.height) / 2;
    _cardLocations[BoardLocations.deck] = [
      Position(left: _horizontalPaddingDeck, top: verticalDistance)
    ];
  }

  /// Calculates the coordinates of the cards on the table.
  void _addTablePosition(double width, double height) {
    final horizontalDistance =
        width - _horizontalPaddingCardsOnTheTable - PlayingCardWidget.width;
    final middle = height / 2;
    _cardLocations[BoardLocations.table] = [
      Position(
          left: horizontalDistance,
          top: middle -
              _verticalOffsetCardsOnTheTable / 2 -
              PlayingCardWidget.height),
      Position(
          left: horizontalDistance,
          top: middle + _verticalOffsetCardsOnTheTable / 2)
    ];
  }

  /// Calculates the coordinates of the cards in each hand.
  void _addNorthAndSouthHands(double width, double height) {
    final horizontalPositions = _calculateHorizontalPositioning(width, height);
    final List<Position> northPlayerPositions = [];
    final List<Position> southPlayerPositions = [];
    for (int i = 0; i < Player.maxCardsInHand; i++) {
      northPlayerPositions
          .add(Position(left: horizontalPositions[i], top: _verticalPadding));
      southPlayerPositions.add(Position(
          left: horizontalPositions[i],
          top: height - _verticalPadding - PlayingCardWidget.height));
    }
    _cardLocations[BoardLocations.northPlayerHand] = northPlayerPositions;
    _cardLocations[BoardLocations.southPlayerHand] = southPlayerPositions;
  }

  /// Calculates the coordinates of the piles where the cards will be collected.
  void _addNorthSouthPiles(double width, double height) {
    _cardLocations[BoardLocations.northPlayerPile] = [
      Position(left: width, top: _verticalPadding)
    ];
    _cardLocations[BoardLocations.southPlayerPile] = [
      Position(
          left: width,
          top: height - _verticalPadding - PlayingCardWidget.height)
    ];
  }

  /// Calculates the horizontal coordinates of the cards in each hand.
  ///
  /// Note that these are the same for both the cards of the player and the
  /// cards of the bot.
  List<double> _calculateHorizontalPositioning(double width, double height) {
    final double spacePerCard =
        (width - 2 * _horizontalPaddingHand - PlayingCardWidget.width) /
            (Player.maxCardsInHand - 1);
    return List.generate(Player.maxCardsInHand,
        (int index) => _horizontalPaddingHand + spacePerCard * index,
        growable: false);
  }

  /// The coordinates for a given position.
  Position getPosition(BoardLocations currentLocation, [int index = 0]) {
    return _cardLocations[currentLocation]?[index] ?? Position.zero;
  }

  /// Overloaded [getPosition] for convenience purposes.
  Position transformPositionKey(PositionKey key) {
    return getPosition(key.boardLocation, key.index);
  }
}

/// The coordinates of the cards.
///
/// A utility function to record the position on the screen.
///
/// To be used in conjunction with [CardPositions].
class Position {
  /// The distance from the left side of the screen.
  final double left;

  /// The distance from the top of the screen.
  final double top;

  /// Coordinates of the top left corner of the screen.
  static const Position zero = Position(left: 0, top: 0);

  /// Initializes a new instance of [Position].ß
  const Position({required this.left, required this.top});
}

/// The positions on the board.
enum BoardLocations {
  deck,
  table,
  northPlayerHand,
  southPlayerHand,
  northPlayerPile,
  southPlayerPile
}
