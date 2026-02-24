// Phone Detective - Interrogation Model

class InterrogationQuestion {
  final String id;
  final String contactId;
  final String question;
  final List<InterrogationAnswer> answers;

  const InterrogationQuestion({
    required this.id,
    required this.contactId,
    required this.question,
    required this.answers,
  });

  /// Get the best answer based on what clues the player has found
  InterrogationAnswer getBestAnswer(Set<String> foundClueIds) {
    // Sort answers by number of required clues (most specific first)
    final sorted = [...answers]..sort(
        (a, b) => b.requiredClueIds.length.compareTo(a.requiredClueIds.length));

    for (final answer in sorted) {
      if (answer.requiredClueIds.isEmpty) continue;
      if (answer.requiredClueIds.every((id) => foundClueIds.contains(id))) {
        return answer;
      }
    }

    // Return the default answer (empty requiredClueIds)
    return answers.firstWhere(
      (a) => a.requiredClueIds.isEmpty,
      orElse: () => answers.first,
    );
  }

  factory InterrogationQuestion.fromJson(Map<String, dynamic> json) {
    return InterrogationQuestion(
      id: (json['id'] as String?) ?? 'unknown',
      contactId:
          (json['contactId'] as String? ?? json['contact_id'] as String?) ?? '',
      question: (json['question'] as String?) ?? '',
      answers: (json['answers'] as List<dynamic>? ?? [])
          .map((e) => InterrogationAnswer.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'contactId': contactId,
      'question': question,
      'answers': answers.map((a) => a.toJson()).toList(),
    };
  }
}

class InterrogationAnswer {
  final List<String> requiredClueIds; // Clues needed for this answer
  final String response;
  final String? revealsClueId; // If this answer reveals a new clue

  const InterrogationAnswer({
    required this.requiredClueIds,
    required this.response,
    this.revealsClueId,
  });

  factory InterrogationAnswer.fromJson(Map<String, dynamic> json) {
    return InterrogationAnswer(
      requiredClueIds: (json['requiredClueIds'] as List<dynamic>? ??
              json['required_clue_ids'] as List<dynamic>? ??
              [])
          .cast<String>(),
      response: (json['response'] as String?) ?? '',
      revealsClueId: json['revealsClueId'] as String? ??
          json['reveals_clue_id'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'requiredClueIds': requiredClueIds,
      'response': response,
      'revealsClueId': revealsClueId,
    };
  }
}

class DeductionItem {
  final String id;
  final String statement;
  final List<String> linkedClueIds;

  const DeductionItem({
    required this.id,
    required this.statement,
    required this.linkedClueIds,
  });

  factory DeductionItem.fromJson(Map<String, dynamic> json) {
    return DeductionItem(
      id: (json['id'] as String?) ?? 'unknown',
      statement: (json['statement'] as String?) ?? '',
      linkedClueIds: (json['linkedClueIds'] as List<dynamic>? ??
              json['linked_clue_ids'] as List<dynamic>? ??
              [])
          .cast<String>(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'statement': statement,
      'linkedClueIds': linkedClueIds,
    };
  }
}
