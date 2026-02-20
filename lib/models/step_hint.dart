// Phone Detective - Step Hint Model

class StepHint {
  final String id;
  final String forNodeId; // e.g. "nt1", "em2", "m6", "solution"
  final int stepNumber;
  final String title;
  final List<String> hints; // Progressive hints (first = vague, last = spoiler)

  const StepHint({
    required this.id,
    required this.forNodeId,
    required this.stepNumber,
    required this.title,
    required this.hints,
  });

  factory StepHint.fromJson(Map<String, dynamic> json) {
    return StepHint(
      id: (json['id'] as String?) ?? '',
      forNodeId: (json['forNodeId'] as String?) ??
          (json['for_node_id'] as String?) ??
          '',
      stepNumber:
          (json['stepNumber'] as int?) ?? (json['step_number'] as int?) ?? 0,
      title: (json['title'] as String?) ?? '',
      hints: (json['hints'] as List<dynamic>? ?? []).cast<String>(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'forNodeId': forNodeId,
      'stepNumber': stepNumber,
      'title': title,
      'hints': hints,
    };
  }
}
