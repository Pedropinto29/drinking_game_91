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
  }

  bool get hasDrawnCard => gameState.discarded.isNotEmpty;
  bool get isGameOver => gameState.isDeckEmpty;

  void _onButtonPressed() {
    if (isGameOver) {
      Navigator.pop(context);
      return;
    }

    setState(() {
      if (!hasDrawnCard) {
        gameState.drawRandomCard();
      } else {
        gameState.nextTurnAndDraw();
      }
    });
  }

  String get mainButtonText {
    if (isGameOver) return 'Back to Player Setup';
    if (!hasDrawnCard) return 'Draw Card';
    return 'Next Turn';
  }

  @override
  Widget build(BuildContext context) {
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

              if (gameState.currentPlayer.activeEffects.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: gameState.currentPlayer.activeEffects.map((
                      effect,
                    ) {
                      return Text(
                        '${effect.card.title} : ${effect.remainingRounds} round${effect.remainingRounds > 1 ? 's' : ''} left',
                        style: const TextStyle(
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                          color: Colors.grey,
                        ),
                      );
                    }).toList(),
                  ),
                ),

              AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                switchInCurve: Curves.easeOut,
                layoutBuilder: (currentChild, previousChildren) {
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      ...previousChildren,
                      if (currentChild != null) currentChild,
                    ],
                  );
                },
                transitionBuilder: (child, animation) {
                  final offsetAnimation = Tween<Offset>(
                    begin: const Offset(1, 0),
                    end: Offset.zero,
                  ).animate(animation);

                  return SlideTransition(
                    position: offsetAnimation,
                    child: child,
                  );
                },
                child: hasDrawnCard
                    ? GameCardWidget(
                        key: ValueKey(gameState.discarded.last.id),
                        card: gameState.discarded.last,
                      )
                    : const SizedBox.shrink(),
              ),

              if (isGameOver)
                const Text(
                  'Game Over \n All cards have been played',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _onButtonPressed,
                  child: Text(mainButtonText),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
