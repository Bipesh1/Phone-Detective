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
  final CaseDifficulty difficulty;
  final List<Contact> contacts;
  final List<Conversation> conversations;
  final List<Photo> photos;
  final List<Note> notes;
  final List<CallRecord> callLog;
  final List<Email> emails;
  final CaseSolution solution;
  final int totalClues;
  final Color themeColor;
  final String? wallpaper; // Optional case-themed wallpaper

  const CaseData({
    required this.caseNumber,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.scenario,
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
}
