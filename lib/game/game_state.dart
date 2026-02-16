import '../models/player.dart';
import '../models/gameCard.dart';
import '../models/active_card_effect.dart';

class GameState {
  final List<Player> players;
  final List<GameCard> deck;
  final List<GameCard> discarded = [];

  int currentPlayerIndex = 0;

  GameState({required this.players, required this.deck});

  Player get currentPlayer => players[currentPlayerIndex];
  bool get isDeckEmpty => deck.isEmpty;

  void nextTurn() {
    final effects = currentPlayer.activeEffects;

    for (final effect in effects) {
      effect.decrement();
    }

    effects.removeWhere((effect) => effect.isExpired);
    currentPlayerIndex = (currentPlayerIndex + 1) % players.length;
  }

  GameCard drawRandomCard() {
    if (deck.isEmpty) throw Exception('Deck is Empty');
    deck.shuffle();
    final card = deck.removeLast();
    discarded.add(card);

    if (card.rounds != null) {
      currentPlayer.activeEffects.add(
        ActiveCardEffect(card: card, remainingRounds: card.rounds!),
      );
    }
    return card;
  }

  void returnCardToDeck(GameCard card) {
    discarded.remove(card);
    deck.add(card);
    deck.shuffle();
  }

  void _handleNumberSubmitted(int number) {}

  GameCard nextTurnAndDraw() {
    nextTurn();
    return drawRandomCard();
  }
}
