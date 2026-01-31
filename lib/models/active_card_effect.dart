import 'gameCard.dart';

class ActiveCardEffect {
  final GameCard card;
  int remainingRounds;

  ActiveCardEffect({required this.card, required this.remainingRounds});

  void decrement() {
    remainingRounds--;
  }

  bool get isExpired => remainingRounds <= 0;
}
