// Phone Detective - Photo Model

class Photo {
  final String id;
  final String? title;
  final String? description;
  final DateTime dateTaken;
  final String? location;
  final double? latitude;
  final double? longitude;
  final List<PhotoHotspot> hotspots; // Clickable clue areas
  final bool isHidden;
  final String? albumId;

  const Photo({
    required this.id,
    this.title,
    this.description,
    required this.dateTaken,
    this.location,
    this.latitude,
    this.longitude,
    this.hotspots = const [],
    this.isHidden = false,
    this.albumId,
  });

  String get displayDate {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[dateTaken.month - 1]} ${dateTaken.day}, ${dateTaken.year}';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dateTaken': dateTaken.toIso8601String(),
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'hotspots': hotspots.map((h) => h.toJson()).toList(),
      'isHidden': isHidden,
      'albumId': albumId,
    };
  }

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      id: (json['id'] as String?) ?? 'unknown',
      title: json['title'] as String?,
      description: json['description'] as String?,
      dateTaken:
          DateTime.tryParse(json['dateTaken'] as String? ?? '') ??
          DateTime.now(),
      location: json['location'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      hotspots:
          (json['hotspots'] as List?)
              ?.map((h) => PhotoHotspot.fromJson(h as Map<String, dynamic>))
              .toList() ??
          [],
      isHidden: json['isHidden'] as bool? ?? false,
      albumId: json['albumId'] as String?,
    );
  }
}

class PhotoHotspot {
  final String id;
  final double x; // 0.0 to 1.0 relative position
  final double y;
  final double radius; // Tap area radius
  final String description; // What the player discovers

  const PhotoHotspot({
    required this.id,
    required this.x,
    required this.y,
    this.radius = 0.1,
    required this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'x': x,
      'y': y,
      'radius': radius,
      'description': description,
    };
  }

  factory PhotoHotspot.fromJson(Map<String, dynamic> json) {
    return PhotoHotspot(
      id: json['id'] as String,
      x: (json['x'] as num).toDouble(),
      y: (json['y'] as num).toDouble(),
      radius: (json['radius'] as num?)?.toDouble() ?? 0.1,
      description: json['description'] as String,
    );
  }
}
