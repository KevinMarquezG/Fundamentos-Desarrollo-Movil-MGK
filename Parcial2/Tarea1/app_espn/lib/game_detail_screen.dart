import 'package:flutter/material.dart';
import 'espn_service.dart';
import 'game_models.dart';

class GameDetailScreen extends StatefulWidget {
  final Game game;

  const GameDetailScreen({super.key, required this.game});

  @override
  State<GameDetailScreen> createState() => _GameDetailScreenState();
}

class _GameDetailScreenState extends State<GameDetailScreen> {
  final EspnService _service = EspnService();
  late Future<List<Play>> _playsFuture;

  @override
  void initState() {
    super.initState();
    _playsFuture = _service.fetchPlayByPlay(widget.game.id);
  }

  @override
  Widget build(BuildContext context) {
    final g = widget.game;

    return Scaffold(
      appBar: AppBar(
        title: Text('${g.awayTeam.abbreviation} @ ${g.homeTeam.abbreviation}'),
      ),
      body: Column(
        children: [
          // Marcador superior
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _MiniTeam(team: g.awayTeam),
                Column(
                  children: [
                    Text(
                      '${g.awayTeam.score} - ${g.homeTeam.score}',
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      g.statusDetail,
                      style: TextStyle(
                        fontSize: 12,
                        color: g.isCompleted ? Colors.grey : Colors.amber,
                      ),
                    ),
                  ],
                ),
                _MiniTeam(team: g.homeTeam),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Jugadas (Play-by-Play)',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          // Lista de jugadas
          Expanded(
            child: FutureBuilder<List<Play>>(
              future: _playsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final plays = snapshot.data ?? [];
                if (plays.isEmpty) {
                  return const Center(child: Text('Sin jugadas registradas aún.'));
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(12),
                  itemCount: plays.length,
                  separatorBuilder: (_, __) => const Divider(height: 12),
                  itemBuilder: (context, index) {
                    final play = plays[index];
                    return ListTile(
                      dense: true,
                      leading: CircleAvatar(
                        radius: 18,
                        backgroundColor: play.isScoringPlay
                            ? Colors.green.withAlpha(50)
                            : Colors.grey.withAlpha(40),
                        child: Text(
                          'Q${play.period}',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: play.isScoringPlay ? Colors.greenAccent : null,
                          ),
                        ),
                      ),
                      title: Text(
                        play.text,
                        style: TextStyle(
                          fontWeight: play.isScoringPlay
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                      subtitle: Text(
                        '${play.clock} • ${play.typeText}',
                        style: const TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniTeam extends StatelessWidget {
  final TeamCompetitor team;
  const _MiniTeam({required this.team});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (team.logoUrl.isNotEmpty)
          Image.network(team.logoUrl, width: 36, height: 36)
        else
          const Icon(Icons.sports_football, size: 36),
        const SizedBox(height: 4),
        Text(team.abbreviation, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}