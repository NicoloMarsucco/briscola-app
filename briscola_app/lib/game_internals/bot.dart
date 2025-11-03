import 'package:briscola_app/game_internals/player.dart';
import 'package:briscola_app/game_internals/strategies/bot_strategy.dart';

class Bot extends Player {
  Bot({required super.name, required Difficulty difficulty})
      : super(botStrategy: BotStrategy.fromLevel(difficulty));
}
