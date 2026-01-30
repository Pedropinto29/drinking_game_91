import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/gameCard.dart';

Future<List<GameCard>> loadDeck() async {
  try {
    final String jsonString = await rootBundle.loadString(
      'lib/game/cards.json',
    );
    final List<dynamic> jsonData = jsonDecode(jsonString);

    final List<GameCard> deck = [];
    int currentId = 0;

    for (var cardData in jsonData) {
      int quantity = cardData['quantity'] ?? 1;

      for (int i = 0; i < quantity; i++) {
        deck.add(
          GameCard(
            id: currentId++,
            title: cardData['title'],
            description: cardData['description'],
            type: CardType.values.firstWhere(
              (e) => e.toString().split('.').last == cardData['type'],
            ),
            multiRound: cardData['multiround'] ?? false,
            rounds: cardData['rounds'],
          ),
        );
      }
    }

    return deck;
  } catch (e) {
    print(e);
    return [];
  }
}
