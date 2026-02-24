// Phone Detective - Suspense Event Model

class SuspenseEvent {
  final String id;
  final SuspenseTrigger trigger;
  final String? triggerClueId; // Which clue triggers this event
  final SuspenseType type;
  final String title;
  final String message;
  final String iconName; // Material icon name
  final int delaySeconds; // Delay before showing after trigger

  const SuspenseEvent({
    required this.id,
    required this.trigger,
    this.triggerClueId,
    required this.type,
    required this.title,
    required this.message,
    this.iconName = 'warning',
    this.delaySeconds = 3,
  });

  factory SuspenseEvent.fromJson(Map<String, dynamic> json) {
    return SuspenseEvent(
      id: (json['id'] as String?) ?? 'unknown',
      trigger: SuspenseTrigger.values.firstWhere(
        (e) => e.name == (json['trigger'] as String? ?? 'after_clue'),
        orElse: () => SuspenseTrigger.afterClue,
      ),
      triggerClueId: json['triggerClueId'] as String? ??
          json['trigger_clue_id'] as String?,
      type: SuspenseType.values.firstWhere(
        (e) => e.name == (json['type'] as String? ?? 'notification'),
        orElse: () => SuspenseType.notification,
      ),
      title: (json['title'] as String?) ?? '',
      message: (json['message'] as String?) ?? '',
      iconName: (json['iconName'] as String? ?? json['icon_name'] as String?) ??
          'warning',
      delaySeconds: (json['delaySeconds'] as num?)?.toInt() ??
          (json['delay_seconds'] as num?)?.toInt() ??
          3,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'trigger': trigger.name,
      'triggerClueId': triggerClueId,
      'type': type.name,
      'title': title,
      'message': message,
      'iconName': iconName,
      'delaySeconds': delaySeconds,
    };
  }
}

enum SuspenseTrigger {
  afterClue, // Fires after a specific clue is marked
  afterTime, // Fires after X seconds of gameplay
  onOpen, // Fires when player opens a specific app
}

enum SuspenseType {
  notification, // Phone notification style
  warning, // Ominous warning overlay
  glitch, // Screen glitch effect
  incoming, // Fake incoming call/message
}
