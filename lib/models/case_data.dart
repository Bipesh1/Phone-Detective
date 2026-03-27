// Phone Detective - Case Data Model

import 'package:flutter/material.dart';
import 'message.dart';
import 'contact.dart';
import 'photo.dart';
import 'note.dart';
import 'call_record.dart';
import 'email.dart';
import 'step_hint.dart';
import 'suspense_event.dart';
import 'timeline_event.dart';
import 'interrogation.dart';

class CaseData {
  final int caseNumber;
  final String title;
  final String subtitle;
  final String description;
  final String scenario; // Intro text shown when starting case
  final String objective; // Mission goal
  final CaseDifficulty difficulty;
  final List<Contact> contacts;
  final List<Conversation> conversations;
  final List<Photo> photos;
  final List<Note> notes;
  final List<CallRecord> callLog;
  final List<Email> emails;
  final CaseSolution solution;
  final int totalClues; // Not in DB right now (set default or add column)
  final Color themeColor;
  final String? wallpaper; // Not in DB right now (null unless you add column)
  final List<String> hints;
  final List<StepHint> stepHints;
  final List<SuspenseEvent> suspenseEvents;
  final List<TimelineEvent> evidenceTimeline;
  final List<InterrogationQuestion> interrogationQuestions;
  final List<int> unlockRequires; // Case numbers that must be solved first
  final String handlerBriefing; // Encrypted message from HQ shown on hacking screen
  final int batteryStartPercent; // Phone battery % when player picks it up (default 100)
  final double batteryDrainPerMinute; // Drain rate per minute — 0 means static battery

  const CaseData({
    required this.caseNumber,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.scenario,
    required this.objective,
    required this.difficulty,
    required this.contacts,
    required this.conversations,
    required this.photos,
    required this.notes,
    required this.callLog,
    required this.emails,
    required this.solution,
    required this.totalClues,
    this.themeColor = const Color(0xFF007AFF),
    this.wallpaper,
    this.hints = const [],
    this.stepHints = const [],
    this.suspenseEvents = const [],
    this.evidenceTimeline = const [],
    this.interrogationQuestions = const [],
    this.unlockRequires = const [],
    this.handlerBriefing = '',
    this.batteryStartPercent = 100,
    this.batteryDrainPerMinute = 0,
  });

