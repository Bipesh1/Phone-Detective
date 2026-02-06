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
  final Color avatarColor;

  const Contact({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.phoneNumber,
    this.email,
    this.relationship,
    this.notes,
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
      'avatarColor': avatarColor.value, // ignore: deprecated_member_use
    };
  }

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      id: json['id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      phoneNumber: json['phoneNumber'] as String?,
      email: json['email'] as String?,
      relationship: json['relationship'] as String?,
      notes: json['notes'] as String?,
      avatarColor: Color(json['avatarColor'] as int? ?? 0xFF007AFF),
    );
  }
}
