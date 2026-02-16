import 'dart:math';

import 'package:drinking_game_91/game/game_content.dart';
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
  String? _gameResult;
  GameCard? _currentDrawnCard;

  void _onButtonPressed() {
    if (isGameOver) {
      Navigator.pop(context);
      return;
    }

    setState(() {
      _gameResult = null;

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

  void _showDrawnCards() async {
    if (gameState.discarded.length <= 1) return;

    final selectedCard = await showDialog<GameCard>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select a card to return to the deck'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: gameState.discarded.length - 1,
              itemBuilder: (context, index) {
                final card = gameState.discarded[index];

                return ListTile(
                  title: Text(card.title),
                  subtitle: Text(card.description),
                  onTap: () {
                    Navigator.pop(context, card);
                  },
                );
              },
            ),
          ),
        );
      },
    );

    if (selectedCard != null) {
      gameState.returnCardToDeck(selectedCard);
    }
  }

  void _handleNumberSubmitted(int number) {
    if (!hasDrawnCard) return;

    final currentCard = gameState.discarded.last;

    if (currentCard.title == 'GAME') {
      _gameResult = GameContent.games[number];
    } else if (currentCard.title == 'CHALLENGE') {
      _gameResult = GameContent.challenges[number];
    }

    setState(() {});
  }

  void _drawCardFromDeck(int index) {
    if (isGameOver) return;

    setState(() {
      _currentDrawnCard = gameState.deck.removeAt(index);
      gameState.discarded.add(_currentDrawnCard!);
      _gameResult = null;
    });
  }

  Widget buildCircularDeck(List<GameCard> deck, double size) {
    final double radius = size * 0.35;
    final center = Offset(size / 2, size / 2);

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          for (int i = 0; i < deck.length; i++)
            Positioned(
              left: center.dx + radius * cos(2 * pi * i / deck.length) - 30,
              top: center.dy + radius * sin(2 * pi * i / deck.length) - 40,
              child: GestureDetector(
                onTap: () {
                  _drawCardFromDeck(i);
                },
                child: Card(
                  elevation: 4,
                  color: Colors.blueGrey,
                  child: SizedBox(
                    width: 60,
                    height: 80,
                    child: Center(
                      child: Icon(
                        Icons.help_outline,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
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

              buildCircularDeck(
                gameState.deck,
                min(size.width, size.height) * 0.9,
              ),

              if (_currentDrawnCard != null)
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withOpacity(0.4),
                    child: Center(
                      child: GameCardWidget(
                        key: ValueKey(_currentDrawnCard!.id),
                        card: _currentDrawnCard!,
                        onSpecialAction: _showDrawnCards,
                        onNumberSubmitted: _handleNumberSubmitted,
                        resultText: _gameResult,
                      ),
                    ),
                  ),
                ),

              // AnimatedSwitcher(
              //   duration: const Duration(milliseconds: 500),
              //   switchInCurve: Curves.easeOut,
              //   layoutBuilder: (currentChild, previousChildren) {
              //     return Stack(
              //       alignment: Alignment.center,
              //       children: [
              //         ...previousChildren,
              //         if (currentChild != null) currentChild,
              //       ],
              //     );
              //   },
              //   transitionBuilder: (child, animation) {
              //     final offsetAnimation = Tween<Offset>(
              //       begin: const Offset(1, 0),
              //       end: Offset.zero,
              //     ).animate(animation);

              //     return SlideTransition(
              //       position: offsetAnimation,
              //       child: child,
              //     );
              //   },
              //   child: hasDrawnCard
              //       ? GameCardWidget(
              //           key: ValueKey(gameState.discarded.last.id),
              //           card: gameState.discarded.last,
              //           onSpecialAction: _showDrawnCards,
              //           onNumberSubmitted: _handleNumberSubmitted,
              //           resultText: _gameResult,
              //         )
              //       : const SizedBox.shrink(),
              // ),
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
