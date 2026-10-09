class Place {
  final String id;
  final String userId;
  final String name;
  final String category;
  final String? description;
  final double latitude;
  final double longitude;
  final String? imageUrl;
  final DateTime createdAt;

  Place({
    required this.id,
    required this.userId,
    required this.name,
    required this.category,
    this.description,
    required this.latitude,
    required this.longitude,
    this.imageUrl,
    required this.createdAt,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      id: json['id'],
      userId: json['user_id'],
      name: json['name'],
      category: json['category'],
      description: json['description'],
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      imageUrl: json['image_url'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'name': name,
      'category': category,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'image_url': imageUrl,
    };
  }
}