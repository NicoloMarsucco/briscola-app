import 'dart:async';

import 'package:briscola_app/game_internals/playing_card.dart';
import 'package:briscola_app/play_session/end_game_widget.dart';
import 'package:flutter/material.dart';

import '../game_internals/game.dart';
import '../game_internals/player.dart';

class PlayScreenAnimationController extends ChangeNotifier {
  // Paramaters for animation logic
  int _numberOfCardsToDistribute = 0;
  List<Player> _orderedListOfPlayers = [];
  PlayingCard _cardPlayedByBot = PlayingCard.dummyCard;
  bool _isWinnerPlayerBot = true;
  List<PlayingCard> _cardsToCollect = [];
  PlayingCard _briscola;
  bool _showDeck = true;
  bool _showEndOfGameWindow = false;
  int _points = 0;
  GameResult _result = GameResult.loss;
  final Game _game;

  // Completers to tell the backend when the animations are done
  Completer<void> _distributionCompleter = Completer<void>();
  Completer<void> _botPlayCompleter = Completer<void>();
  Completer<PlayingCard> _userPlayCompleter = Completer<PlayingCard>();
  Completer<void> _cardsCollectionCompleter = Completer<void>();

  PlayScreenAnimationController(
      {required PlayingCard briscola, required Game game})
      : _briscola = briscola,
        _game = game {
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

  // API to reveal the end of game window
  void showEndOfGameWindow(int points) {
    _points = points;
    _result = _determineResult(points);
    _showEndOfGameWindow = true;
    notifyListeners();
  }

  // API to tell model to start new game
  void startNewGame() {
    _game.startNewGame();
  }

  // API to prepare the controller for a new game (called from the model)
  void newGame(PlayingCard briscola) {
    _briscola = briscola;
    _showDeck = true;
    _showEndOfGameWindow = false;
    notifyListeners();
  }

  static GameResult _determineResult(int points) {
    if (points > 60) {
      return GameResult.win;
    } else if (points < 60) {
      return GameResult.loss;
    }
    return GameResult.draw;
  }

  // Getters for the distribution of cards
  bool get shouldDistribute => !_distributionCompleter.isCompleted;
  bool get shouldPlayBotCard => !_botPlayCompleter.isCompleted;
  bool get shouldUserChooseCard => !_userPlayCompleter.isCompleted;
  bool get shouldCollectCards => !_cardsCollectionCompleter.isCompleted;
  bool get showDeck => _showDeck;
  bool get shouldShowEndOfGameWindow => _showEndOfGameWindow;

  PlayingCard get briscola => _briscola;
  int get numberOfCardsToDistribute => _numberOfCardsToDistribute;
  List<Player> get orderedPlayers => _orderedListOfPlayers;
  PlayingCard get cardPlayedByBot => _cardPlayedByBot;
  bool get isWinnerPlayerBot => _isWinnerPlayerBot;
  List<PlayingCard> get cardsToCollect => _cardsToCollect;
  GameResult get result => _result;
  int get points => _points;

  Completer<void> get distributionCompleter => _distributionCompleter;
  Completer<void> get botPlayCompleter => _botPlayCompleter;
  Completer<PlayingCard> get userPlayCompleter => _userPlayCompleter;
  Completer<void> get cardsCollectionCompleter => _cardsCollectionCompleter;
}
