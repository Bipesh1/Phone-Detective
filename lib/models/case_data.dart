// Phone Detective - Case Data Model

import 'package:flutter/material.dart';
import 'message.dart';
import 'contact.dart';
import 'photo.dart';
import 'note.dart';
import 'call_record.dart';
import 'email.dart';

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

  factory CaseData.fromJson(Map<String, dynamic> json) {
    return CaseData(
      caseNumber: json['case_number'] as int,
      title: json['title'] as String,
      subtitle: (json['subtitle'] as String?) ?? '',
      description: (json['description'] as String?) ?? '',
      scenario: (json['scenario'] as String?) ?? '',
      objective: (json['objective'] as String?) ?? 'Solve the mystery.',

      // DB has difficulty as integer
      difficulty: _difficultyFromInt((json['difficulty'] as int?) ?? 1),

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

      // Column doesn't exist in your table; keep default for now
      totalClues: 0,

      // DB has theme_color_hex text
      themeColor: _colorFromHex(json['theme_color_hex'] as String?),

      // Column doesn't exist in your table
      wallpaper: null,

      hints: (json['hints'] as List<dynamic>? ?? []).cast<String>(),
    );
  }

  static CaseDifficulty _difficultyFromInt(int v) {
    switch (v) {
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

  const CaseSolution({
    required this.guiltyContactId,
    required this.motive,
    required this.method,
    required this.keyClueIds,
    required this.resolution,
    required this.options,
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
