import 'package:drinking_game_91/models/gameCard.dart';
import 'package:flutter/material.dart';
import '../models/player.dart';
import 'game_screen.dart';
import '../game/deck.dart';

class PlayerSetupScreen extends StatefulWidget {
  const PlayerSetupScreen({super.key});

  @override
  State<PlayerSetupScreen> createState() => _PlayerSetupScreenState();
}

class _PlayerSetupScreenState extends State<PlayerSetupScreen> {
  final TextEditingController _playerNameController = TextEditingController();
  final List<Player> _players = [];

  void _addPlayer() {
    final name = _playerNameController.text.trim();

    if (name.isEmpty) return;

    setState(() {
      _players.add(Player(name));
      _playerNameController.clear();
    });
  }

  void _startGame() async {
    final deck = await loadDeck();
    final freshPlayers = _players.map((player) => Player(player.name)).toList();
    final freshDeck = List<GameCard>.from(deck);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => GameScreen(players: freshPlayers, deck: freshDeck),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),

            const Text(
              '91 Drinking Game',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 32),

            TextField(
              controller: _playerNameController,
              onSubmitted: (_) => _addPlayer(),
              decoration: InputDecoration(
                hintText: 'Enter player name',
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 20,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _addPlayer,
                ),
              ),
            ),

            const SizedBox(height: 24),

            //Player chips
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _players.map((player) {
                return Chip(
                  shape: const StadiumBorder(),
                  label: Text(player.name),
                  deleteIcon: const Icon(Icons.close),
                  onDeleted: () {
                    setState(() {
                      _players.remove(player);
                    });
                  },
                );
              }).toList(),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _players.length >= 2 ? _startGame : null,
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.resolveWith<Color?>((
                    states,
                  ) {
                    if (states.contains(WidgetState.disabled)) {
                      return Colors.grey.shade400;
                    }
                    return const Color(0xFF1877F2);
                  }),
                  padding: WidgetStateProperty.all(
                    const EdgeInsets.symmetric(vertical: 16),
                  ),
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
                child: const Text(
                  'Start Game',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
