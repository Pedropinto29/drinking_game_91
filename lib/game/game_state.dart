import '../models/player.dart';
import '../models/gameCard.dart';

class GameState {
  final List<Player> players;
  final List<GameCard> deck;
  final List<GameCard> discarded = [];

  int currentPlayerIndex = 0;

  GameState({required this.players, required this.deck});

  Player get currentPlayer => players[currentPlayerIndex];

  void nextTurn() {
    currentPlayerIndex = (currentPlayerIndex + 1) % players.length;
  }

  GameCard drawRandomCard() {
    if (deck.isEmpty) throw Exception('Deck is Empty');
    deck.shuffle();

    final card = deck.removeAt(0);
    discarded.add(card);
    return card;
  }

  void printState() {
    print("Players: ");
    for (var player in players) {
      print(player.name);
    }

    print("Deck");
    for (var card in deck) {
      print(card.title);
    }
  }
}
