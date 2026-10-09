import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/place.dart';
import '../services/place_service.dart';
import 'place_form_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _service = PlaceService();
  final _mapController = MapController();
  
  List<Place> _places = [];
  LatLng? _currentLocation;
  String _selectedCategory = 'Todos';
  String _searchQuery = '';
  int _currentTab = 0; // 0 = Mapa, 1 = Lista
  bool _loading = true;

  final List<String> _categories = ['Todos', 'Comida', 'Estudio', 'Diversión', 'Deporte', 'Otro'];

  @override
  void initState() {
    super.initState();
    _initLocation();
    _fetchPlaces();
  }

  Future<void> _initLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }
    if (permission == LocationPermission.deniedForever) return;

    final position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
    });

    _mapController.move(_currentLocation!, 15.0);
  }

  Future<void> _fetchPlaces() async {
    setState(() => _loading = true);
    final places = await _service.getPlaces(
      query: _searchQuery,
      category: _selectedCategory,
    );
    setState(() {
      _places = places;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Lugares Favoritos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => Supabase.instance.client.auth.signOut(),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Buscar por nombre...',
                    prefixIcon: Icon(Icons.search),
                    isDense: true,
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (val) {
                    _searchQuery = val;
                    _fetchPlaces();
                  },
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                child: Row(
                  children: _categories.map((cat) {
                    final isSelected = _selectedCategory == cat;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: FilterChip(
                        label: Text(cat),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() => _selectedCategory = cat);
                          _fetchPlaces();
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator.adaptive())
          : _currentTab == 0
              ? _buildMapView()
              : _buildListView(),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentTab,
        onDestinationSelected: (idx) => setState(() => _currentTab = idx),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.map), label: 'Mapa'),
          NavigationDestination(icon: Icon(Icons.list), label: 'Lista'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final res = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PlaceFormScreen(initialLocation: _currentLocation),
            ),
          );
          if (res == true) _fetchPlaces();
        },
      ),
    );
  }

  Widget _buildMapView() {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: _currentLocation ?? const LatLng(19.4326, -99.1332),
        initialZoom: 13.0,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.ejemplo.mislugares',
        ),
        MarkerLayer(
          markers: [
            // Marcador de ubicación actual
            if (_currentLocation != null)
              Marker(
                point: _currentLocation!,
                width: 40,
                height: 40,
                child: const Icon(Icons.my_location, color: Colors.blue, size: 30),
              ),
            // Marcadores de lugares
            ..._places.map(
              (p) => Marker(
                point: LatLng(p.latitude, p.longitude),
                width: 45,
                height: 45,
                child: GestureDetector(
                  onTap: () => _showPlaceDetails(p),
                  child: const Icon(Icons.location_on, color: Colors.redAccent, size: 40),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildListView() {
    if (_places.isEmpty) {
      return const Center(child: Text('No hay lugares guardados con estos filtros.'));
    }
    return ListView.builder(
      itemCount: _places.length,
      itemBuilder: (context, index) {
        final place = _places[index];
        return ListTile(
          leading: place.imageUrl != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.network(place.imageUrl!, width: 50, height: 50, fit: BoxFit.cover),
                )
              : const Icon(Icons.place, size: 40),
          title: Text(place.name, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text('${place.category} • ${place.description ?? "Sin descripción"}'),
          trailing: PopupMenuButton(
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'edit', child: Text('Editar')),
              const PopupMenuItem(value: 'delete', child: Text('Eliminar')),
            ],
            onSelected: (val) async {
              if (val == 'edit') {
                final updated = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => PlaceFormScreen(placeToEdit: place)),
                );
                if (updated == true) _fetchPlaces();
              } else if (val == 'delete') {
                await _service.deletePlace(place.id, place.imageUrl);
                _fetchPlaces();
              }
            },
          ),
          onTap: () {
            setState(() => _currentTab = 0);
            _mapController.move(LatLng(place.latitude, place.longitude), 16.0);
          },
        );
      },
    );
  }

  void _showPlaceDetails(Place place) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (place.imageUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(place.imageUrl!, height: 160, width: double.infinity, fit: BoxFit.cover),
              ),
            const SizedBox(height: 12),
            Text(place.name, style: Theme.of(context).textTheme.titleLarge),
            Chip(label: Text(place.category)),
            if (place.description != null && place.description!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(place.description!),
            ],
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}