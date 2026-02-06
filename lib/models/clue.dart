// Phone Detective - Clue Model

class Clue {
  final String id;
  final ClueType type;
  final String sourceId; // ID of the message, photo, note, etc.
  final String preview; // Short preview text or description
  final DateTime foundAt;
  final String? playerNote;

  const Clue({
    required this.id,
    required this.type,
    required this.sourceId,
    required this.preview,
    required this.foundAt,
    this.playerNote,
  });

  Clue copyWith({
    String? id,
    ClueType? type,
    String? sourceId,
    String? preview,
    DateTime? foundAt,
    String? playerNote,
  }) {
    return Clue(
      id: id ?? this.id,
      type: type ?? this.type,
      sourceId: sourceId ?? this.sourceId,
      preview: preview ?? this.preview,
      foundAt: foundAt ?? this.foundAt,
      playerNote: playerNote ?? this.playerNote,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'sourceId': sourceId,
      'preview': preview,
      'foundAt': foundAt.toIso8601String(),
      'playerNote': playerNote,
    };
  }

  factory Clue.fromJson(Map<String, dynamic> json) {
    return Clue(
      id: json['id'] as String,
      type: ClueType.values.firstWhere((e) => e.name == json['type']),
      sourceId: json['sourceId'] as String,
      preview: json['preview'] as String,
      foundAt: DateTime.parse(json['foundAt'] as String),
      playerNote: json['playerNote'] as String?,
    );
  }
}

enum ClueType { message, photo, note, email, call, contact }

extension ClueTypeExtension on ClueType {
  String get icon {
    switch (this) {
      case ClueType.message:
        return '💬';
      case ClueType.photo:
        return '🖼️';
      case ClueType.note:
        return '📝';
      case ClueType.email:
        return '📧';
      case ClueType.call:
        return '📞';
      case ClueType.contact:
        return '👤';
    }
  }

  String get label {
    switch (this) {
      case ClueType.message:
        return 'Message';
      case ClueType.photo:
        return 'Photo';
      case ClueType.note:
        return 'Note';
      case ClueType.email:
        return 'Email';
      case ClueType.call:
        return 'Call';
      case ClueType.contact:
        return 'Contact';
    }
  }
}
