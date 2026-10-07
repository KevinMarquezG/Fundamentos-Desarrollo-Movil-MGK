class Cancion {
  final int id;
  final String titulo;
  final String artista;
  final String? album;
  final int? anio;
  final int? duracionSeg;
  final bool favorita;
  final DateTime createdAt;

  Cancion({
    required this.id,
    required this.titulo,
    required this.artista,
    this.album,
    this.anio,
    this.duracionSeg,
    required this.favorita,
    required this.createdAt,
  });

  factory Cancion.fromMap(Map<String, dynamic> map) {
    return Cancion(
      id: map['id'] as int,
      titulo: map['titulo'] as String? ?? 'Sin título',
      artista: map['artista'] as String? ?? 'Artista desconocido',
      album: map['album'] as String?,
      anio: map['anio'] as int?,
      duracionSeg: map['duracion_seg'] as int?,
      favorita: map['favorita'] as bool? ?? false,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  // Convierte segundos a formato legible mm:ss (ej. 354 -> 5:54)
  String get duracionFormateada {
    if (duracionSeg == null) return '--:--';
    final minutos = duracionSeg! ~/ 60;
    final segundos = duracionSeg! % 60;
    return '$minutos:${segundos.toString().padLeft(2, '0')}';
  }

  Cancion copyWith({bool? favorita}) {
    return Cancion(
      id: id,
      titulo: titulo,
      artista: artista,
      album: album,
      anio: anio,
      duracionSeg: duracionSeg,
      favorita: favorita ?? this.favorita,
      createdAt: createdAt,
    );
  }
}