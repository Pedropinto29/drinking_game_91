enum CardType { simple, choice, reinsert }

class GameCard {
  final int id;
  final String title;
  final String description;
  final CardType type;
  final bool multiRound;
  final int? rounds;

  GameCard({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    this.multiRound = false,
    this.rounds,
  });
}
