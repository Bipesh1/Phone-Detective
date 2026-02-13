// Phone Detective - Call Record Model

class CallRecord {
  final String id;
  final String contactId;
  final String phoneNumber;
  final CallType type;
  final DateTime timestamp;
  final Duration duration;
  final bool isRead;

  const CallRecord({
    required this.id,
    required this.contactId,
    required this.phoneNumber,
    required this.type,
    required this.timestamp,
    required this.duration,
    this.isRead = true,
  });

  String get displayTime {
    final hour = timestamp.hour;
    final minute = timestamp.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '$displayHour:$minute $period';
  }

  String get displayDuration {
    if (duration.inSeconds == 0) return '';
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    if (minutes == 0) return '${seconds}s';
    return '${minutes}m ${seconds}s';
  }

  String get displayDate {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final callDate = DateTime(timestamp.year, timestamp.month, timestamp.day);

    if (callDate == today) return 'Today';
    if (callDate == yesterday) return 'Yesterday';

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
    return '${months[timestamp.month - 1]} ${timestamp.day}';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'contactId': contactId,
      'phoneNumber': phoneNumber,
      'type': type.name,
      'timestamp': timestamp.toIso8601String(),
      'duration': duration.inSeconds,
      'isRead': isRead,
    };
  }

  factory CallRecord.fromJson(Map<String, dynamic> json) {
    return CallRecord(
      id: (json['id'] as String?) ?? 'unknown',
      contactId: (json['contactId'] as String?) ?? '',
      phoneNumber: (json['phoneNumber'] as String?) ?? 'Unknown',
      type: CallType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => CallType.incoming,
      ),
      timestamp:
          DateTime.tryParse(json['timestamp'] as String? ?? '') ??
          DateTime.now(),
      duration: Duration(seconds: (json['duration'] as num?)?.toInt() ?? 0),
      isRead: json['isRead'] as bool? ?? true,
    );
  }
}

enum CallType { incoming, outgoing, missed }

extension CallTypeExtension on CallType {
  String get icon {
    switch (this) {
      case CallType.incoming:
        return '↙️';
      case CallType.outgoing:
        return '↗️';
      case CallType.missed:
        return '❌';
    }
  }

  int get colorValue {
    switch (this) {
      case CallType.incoming:
        return 0xFF34C759; // Green
      case CallType.outgoing:
        return 0xFF007AFF; // Blue
      case CallType.missed:
        return 0xFFFF3B30; // Red
    }
  }
}
