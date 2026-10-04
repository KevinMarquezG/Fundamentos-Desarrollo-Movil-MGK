import 'package:flutter/material.dart';
import 'espn_service.dart';
import 'game_models.dart';
import 'game_detail_screen.dart';

void main() {
  runApp(const NflScoresApp());
}

class NflScoresApp extends StatelessWidget {
  const NflScoresApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NFL Scoreboard',
      theme: ThemeData(
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.blueAccent,
        useMaterial3: true,
      ),
      home: const ScoreboardScreen(),
    );
  }
}

class ScoreboardScreen extends StatefulWidget {
  const ScoreboardScreen({super.key});

  @override
  State<ScoreboardScreen> createState() => _ScoreboardScreenState();
}

class _ScoreboardScreenState extends State<ScoreboardScreen> {
  final EspnService _service = EspnService();
  late Future<List<Game>> _gamesFuture;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _fetchGames();
  }

  void _fetchGames() {
    setState(() {
      _gamesFuture = _service.fetchNflGames(date: _selectedDate);
    });
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      _fetchGames();
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateLabel =
        '${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}';

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('NFL Scoreboard', style: TextStyle(fontSize: 18)),
            Text(dateLabel, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Cambiar Fecha',
            icon: const Icon(Icons.calendar_month),
            onPressed: _selectDate,
          ),
          IconButton(
            tooltip: 'Refrescar',
            icon: const Icon(Icons.refresh),
            onPressed: _fetchGames,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => _fetchGames(),
        child: FutureBuilder<List<Game>>(
          future: _gamesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('Error: ${snapshot.error}'),
                ),
              );
            }

            final games = snapshot.data ?? [];
            if (games.isEmpty) {
              return const Center(child: Text('No hay partidos para esta fecha.'));
            }

            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: games.length,
              itemBuilder: (context, index) {
                final game = games[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => GameDetailScreen(game: game),
                      ),
                    );
                  },
                  child: GameCard(game: game),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class GameCard extends StatelessWidget {
  final Game game;
  const GameCard({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  game.statusDetail,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: game.isCompleted ? Colors.grey : Colors.amberAccent,
                    fontSize: 12,
                  ),
                ),
                const Icon(Icons.chevron_right, size: 18, color: Colors.grey),
              ],
            ),
            const SizedBox(height: 12),
            _TeamRow(team: game.awayTeam),
            const Divider(height: 16),
            _TeamRow(team: game.homeTeam),
          ],
        ),
      ),
    );
  }
}

class _TeamRow extends StatelessWidget {
  final TeamCompetitor team;
  const _TeamRow({required this.team});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (team.logoUrl.isNotEmpty)
          Image.network(
            team.logoUrl,
            width: 32,
            height: 32,
            errorBuilder: (_, __, ___) => const Icon(Icons.sports_football, size: 32),
          )
        else
          const Icon(Icons.sports_football, size: 32),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                team.displayName,
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
              ),
              if (team.record != null)
                Text(
                  team.record!,
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
            ],
          ),
        ),
        Text(
          team.score,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}