import 'dart:convert';
import 'package:http/http.dart' as http;
import 'game_models.dart';

class EspnService {
  static const String _scoreboardBase =
      'https://site.api.espn.com/apis/site/v2/sports/football/nfl/scoreboard';
  static const String _summaryBase =
      'https://site.api.espn.com/apis/site/v2/sports/football/nfl/summary';

  // Consulta partidos filtrados por fecha
  Future<List<Game>> fetchNflGames({DateTime? date}) async {
    String url = _scoreboardBase;
    if (date != null) {
      final yyyy = date.year.toString().padLeft(4, '0');
      final mm = date.month.toString().padLeft(2, '0');
      final dd = date.day.toString().padLeft(2, '0');
      url = '$_scoreboardBase?dates=$yyyy$mm$dd';
    }

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final events = data['events'] as List? ?? [];
      return events.map((e) => Game.fromJson(e)).toList();
    } else {
      throw Exception('Error al consultar partidos: ${response.statusCode}');
    }
  }

  // Consulta el desglose de jugadas (Play-by-Play)
  Future<List<Play>> fetchPlayByPlay(String gameId) async {
    final response = await http.get(Uri.parse('$_summaryBase?event=$gameId'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final drives = data['drives']?['previous'] as List? ?? [];
      
      final List<Play> playsList = [];
      for (final drive in drives) {
        final plays = drive['plays'] as List? ?? [];
        for (final p in plays) {
          playsList.add(Play.fromJson(p));
        }
      }
      // Invertir para mostrar primero las jugadas más recientes
      return playsList.reversed.toList();
    } else {
      throw Exception('Error al cargar jugadas: ${response.statusCode}');
    }
  }
}