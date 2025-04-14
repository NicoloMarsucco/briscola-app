import 'package:flutter/material.dart';
import 'package:flutter_flip_card/flutter_flip_card.dart';

import '../game_internals/playing_card.dart';

class PlayingCardWidget extends StatelessWidget {
  static const double width = 81;
  static const double height = 129;
  static const double borderRadius = 7;
  static const String pathToBackCardImage = "assets/cards/card-back.jpg";
  final CardType cardType;

  //Shadows
  static const Color _shadowColor = Colors.black26;
  static const double _blurRadius = 4;
  static const Offset _shadowOffset = Offset(2, 2);

  //Rotation
  final FlipCardController? controller;
  static const Duration _rotationDuration = Duration(milliseconds: 300);

  final PlayingCard? card;

  PlayingCardWidget(
      {required this.card,
      required this.cardType,
      this.controller,
      super.key}) {
    if (cardType == CardType.player) {
      assert(controller != null);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (card == null) {
      return SizedBox(
        height: height,
        width: width,
      );
    }

    switch (cardType) {
      case CardType.deck:
        return _getFrontOrBackCards(false);
      case CardType.briscola:
        return _getFrontOrBackCards(true);
      default:
        return _getFlippableCard();
    }
  }

  Widget _getFlippableCard() {
    return FlipCard(
      onTapFlipping: false,
      frontWidget: _getFrontOrBackCards(false),
      backWidget: _getFrontOrBackCards(true),
      controller: controller!,
      rotateSide: RotateSide.right,
      animationDuration: _rotationDuration,
    );
  }

  Widget _getFrontOrBackCards(bool isFront) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: _shadowColor,
            blurRadius: _blurRadius,
            offset: _shadowOffset,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Center(
          child: Image.asset(
            isFront ? card!.imagePath : pathToBackCardImage,
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}

enum CardType { briscola, deck, player }

@immutable
class PlayingCardDragData {
  final PlayingCard card;

  const PlayingCardDragData(this.card);
}
