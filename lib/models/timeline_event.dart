// Phone Detective - Timeline Event Model

class TimelineEvent {
  final String id;
  final String eventText;
  final int correctOrder; // 1-based position in the correct timeline
  final String? linkedClueId; // Which clue this event relates to
  final DateTime timestamp; // The actual time the event occurred in-story

  const TimelineEvent({
    required this.id,
    required this.eventText,
    required this.correctOrder,
    this.linkedClueId,
    required this.timestamp,
  });

  factory TimelineEvent.fromJson(Map<String, dynamic> json) {
    return TimelineEvent(
      id: (json['id'] as String?) ?? 'unknown',
      eventText:
          (json['eventText'] as String? ?? json['event_text'] as String?) ?? '',
      correctOrder: (json['correctOrder'] as num?)?.toInt() ??
          (json['correct_order'] as num?)?.toInt() ??
          0,
      linkedClueId:
          json['linkedClueId'] as String? ?? json['linked_clue_id'] as String?,
      timestamp: DateTime.tryParse(json['timestamp'] as String? ?? '') ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'eventText': eventText,
      'correctOrder': correctOrder,
      'linkedClueId': linkedClueId,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
