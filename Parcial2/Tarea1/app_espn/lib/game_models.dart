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
      id: json['id'] ?? '',
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
      score: json['score'] ?? '0',
      record: recordSummary,
    );
  }
}