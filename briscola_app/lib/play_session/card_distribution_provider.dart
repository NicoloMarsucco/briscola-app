import 'dart:async';

import 'package:flutter/material.dart';

class CardDistributionProvider extends ChangeNotifier {
  bool _shouldDistribute = false;
  Completer<void> completer = Completer<void>();
  int _cardsToDistribute = 0;

  bool get shouldDistribute => _shouldDistribute;
  int get cardsToDistribute => _cardsToDistribute;

  Future<void> distributeCards(int cardsToDistibute) async {
    completer = Completer<void>();
    _cardsToDistribute = cardsToDistibute;
    _shouldDistribute = true;
    notifyListeners();
    await completer.future;
  }

  void resetTrigger() {
    _shouldDistribute = false;
  }
}
