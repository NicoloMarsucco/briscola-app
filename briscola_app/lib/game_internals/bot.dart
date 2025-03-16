import 'package:briscola_app/game_internals/player.dart';
import 'package:briscola_app/game_internals/random_strategy.dart';

class Bot extends Player {
  Bot({required super.name}) : super(botStrategy: RandomStrategy());
}
