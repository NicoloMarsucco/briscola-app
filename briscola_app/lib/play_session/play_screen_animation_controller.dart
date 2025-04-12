import 'dart:async';

import 'package:briscola_app/game_internals/playing_card.dart';
import 'package:flutter/material.dart';

import '../game_internals/player.dart';

class PlayScreenAnimationController extends ChangeNotifier {
  // Paramaters for animation logic
  int _numberOfCardsToDistribute = 0;
  List<Player> _orderedListOfPlayers = [];
  PlayingCard _cardPlayedByBot = PlayingCard.dummyCard;
  bool _isWinnerPlayerBot = true;
  List<PlayingCard> _cardsToCollect = [];
  final PlayingCard briscola;
  bool _showDeck = true;

  // Completers to tell the backend when the animations are done
  Completer<void> _distributionCompleter = Completer<void>();
  Completer<void> _botPlayCompleter = Completer<void>();
  Completer<PlayingCard> _userPlayCompleter = Completer<PlayingCard>();
  Completer<void> _cardsCollectionCompleter = Completer<void>();

  PlayScreenAnimationController({required this.briscola}) {
    _distributionCompleter.complete();
    _botPlayCompleter.complete();
    _userPlayCompleter.complete(PlayingCard.dummyCard);
    cardsCollectionCompleter.complete();
  }

  // API to call the distribution of cards from the backend
  // completes when the last animation finishes
  Future<void> distributeCards(
      int numberOfCardsToDistribute, List<Player> orderedPlayers) async {
    if (_distributionCompleter.isCompleted) {
      _distributionCompleter = Completer<void>();
    }
    _orderedListOfPlayers = orderedPlayers;
    _numberOfCardsToDistribute = numberOfCardsToDistribute;
    notifyListeners();
    await _distributionCompleter.future;
  }

  // API to tell the UI to play the bot card
  Future<void> moveBotCardToTable(PlayingCard cardPlayed) async {
    if (_botPlayCompleter.isCompleted) {
      _botPlayCompleter = Completer<void>();
    }
    _cardPlayedByBot = cardPlayed;
    notifyListeners();
    await _botPlayCompleter.future;
  }

  // API to wait for the user input
  Future<PlayingCard> makeUserChooseCard() async {
    if (_userPlayCompleter.isCompleted) {
      _userPlayCompleter = Completer<PlayingCard>();
    }
    notifyListeners();
    PlayingCard cardPlayed = await _userPlayCompleter.future;
    return cardPlayed;
  }

  // API to collect cards
  Future<void> collectCards(
      List<PlayingCard> cardsToCollect, bool isWinnerPlayerBot) async {
    if (_cardsCollectionCompleter.isCompleted) {
      _cardsCollectionCompleter = Completer<void>();
    }
    _cardsToCollect = cardsToCollect;
    _isWinnerPlayerBot = isWinnerPlayerBot;
    notifyListeners();
    await _cardsCollectionCompleter.future;
  }

  //API to hide deck
  void hideDeck() {
    _showDeck = false;
  }

  // Getters for the distribution of cards
  bool get shouldDistribute => !_distributionCompleter.isCompleted;
  bool get shouldPlayBotCard => !_botPlayCompleter.isCompleted;
  bool get shouldUserChooseCard => !_userPlayCompleter.isCompleted;
  bool get shouldCollectCards => !_cardsCollectionCompleter.isCompleted;
  bool get showDeck => _showDeck;

  int get numberOfCardsToDistribute => _numberOfCardsToDistribute;
  List<Player> get orderedPlayers => _orderedListOfPlayers;
  PlayingCard get cardPlayedByBot => _cardPlayedByBot;
  bool get isWinnerPlayerBot => _isWinnerPlayerBot;
  List<PlayingCard> get cardsToCollect => _cardsToCollect;

  Completer<void> get distributionCompleter => _distributionCompleter;
  Completer<void> get botPlayCompleter => _botPlayCompleter;
  Completer<PlayingCard> get userPlayCompleter => _userPlayCompleter;
  Completer<void> get cardsCollectionCompleter => _cardsCollectionCompleter;
}
