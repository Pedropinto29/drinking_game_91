import 'package:drinking_game_91/game/game_state.dart';
import 'package:drinking_game_91/models/gameCard.dart';
import 'package:drinking_game_91/models/player.dart';
import 'package:drinking_game_91/widgets/game_card_widget.dart';
import 'package:flutter/material.dart';

class GameScreen extends StatefulWidget {
  final List<Player> players;
  final List<GameCard> deck;
  const GameScreen({super.key, required this.players, required this.deck});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late GameState gameState;

  void initState() {
    super.initState();
    gameState = GameState(players: widget.players, deck: widget.deck);

    if (gameState.deck.isNotEmpty) {
      gameState.discarded.add(gameState.deck[0]);
    }
  }

  void _drawCard() {
    setState(() {
      final card = gameState.drawRandomCard();
      print('Drawn card: ${card.title}');
    });
  }

  void _nextTurn() {
    setState(() {
      gameState.nextTurn();
      final card = gameState.drawRandomCard();
    });
  }

  @override
  Widget build(BuildContext context) {
    final hasCardOnScreen = gameState.discarded.isNotEmpty;

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 32),

              Text(
                'Current Player:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 16),

              Text(
                gameState.currentPlayer.name,
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),

              if (hasCardOnScreen)
                GameCardWidget(card: gameState.discarded.last),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: hasCardOnScreen ? _nextTurn : _drawCard,
                  child: Text(hasCardOnScreen ? "Next turn" : "Draw Card"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
