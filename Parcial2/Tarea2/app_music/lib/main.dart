import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'cancion_model.dart';
import 'canciones_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Reemplaza con tus credenciales de Supabase
  await Supabase.initialize(
    url: 'https://ozyweptoihsrbrtnykbw.supabase.co',
    publishableKey: 'sb_publishable_ncw8tvSMk1jBtEX-K2Y8Ew_9Bxwd_bC',
  );

  runApp(const MusicApp());
}

class MusicApp extends StatelessWidget {
  const MusicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Biblioteca Musical',
      theme: ThemeData(
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.deepPurpleAccent,
        useMaterial3: true,
      ),
      home: const BibliotecaScreen(),
    );
  }
}

class BibliotecaScreen extends StatefulWidget {
  const BibliotecaScreen({super.key});

  @override
  State<BibliotecaScreen> createState() => _BibliotecaScreenState();
}

class _BibliotecaScreenState extends State<BibliotecaScreen> {
  final CancionesService _service = CancionesService();
  List<Cancion> _canciones = [];
  bool _cargando = true;
  bool _verSoloFavoritas = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _cargarCanciones();
  }

  Future<void> _cargarCanciones() async {
    setState(() {
      _cargando = true;
      _error = null;
    });

    try {
      final items = await _service.getCanciones(soloFavoritas: _verSoloFavoritas);
      setState(() {
        _canciones = items;
        _cargando = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _cargando = false;
      });
    }
  }

  Future<void> _toggleFavorita(Cancion cancion, int index) async {
    final nuevoEstado = !cancion.favorita;

    // Actualización optimista en la UI
    setState(() {
      _canciones[index] = cancion.copyWith(favorita: nuevoEstado);
      if (_verSoloFavoritas && !nuevoEstado) {
        _canciones.removeAt(index);
      }
    });

    try {
      await _service.toggleFavorita(cancion.id, cancion.favorita);
    } catch (e) {
      // Revertir si la petición falla
      _cargarCanciones();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al actualizar: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Canciones'),
        actions: [
          FilterChip(
            label: const Text('Favoritas'),
            selected: _verSoloFavoritas,
            avatar: Icon(
              _verSoloFavoritas ? Icons.favorite : Icons.favorite_border,
              size: 16,
              color: _verSoloFavoritas ? Colors.redAccent : Colors.grey,
            ),
            onSelected: (bool selected) {
              setState(() {
                _verSoloFavoritas = selected;
              });
              _cargarCanciones();
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Recargar',
            onPressed: _cargarCanciones,
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_cargando) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.redAccent),
              const SizedBox(height: 12),
              Text('Error al cargar datos:\n$_error', textAlign: TextAlign.center),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _cargarCanciones,
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    if (_canciones.isEmpty) {
      return const Center(
        child: Text('No hay canciones registradas.'),
      );
    }

    return RefreshIndicator(
      onRefresh: _cargarCanciones,
      child: ListView.separated(
        itemCount: _canciones.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final c = _canciones[index];
          final subtitulo = [
            c.artista,
            if (c.album != null) c.album,
            if (c.anio != null) '(${c.anio})',
          ].join(' • ');

          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              child: const Icon(Icons.music_note, color: Colors.white70),
            ),
            title: Text(
              c.titulo,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              subtitulo,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  c.duracionFormateada,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                IconButton(
                  icon: Icon(
                    c.favorita ? Icons.favorite : Icons.favorite_border,
                    color: c.favorita ? Colors.redAccent : Colors.grey,
                  ),
                  onPressed: () => _toggleFavorita(c, index),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}