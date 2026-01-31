import 'package:drinking_game_91/models/active_card_effect.dart';

class Player {
  final String name;
  final List<ActiveCardEffect> activeEffects = [];

  Player(this.name);
}
