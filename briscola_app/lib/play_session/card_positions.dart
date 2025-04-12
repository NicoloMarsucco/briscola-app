// A simple class to track the positions of where a card will go

import 'package:briscola_app/play_session/card_positions_controller.dart';
import 'package:briscola_app/play_session/playing_card_widget.dart';
import 'package:flutter/widgets.dart';

import '../game_internals/player.dart';

class CardPositions {
  final _cardLocations = <BoardLocations, List<Position>>{};
  static const double verticalPadding = 40;
  static const double horizontalPaddingDeck = 20;
  static const double horizontalPaddingHand = 80;
  static const double verticalOffsetCardsOnTheTable = 20;
  static const Position _defaultPosition = Position(left: 0, top: 0);

  CardPositions();

  void initialize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    _initializePositions(width, height);
  }

  void _initializePositions(double width, double height) {
    _addDeckPosition(width, height);
    _addTablePosition(width, height);
    _addNorthAndSouthHands(width, height);
    _addNorthSouthPiles(width, height);
  }

  void _addDeckPosition(double width, double height) {
    final verticalDistance = (height - PlayingCardWidget.height) / 2;
    _cardLocations[BoardLocations.deck] = [
      Position(left: horizontalPaddingDeck, top: verticalDistance)
    ];
  }

  void _addTablePosition(double width, double height) {
    final horizontalDistance =
        width - horizontalPaddingDeck - PlayingCardWidget.width;
    final middle = height / 2;
    _cardLocations[BoardLocations.table] = [
      Position(
          left: horizontalDistance,
          top: middle -
              verticalOffsetCardsOnTheTable / 2 -
              PlayingCardWidget.height),
      Position(
          left: horizontalDistance,
          top: middle + verticalOffsetCardsOnTheTable / 2)
    ];
  }

  void _addNorthAndSouthHands(double width, double height) {
    final horizontalPositions = _calculateHorizontalPositioning(width, height);
    final List<Position> northPlayerPositions = [];
    final List<Position> southPlayerPositions = [];
    for (int i = 0; i < Player.maxCardsInHand; i++) {
      northPlayerPositions
          .add(Position(left: horizontalPositions[i], top: verticalPadding));
      southPlayerPositions.add(Position(
          left: horizontalPositions[i],
          top: height - verticalPadding - PlayingCardWidget.height));
    }
    _cardLocations[BoardLocations.northPlayerHand] = northPlayerPositions;
    _cardLocations[BoardLocations.southPlayerHand] = southPlayerPositions;
  }

  void _addNorthSouthPiles(double width, double height) {
    _cardLocations[BoardLocations.northPlayerPile] = [
      Position(left: width, top: verticalPadding)
    ];
    _cardLocations[BoardLocations.southPlayerPile] = [
      Position(
          left: width, top: height - verticalPadding - PlayingCardWidget.height)
    ];
  }

  List<double> _calculateHorizontalPositioning(double width, double height) {
    final List<double> positions = [];
    final double spacePerCard =
        (width - 2 * horizontalPaddingHand - PlayingCardWidget.width) /
            (Player.maxCardsInHand - 1);
    for (int i = 0; i < Player.maxCardsInHand; i++) {
      positions.add(horizontalPaddingHand + spacePerCard * i);
    }
    return positions;
  }

  Position getPosition(BoardLocations currentLocation, [int index = 0]) {
    return _cardLocations[currentLocation]?[index] ?? _defaultPosition;
  }

  Position transformPositionKey(PositionKey key) {
    return _cardLocations[key.boardLocation]?[key.index] ?? _defaultPosition;
  }
}

class Position {
  final double left;
  final double top;

  const Position({required this.left, required this.top});

  @override
  String toString() {
    return "top: $top - left: $left";
  }
}

enum BoardLocations {
  deck,
  table,
  northPlayerHand,
  southPlayerHand,
  northPlayerPile,
  southPlayerPile
}
