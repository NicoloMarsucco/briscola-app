import 'package:briscola_app/game_internals/playing_card.dart';
import 'package:briscola_app/play_session/card_positions.dart';
import 'package:briscola_app/play_session/playing_card_widget.dart';
import 'package:flutter/material.dart';

class MovingCardWidget extends StatelessWidget {
  Position position;
  static const Curve curve = Curves.ease;
  static const Duration duration = Duration(milliseconds: 1200);
  final PlayingCard card;
  final bool isVisible;

  MovingCardWidget({
    required this.position,
    required this.card,
    this.isVisible = true,
    required Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      top: position.top,
      left: position.left,
      duration: duration,
      curve: curve,
      child: PlayingCardWidget(
        card: card,
        isCardVisible: true,
        isCardDraggable: false,
      ),
    );
  }
}
