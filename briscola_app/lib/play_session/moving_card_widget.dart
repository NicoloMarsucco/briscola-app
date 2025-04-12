import 'dart:async';

import 'package:briscola_app/game_internals/playing_card.dart';
import 'package:briscola_app/play_session/card_positions.dart';
import 'package:briscola_app/play_session/playing_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flip_card/flutter_flip_card.dart';

class MovingCardWidget extends StatelessWidget {
  Position position;
  static const Curve curve = Curves.ease;
  static const Duration duration = Duration(milliseconds: 600);
  final PlayingCard card;
  final FlipCardController controller;
  final VoidCallback? onTap;
  Completer<void>? onMoveComplete;

  MovingCardWidget({
    required this.position,
    required this.card,
    required this.controller,
    required Key key,
    this.onMoveComplete,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      onEnd: () {
        if (onMoveComplete != null && !onMoveComplete!.isCompleted) {
          onMoveComplete!.complete();
        }
      },
      top: position.top,
      left: position.left,
      duration: duration,
      curve: curve,
      child: GestureDetector(
        onTap: onTap,
        child: PlayingCardWidget(
          card: card,
          cardType: CardType.player,
          controller: controller,
        ),
      ),
    );
  }
}
