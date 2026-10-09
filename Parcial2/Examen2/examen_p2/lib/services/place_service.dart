import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/place.dart';

class PlaceService {
  final _client = Supabase.instance.client;

  // Obtener lugares del usuario con filtros opcionales
  Future<List<Place>> getPlaces({String? query, String? category}) async {
    var request = _client.from('places').select();

    if (query != null && query.trim().isNotEmpty) {
      request = request.ilike('name', '%${query.trim()}%');
    }
    if (category != null && category.isNotEmpty && category != 'Todos') {
      request = request.eq('category', category);
    }

    final response = await request.order('created_at', ascending: false);
    return (response as List).map((item) => Place.fromJson(item)).toList();
  }

  // Subir imagen a Supabase Storage con subcarpeta por user_id
  Future<String?> uploadImage(File file) async {
    final userId = _client.auth.currentUser!.id;
    final fileExt = file.path.split('.').last;
    final fileName = '${DateTime.now().millisecondsSinceEpoch}.$fileExt';
    final fullPath = '$userId/$fileName';

    await _client.storage.from('place-images').upload(
          fullPath,
          file,
          fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
        );

    return _client.storage.from('place-images').getPublicUrl(fullPath);
  }

  // Crear lugar
  Future<void> createPlace({
    required String name,
    required String category,
    String? description,
    required double latitude,
    required double longitude,
    File? imageFile,
  }) async {
    String? imageUrl;
    if (imageFile != null) {
      imageUrl = await uploadImage(imageFile);
    }

    await _client.from('places').insert({
      'user_id': _client.auth.currentUser!.id,
      'name': name,
      'category': category,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'image_url': imageUrl,
    });
  }

  // Actualizar lugar existente
  Future<void> updatePlace({
    required String id,
    required String name,
    required String category,
    String? description,
    required double latitude,
    required double longitude,
    File? newImageFile,
    String? existingImageUrl,
  }) async {
    String? imageUrl = existingImageUrl;
    if (newImageFile != null) {
      imageUrl = await uploadImage(newImageFile);
    }

    await _client.from('places').update({
      'name': name,
      'category': category,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'image_url': imageUrl,
    }).eq('id', id);
  }

  // Eliminar lugar y su imagen
  Future<void> deletePlace(String id, String? imageUrl) async {
    await _client.from('places').delete().eq('id', id);

    if (imageUrl != null) {
      final uri = Uri.parse(imageUrl);
      final pathSegments = uri.pathSegments;
      final bucketIndex = pathSegments.indexOf('place-images');
      if (bucketIndex != -1 && bucketIndex < pathSegments.length - 1) {
        final filePath = pathSegments.sublist(bucketIndex + 1).join('/');
        await _client.storage.from('place-images').remove([filePath]);
      }
    }
  }
}