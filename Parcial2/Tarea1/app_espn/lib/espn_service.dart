import 'dart:convert';
import 'package:http/http.dart' as http;
import 'game_models.dart';

class EspnService {
  static const String _endpoint =
      'https://site.api.espn.com/apis/site/v2/sports/football/nfl/scoreboard';

  Future<List<Game>> fetchNflGames() async {
    final response = await http.get(Uri.parse(_endpoint));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final events = data['events'] as List? ?? [];
      return events.map((e) => Game.fromJson(e)).toList();
    } else {
      throw Exception('Error al consultar marcadores: ${response.statusCode}');
    }
  }
}