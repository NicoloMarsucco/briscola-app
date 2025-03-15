import 'dart:async';

import 'package:async/async.dart';

import 'playing_card.dart';

class PlayingArea {

  /// The current cards in this area.
  final List<PlayingCard> cards = [];

  final StreamController<void> _playerChanges =
      StreamController<void>.broadcast();

  final StreamController<void> _remoteChanges =
      StreamController<void>.broadcast();

  PlayingArea();

  /// A [Stream] that fires an event every time any change to this area is made.
  Stream<void> get allChanges =>
      StreamGroup.mergeBroadcast([remoteChanges, playerChanges]);

  /// A [Stream] that fires an event every time a change is made _locally_,
  /// by the player.
  Stream<void> get playerChanges => _playerChanges.stream;

  /// A [Stream] that fires an event every time a change is made _remotely_,
  /// by another player.
  Stream<void> get remoteChanges => _remoteChanges.stream;

  /// Accepts the [card] into the area.
  void acceptCard(PlayingCard card) {
    cards.add(card);
    _playerChanges.add(null);
  }

  void dispose() {
    _remoteChanges.close();
    _playerChanges.close();
  }

  /// Removes the first card in the area, if any.
  void removeFirstCard() {
    if (cards.isEmpty) return;
    cards.removeAt(0);
    _playerChanges.add(null);
  }

}
