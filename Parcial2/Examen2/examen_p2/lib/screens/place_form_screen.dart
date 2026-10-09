import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import '../models/place.dart';
import '../services/place_service.dart';

class PlaceFormScreen extends StatefulWidget {
  final LatLng? initialLocation;
  final Place? placeToEdit;

  const PlaceFormScreen({super.key, this.initialLocation, this.placeToEdit});

  @override
  State<PlaceFormScreen> createState() => _PlaceFormScreenState();
}

class _PlaceFormScreenState extends State<PlaceFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _service = PlaceService();
  
  late TextEditingController _nameController;
  late TextEditingController _descController;
  late String _category;
  late LatLng _selectedPoint;
  File? _imageFile;
  bool _submitting = false;

  final List<String> _categories = ['Comida', 'Estudio', 'Diversión', 'Deporte', 'Otro'];

  @override
  void initState() {
    super.initState();
    final p = widget.placeToEdit;
    _nameController = TextEditingController(text: p?.name ?? '');
    _descController = TextEditingController(text: p?.description ?? '');
    _category = p?.category ?? _categories.first;
    _selectedPoint = p != null
        ? LatLng(p.latitude, p.longitude)
        : (widget.initialLocation ?? const LatLng(19.4326, -99.1332));
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 75);
    if (picked != null) {
      setState(() => _imageFile = File(picked.path));
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _submitting = true);

    try {
      if (widget.placeToEdit == null) {
        await _service.createPlace(
          name: _nameController.text.trim(),
          category: _category,
          description: _descController.text.trim(),
          latitude: _selectedPoint.latitude,
          longitude: _selectedPoint.longitude,
          imageFile: _imageFile,
        );
      } else {
        await _service.updatePlace(
          id: widget.placeToEdit!.id,
          name: _nameController.text.trim(),
          category: _category,
          description: _descController.text.trim(),
          latitude: _selectedPoint.latitude,
          longitude: _selectedPoint.longitude,
          newImageFile: _imageFile,
          existingImageUrl: widget.placeToEdit!.imageUrl,
        );
      }
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.placeToEdit != null;
    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Editar Lugar' : 'Nuevo Lugar')),
      body: _submitting
          ? const Center(child: CircularProgressIndicator.adaptive())
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Nombre *', border: OutlineInputBorder()),
                    validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _category,
                    decoration: const InputDecoration(labelText: 'Categoría', border: OutlineInputBorder()),
                    items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                    onChanged: (val) => setState(() => _category = val!),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _descController,
                    maxLines: 2,
                    decoration: const InputDecoration(labelText: 'Descripción', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 16),
                  // Selector de Foto
                  Row(
                    children: [
                      _imageFile != null
                          ? Image.file(_imageFile!, width: 70, height: 70, fit: BoxFit.cover)
                          : (widget.placeToEdit?.imageUrl != null
                              ? Image.network(widget.placeToEdit!.imageUrl!, width: 70, height: 70, fit: BoxFit.cover)
                              : Container(width: 70, height: 70, color: Colors.grey.shade200, child: const Icon(Icons.image))),
                      const SizedBox(width: 16),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.camera_alt),
                        label: const Text('Elegir Foto'),
                        onPressed: _pickImage,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text('Toca en el mapa para marcar el punto exacto:', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  // Mapa interactivo para marcar la coordenada
                  SizedBox(
                    height: 250,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: FlutterMap(
                        options: MapOptions(
                          initialCenter: _selectedPoint,
                          initialZoom: 14.0,
                          onTap: (_, latLng) => setState(() => _selectedPoint = latLng),
                        ),
                        children: [
                          TileLayer(
                            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            userAgentPackageName: 'com.ejemplo.mislugares',
                          ),
                          MarkerLayer(
                            markers: [
                              Marker(
                                point: _selectedPoint,
                                width: 40,
                                height: 40,
                                child: const Icon(Icons.location_on, color: Colors.red, size: 40),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _save,
                    style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),
                    child: Text(isEditing ? 'Actualizar Lugar' : 'Guardar Lugar'),
                  ),
                ],
              ),
            ),
    );
  }
}