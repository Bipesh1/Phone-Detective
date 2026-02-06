// Phone Detective - Note Model

class Note {
  final String id;
  final String title;
  final String content;
  final DateTime createdAt;
  final DateTime? modifiedAt;
  final NoteColor color;
  final bool isLocked;
  final String? password; // If locked, password needed

  const Note({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    this.modifiedAt,
    this.color = NoteColor.yellow,
    this.isLocked = false,
    this.password,
  });

  String get preview {
    if (content.length <= 100) return content;
    return '${content.substring(0, 100)}...';
  }

  String get displayDate {
    final date = modifiedAt ?? createdAt;
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
    return '${months[date.month - 1]} ${date.day}';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'modifiedAt': modifiedAt?.toIso8601String(),
      'color': color.name,
      'isLocked': isLocked,
      'password': password,
    };
  }

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      modifiedAt: json['modifiedAt'] != null
          ? DateTime.parse(json['modifiedAt'] as String)
          : null,
      color: NoteColor.values.firstWhere(
        (e) => e.name == json['color'],
        orElse: () => NoteColor.yellow,
      ),
      isLocked: json['isLocked'] as bool? ?? false,
      password: json['password'] as String?,
    );
  }
}

enum NoteColor { yellow, orange, pink, purple, blue, green }

extension NoteColorExtension on NoteColor {
  int get colorValue {
    switch (this) {
      case NoteColor.yellow:
        return 0xFFFFE082;
      case NoteColor.orange:
        return 0xFFFFCC80;
      case NoteColor.pink:
        return 0xFFF8BBD0;
      case NoteColor.purple:
        return 0xFFE1BEE7;
      case NoteColor.blue:
        return 0xFFBBDEFB;
      case NoteColor.green:
        return 0xFFC8E6C9;
    }
  }
}
