import 'package:supabase_flutter/supabase_flutter.dart';
import 'cancion_model.dart';

class CancionesService {
  final SupabaseClient _client = Supabase.instance.client;

  // Obtener todas las canciones ordenadas por título
  Future<List<Cancion>> getCanciones({bool soloFavoritas = false}) async {
    var query = _client.from('canciones').select();

    if (soloFavoritas) {
      query = query.eq('favorita', true);
    }

    final response = await query.order('titulo', ascending: true);
    return (response as List).map((row) => Cancion.fromMap(row)).toList();
  }

  // Alternar estado de favorita
  Future<void> toggleFavorita(int id, bool estadoActual) async {
    await _client
        .from('canciones')
        .update({'favorita': !estadoActual})
        .eq('id', id);
  }
}