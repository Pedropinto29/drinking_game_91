import 'package:flutter/material.dart';
import '../models/gameCard.dart';

class GameCardWidget extends StatelessWidget {
  final GameCard card;
  final VoidCallback? onSpecialAction;
  final ValueChanged<int>? onNumberSubmitted;
  final String? resultText;

  const GameCardWidget({
    super.key,
    required this.card,
    this.onSpecialAction,
    this.onNumberSubmitted,
    this.resultText,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final cardWidth = size.width * 0.85;
    final cardHeight = size.height * 0.55;

    return SizedBox(
      width: cardWidth,
      height: cardHeight,
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                card.title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              Flexible(
                child: SingleChildScrollView(
                  child: Text(
                    card.description,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),

              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (card.multiRound && card.rounds != null) ...[
                        const SizedBox(height: 12),
                        Text(
                          'Effect lasts ${card.rounds} rounds',
                          style: const TextStyle(
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                            color: Colors.grey,
                          ),
                        ),
                      ],

                      if (card.title == '91' && onSpecialAction != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: ElevatedButton(
                            onPressed: onSpecialAction,
                            child: const Text(
                              'Choose card to go back into the game',
                            ),
                          ),
                        ),

                      if (card.title == "GAME" || card.title == "CHALLENGE")
                        Column(
                          children: [
                            // const SizedBox(height: 12),
                            TextField(
                              keyboardType: TextInputType.number,
                              onSubmitted: (value) {
                                final number = int.tryParse(value);
                                if (number != null &&
                                    number >= 1 &&
                                    number <= 20) {
                                  onNumberSubmitted?.call(number);
                                }
                              },
                              decoration: const InputDecoration(
                                labelText: "Enter a number (1-20)",
                                border: OutlineInputBorder(),
                              ),
                            ),

                            if (resultText != null) ...[
                              const SizedBox(height: 20),
                              Text(
                                resultText!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