  Contact? getContact(String id) {
    try {
      return contacts.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  Conversation? getConversation(String contactId) {
    try {
      return conversations.firstWhere((c) => c.contactId == contactId);
    } catch (_) {
      return null;
    }
  }

  List<Message> getMessagesForContact(String contactId) {
    final conv = getConversation(contactId);
    return conv?.messages ?? [];
  }

  /// Find the step hint for a specific node (note, email, message, or "solution")
  StepHint? getStepHintForNode(String nodeId) {
    try {
      return stepHints.firstWhere((h) => h.forNodeId == nodeId);
    } catch (_) {
      return null;
    }
  }

  /// Get interrogation questions for a specific contact
  List<InterrogationQuestion> getInterrogationQuestionsForContact(
      String contactId) {
    return interrogationQuestions
        .where((q) => q.contactId == contactId)
        .toList();
  }

  /// Check if a contact has interrogation questions
  bool hasInterrogationQuestions(String contactId) {
    return interrogationQuestions.any((q) => q.contactId == contactId);
  }

  factory CaseData.fromJson(Map<String, dynamic> json) {
    return CaseData(
      caseNumber: json['case_number'] as int,
      title: json['title'] as String,
      subtitle: (json['subtitle'] as String?) ?? '',
      description: (json['description'] as String?) ?? '',
      scenario: (json['scenario'] as String?) ?? '',
      objective: (json['objective'] as String?) ?? 'Solve the mystery.',

      difficulty: _parseDifficulty(json['difficulty']),

      contacts: (json['contacts'] as List<dynamic>? ?? [])
          .map((e) => Contact.fromJson(e as Map<String, dynamic>))
          .toList(),

      conversations: (json['conversations'] as List<dynamic>? ?? [])
          .map((e) => Conversation.fromJson(e as Map<String, dynamic>))
          .toList(),

      photos: (json['photos'] as List<dynamic>? ?? [])
          .map((e) => Photo.fromJson(e as Map<String, dynamic>))
          .toList(),

      notes: (json['notes'] as List<dynamic>? ?? [])
          .map((e) => Note.fromJson(e as Map<String, dynamic>))
          .toList(),

      callLog: (json['call_log'] as List<dynamic>? ?? [])
          .map((e) => CallRecord.fromJson(e as Map<String, dynamic>))
          .toList(),

      emails: (json['emails'] as List<dynamic>? ?? [])
          .map((e) => Email.fromJson(e as Map<String, dynamic>))
          .toList(),

      solution: CaseSolution.fromJson(json['solution'] as Map<String, dynamic>),

      // Use DB value if > 0, otherwise auto-compute from key clue IDs
      totalClues: ((json['total_clues'] as int?) ?? 0) > 0
          ? (json['total_clues'] as int)
          : (json['solution'] is Map
              ? ((json['solution'] as Map)['key_clue_ids'] as List?)?.length ?? 0
              : 0),

      // DB has theme_color_hex text
      themeColor: _colorFromHex(json['theme_color_hex'] as String?),

      // Column doesn't exist in your table
      wallpaper: null,

      hints: (json['hints'] as List<dynamic>? ?? []).cast<String>(),

      stepHints: (json['step_hints'] as List<dynamic>? ?? [])
          .map((e) => StepHint.fromJson(e as Map<String, dynamic>))
          .toList(),

      suspenseEvents: (json['suspense_events'] as List<dynamic>? ?? [])
          .map((e) => SuspenseEvent.fromJson(e as Map<String, dynamic>))
          .toList(),

      evidenceTimeline: (json['evidence_timeline'] as List<dynamic>? ?? [])
          .map((e) => TimelineEvent.fromJson(e as Map<String, dynamic>))
          .toList(),

      interrogationQuestions: (json['interrogation_questions']
                  as List<dynamic>? ??
              [])
          .map((e) => InterrogationQuestion.fromJson(e as Map<String, dynamic>))
          .toList(),

      unlockRequires: (json['unlock_requires'] as List<dynamic>? ?? [])
          .map((e) => (e is int) ? e : int.tryParse(e.toString()) ?? 0)
          .toList(),

      handlerBriefing: (json['handler_briefing'] as String?) ?? '',
      batteryStartPercent: (json['battery_start_percent'] as int?) ?? 100,
      batteryDrainPerMinute:
          ((json['battery_drain_per_minute'] as num?) ?? 0).toDouble(),
    );
  }

  /// Throws an AssertionError in debug mode if required fields are missing.
  void validate() {
    assert(title.isNotEmpty, 'Case $caseNumber: title is empty');
    assert(scenario.isNotEmpty, 'Case $caseNumber: scenario is empty');
    assert(objective.isNotEmpty, 'Case $caseNumber: objective is empty');
    assert(contacts.isNotEmpty, 'Case $caseNumber: no contacts defined');
    // Tutorial cases (difficulty 0) are intentionally simpler — skip checks
    // that require red herrings, a timeline, and suspense events.
    if (difficulty != CaseDifficulty.tutorial) {
      assert(solution.redHerringIds.isNotEmpty, 'Case $caseNumber: no red herrings defined');
      assert(evidenceTimeline.isNotEmpty, 'Case $caseNumber: no evidenceTimeline defined');
      assert(suspenseEvents.isNotEmpty, 'Case $caseNumber: no suspenseEvents defined');
    }
  }

  static CaseDifficulty _parseDifficulty(dynamic value) {
    if (value == null) return CaseDifficulty.easy;

    // Handle integer values
    if (value is int) {
      switch (value) {
        case 0:
          return CaseDifficulty.tutorial;
        case 1:
          return CaseDifficulty.easy;
        case 2:
          return CaseDifficulty.medium;
        case 3:
          return CaseDifficulty.hard;
        case 4:
          return CaseDifficulty.veryHard;
        default:
          return CaseDifficulty.easy;
      }
    }

    // String fallback (e.g. local data or future migration)
    final str = value.toString().toLowerCase().trim();
    switch (str) {
      case 'tutorial':
        return CaseDifficulty.tutorial;
      case 'easy':
        return CaseDifficulty.easy;
      case 'medium':
        return CaseDifficulty.medium;
      case 'hard':
        return CaseDifficulty.hard;
      case 'very_hard' || 'veryhard' || 'veryHard':
        return CaseDifficulty.veryHard;
      default:
        return CaseDifficulty.easy;
    }
  }

  static Color _colorFromHex(String? hex) {
    if (hex == null || hex.trim().isEmpty) return const Color(0xFF007AFF);

    var h = hex.trim().replaceAll('#', '');
    // allow "0xFF007AFF" too
    if (h.startsWith('0x') || h.startsWith('0X')) {
      h = h.substring(2);
    }

    // if only RGB given, add alpha
    if (h.length == 6) h = 'FF$h';

    final value = int.parse(h, radix: 16);
    return Color(value);
  }
}

enum CaseDifficulty { tutorial, easy, medium, hard, veryHard }

extension CaseDifficultyExtension on CaseDifficulty {
  String get label {
    switch (this) {
      case CaseDifficulty.tutorial:
        return 'Tutorial';
      case CaseDifficulty.easy:
        return 'Easy';
      case CaseDifficulty.medium:
        return 'Medium';
      case CaseDifficulty.hard:
        return 'Hard';
      case CaseDifficulty.veryHard:
        return 'Very Hard';
    }
  }

  int get stars {
    switch (this) {
      case CaseDifficulty.tutorial:
        return 1;
      case CaseDifficulty.easy:
        return 2;
      case CaseDifficulty.medium:
        return 3;
      case CaseDifficulty.hard:
        return 4;
      case CaseDifficulty.veryHard:
        return 5;
    }
  }

  Color get color {
    switch (this) {
      case CaseDifficulty.tutorial:
        return const Color(0xFF34C759);
      case CaseDifficulty.easy:
        return const Color(0xFF34C759);
      case CaseDifficulty.medium:
        return const Color(0xFFFFCC00);
      case CaseDifficulty.hard:
        return const Color(0xFFFF9500);
      case CaseDifficulty.veryHard:
        return const Color(0xFFFF3B30);
    }
  }
}

class CaseSolution {
  final String guiltyContactId;
  final String motive;
  final String method;
  final List<String> keyClueIds; // IDs of essential clues
  final String resolution; // What happened after solving
  final List<SolutionOption> options; // Multiple choice options
  final List<DeductionItem> deductionChecklist; // Logical deductions to verify
  final List<MotiveOption> motiveOptions; // Motive choices for the accusation screen
  final List<String> redHerringIds; // Misleading clue IDs
  /// Per-clue insight shown when the player marks a key clue.
  /// Key = clue/item ID, Value = one-sentence explanation of its significance.
  final Map<String, String> clueInsights;

  const CaseSolution({
    required this.guiltyContactId,
    required this.motive,
    required this.method,
    required this.keyClueIds,
    required this.resolution,
    required this.options,
    this.deductionChecklist = const [],
    this.motiveOptions = const [],
    this.redHerringIds = const [],
    this.clueInsights = const {},
  });

  factory CaseSolution.fromJson(Map<String, dynamic> json) {
    return CaseSolution(
      guiltyContactId: (json['guilty_contact_id'] as String?) ?? '',
      motive: (json['motive'] as String?) ?? '',
      method: (json['method'] as String?) ?? '',
      keyClueIds: (json['key_clue_ids'] as List<dynamic>? ?? []).cast<String>(),
      resolution: (json['resolution'] as String?) ?? '',
      options: (json['options'] as List<dynamic>? ?? [])
          .map((e) => SolutionOption.fromJson(e as Map<String, dynamic>))
          .toList(),
      deductionChecklist: (json['deduction_checklist'] as List<dynamic>? ?? [])
          .map((e) => DeductionItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      motiveOptions: (json['motive_options'] as List<dynamic>? ?? [])
          .map((e) => MotiveOption.fromJson(e as Map<String, dynamic>))
          .toList(),
      redHerringIds:
          (json['red_herrings'] as List<dynamic>? ?? []).cast<String>(),
      clueInsights: Map<String, String>.from(
        (json['clue_insights'] as Map<dynamic, dynamic>?) ?? {},
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'guilty_contact_id': guiltyContactId,
      'motive': motive,
      'method': method,
      'key_clue_ids': keyClueIds,
      'resolution': resolution,
      'options': options.map((e) => e.toJson()).toList(),
      'deduction_checklist': deductionChecklist.map((e) => e.toJson()).toList(),
      'red_herrings': redHerringIds,
    };
  }
}

class SolutionOption {
  final String contactId;
  final String label;
  final bool isCorrect;
  final String feedback; // Shown when selected

  const SolutionOption({
    required this.contactId,
    required this.label,
    required this.isCorrect,
    required this.feedback,
  });

  Map<String, dynamic> toJson() {
    return {
      'contact_id': contactId,
      'label': label,
      'is_correct': isCorrect,
      'feedback': feedback,
    };
  }

  factory SolutionOption.fromJson(Map<String, dynamic> json) {
    return SolutionOption(
      contactId: (json['contact_id'] as String?) ?? '',
      label: (json['label'] as String?) ?? '',
      isCorrect: (json['is_correct'] as bool?) ?? false,
      feedback: (json['feedback'] as String?) ?? '',
    );
  }
}

class MotiveOption {
  final String id;
  final String text;
  final bool isCorrect;

  const MotiveOption({
    required this.id,
    required this.text,
    required this.isCorrect,
  });

  factory MotiveOption.fromJson(Map<String, dynamic> json) {
    return MotiveOption(
      id: (json['id'] as String?) ?? '',
      text: (json['text'] as String?) ?? '',
      isCorrect: (json['is_correct'] as bool?) ?? false,
    );
  }
}
