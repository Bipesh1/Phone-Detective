// Phone Detective - Contact Model

import 'package:flutter/material.dart';

class Contact {
  final String id;
  final String firstName;
  final String lastName;
  final String? phoneNumber;
  final String? email;
  final String? relationship; // Victim, Suspect, Friend, etc.
  final String? notes;
  final String? birthday; // Format: YYYY-MM-DD
  final Color avatarColor;

  const Contact({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.phoneNumber,
    this.email,
    this.relationship,
    this.notes,
    this.birthday,
    this.avatarColor = Colors.blue,
  });

  String get fullName => '$firstName $lastName';

  String get initials {
    final first = firstName.isNotEmpty ? firstName[0].toUpperCase() : '';
    final last = lastName.isNotEmpty ? lastName[0].toUpperCase() : '';
    return '$first$last';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'email': email,
      'relationship': relationship,
      'notes': notes,
      'birthday': birthday,
      'avatarColor': avatarColor.value, // ignore: deprecated_member_use
    };
  }

  factory Contact.fromJson(Map<String, dynamic> json) {
    String first = json['firstName'] as String? ?? '';
    String last = json['lastName'] as String? ?? '';

    // Fallback if firstName/lastName are missing but 'name' exists (Supabase/Log discrepancy)
    if (first.isEmpty && last.isEmpty && json['name'] != null) {
      final nameStr = json['name'].toString();
      final parts = nameStr.split(' ');
      if (parts.isNotEmpty) {
        first = parts.first;
        if (parts.length > 1) {
          last = parts.sublist(1).join(' ');
        }
      }
    }

    return Contact(
      id: (json['id'] as String?) ?? 'unknown',
      firstName: first,
      lastName: last,
      phoneNumber: json['phoneNumber'] as String?,
      email: json['email'] as String?,
      relationship: json['relationship'] as String?,
      notes: json['notes'] as String?,
      birthday: json['birthday'] as String?,
      avatarColor: Color(json['avatarColor'] as int? ?? 0xFF007AFF),
    );
  }
}
