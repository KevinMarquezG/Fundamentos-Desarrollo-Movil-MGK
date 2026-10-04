class Game {
  final String id;
  final String name;
  final String shortName;
  final String statusDetail;
  final bool isCompleted;
  final TeamCompetitor homeTeam;
  final TeamCompetitor awayTeam;

  Game({
    required this.id,
    required this.name,
    required this.shortName,
    required this.statusDetail,
    required this.isCompleted,
    required this.homeTeam,
    required this.awayTeam,
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    final competition = (json['competitions'] as List).first;
    final competitors = competition['competitors'] as List;

    final homeJson = competitors.firstWhere(
      (c) => c['homeAway'] == 'home',
      orElse: () => competitors.first,
    );
    final awayJson = competitors.firstWhere(
      (c) => c['homeAway'] == 'away',
      orElse: () => competitors.last,
    );

    final status = json['status']?['type'] ?? {};

    return Game(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      shortName: json['shortName'] ?? '',
      statusDetail: status['detail'] ?? 'Programado',
      isCompleted: status['completed'] ?? false,
      homeTeam: TeamCompetitor.fromJson(homeJson),
      awayTeam: TeamCompetitor.fromJson(awayJson),
    );
  }
}

class TeamCompetitor {
  final String id;
  final String name;
  final String abbreviation;
  final String displayName;
  final String logoUrl;
  final String score;
  final String? record;

  TeamCompetitor({
    required this.id,
    required this.name,
    required this.abbreviation,
    required this.displayName,
    required this.logoUrl,
    required this.score,
    this.record,
  });

  factory TeamCompetitor.fromJson(Map<String, dynamic> json) {
    final team = json['team'] ?? {};
    final records = json['records'] as List?;
    final recordSummary = records != null && records.isNotEmpty
        ? records.first['summary'] as String?
        : null;

    return TeamCompetitor(
      id: team['id']?.toString() ?? '',
      name: team['name'] ?? '',
      abbreviation: team['abbreviation'] ?? '',
      displayName: team['displayName'] ?? '',
      logoUrl: team['logo'] ?? '',
      score: json['score']?.toString() ?? '0',
      record: recordSummary,
    );
  }
}

class Play {
  final String id;
  final String text;
  final String clock;
  final int period;
  final String typeText;
  final bool isScoringPlay;
  final String awayScore;
  final String homeScore;

  Play({
    required this.id,
    required this.text,
    required this.clock,
    required this.period,
    required this.typeText,
    required this.isScoringPlay,
    required this.awayScore,
    required this.homeScore,
  });

  factory Play.fromJson(Map<String, dynamic> json) {
    return Play(
      id: json['id']?.toString() ?? '',
      text: json['text'] ?? '',
      clock: json['clock']?['displayValue'] ?? '',
      period: json['period']?['number'] ?? 0,
      typeText: json['type']?['text'] ?? 'Jugada',
      isScoringPlay: json['scoringPlay'] ?? false,
      awayScore: json['awayScore']?.toString() ?? '0',
      homeScore: json['homeScore']?.toString() ?? '0',
    );
  }
}