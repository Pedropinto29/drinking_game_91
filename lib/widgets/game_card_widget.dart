import 'package:flutter/material.dart';
import '../models/gameCard.dart';

class GameCardWidget extends StatelessWidget {
  final GameCard card;

  const GameCardWidget({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              card.title,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            Text(
              card.description,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18),
            ),

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
          ],
        ),
      ),
    );
  }
}
