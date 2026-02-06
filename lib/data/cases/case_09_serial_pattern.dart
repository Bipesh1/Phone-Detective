// Phone Detective - Case 09: Serial Pattern

import 'package:flutter/material.dart';
import '../../models/models.dart';

final case09SerialPattern = CaseData(
  caseNumber: 9,
  title: 'Serial Pattern',
  subtitle: 'A stalker\'s phone reveals dark secrets',
  description:
      'A phone found at a crime scene belongs to someone obsessed with the victim.',
  scenario:
      'Three women have gone missing in the area. This phone was found near the latest disappearance. The owner has been watching someone for months. Find the pattern. Find the victims.',
  difficulty: CaseDifficulty.veryHard,
  themeColor: const Color(0xFF212121),
  totalClues: 10,
  contacts: [
    Contact(
      id: 'stalker',
      firstName: 'Unknown',
      lastName: 'Owner',
      phoneNumber: '555-9001',
      relationship: 'Phone Owner',
      avatarColor: const Color(0xFF37474F),
    ),
    Contact(
      id: 'lily',
      firstName: 'Lily',
      lastName: 'Thompson',
      phoneNumber: '555-9002',
      relationship: 'Target',
      avatarColor: const Color(0xFFE91E63),
    ),
    Contact(
      id: 'cousin',
      firstName: 'Mark',
      lastName: 'Davis',
      phoneNumber: '555-9003',
      relationship: 'Cousin',
      avatarColor: const Color(0xFF4CAF50),
    ),
  ],
  conversations: [
    Conversation(
      id: 'conv_cousin',
      contactId: 'cousin',
      messages: [
        Message(
          id: 'msg1',
          conversationId: 'conv_cousin',
          senderId: 'cousin',
          content: 'Happy birthday cuz! Dinner this weekend?',
          timestamp: DateTime(2024, 11, 1, 10, 0),
        ),
        Message(
          id: 'msg2',
          conversationId: 'conv_cousin',
          senderId: 'owner',
          content: 'Can\'t. Busy with a project.',
          timestamp: DateTime(2024, 11, 1, 12, 0),
        ),
        Message(
          id: 'msg3',
          conversationId: 'conv_cousin',
          senderId: 'cousin',
          content: 'You\'re always busy. When will I meet your girlfriend?',
          timestamp: DateTime(2024, 11, 1, 12, 10),
        ),
        Message(
          id: 'msg4',
          conversationId: 'conv_cousin',
          senderId: 'owner',
          content: 'Soon. She just doesn\'t know it yet.',
          timestamp: DateTime(2024, 11, 1, 12, 15),
        ),
      ],
    ),
    Conversation(
      id: 'conv_lily',
      contactId: 'lily',
      messages: [
        Message(
          id: 'msg5',
          conversationId: 'conv_lily',
          senderId: 'owner',
          content: 'I saw you at the coffee shop today. You looked beautiful.',
          timestamp: DateTime(2024, 11, 5, 19, 0),
        ),
        Message(
          id: 'msg6',
          conversationId: 'conv_lily',
          senderId: 'lily',
          content: 'Who is this? How did you get my number?',
          timestamp: DateTime(2024, 11, 5, 19, 30),
        ),
        Message(
          id: 'msg7',
          conversationId: 'conv_lily',
          senderId: 'owner',
          content:
              'I\'ve been watching you for months. We\'re meant to be together.',
          timestamp: DateTime(2024, 11, 5, 19, 35),
        ),
        Message(
          id: 'msg8',
          conversationId: 'conv_lily',
          senderId: 'lily',
          content: 'Leave me alone or I\'m calling the police!',
          timestamp: DateTime(2024, 11, 5, 19, 40),
        ),
        Message(
          id: 'msg9',
          conversationId: 'conv_lily',
          senderId: 'owner',
          content: 'Don\'t make this difficult. The others fought back too.',
          timestamp: DateTime(2024, 11, 5, 19, 45),
        ),
      ],
    ),
  ],
  photos: [
    Photo(
      id: 'photo1',
      title: 'Lily at coffee shop',
      dateTaken: DateTime(2024, 11, 5, 8, 30),
    ),
    Photo(
      id: 'photo2',
      title: 'Lily\'s apartment building',
      dateTaken: DateTime(2024, 11, 3, 22, 0),
    ),
    Photo(
      id: 'photo3',
      title: 'Unknown woman #1',
      dateTaken: DateTime(2024, 8, 10),
    ),
    Photo(
      id: 'photo4',
      title: 'Unknown woman #2',
      dateTaken: DateTime(2024, 9, 15),
    ),
    Photo(
      id: 'photo5',
      title: 'Remote cabin',
      dateTaken: DateTime(2024, 10, 1),
      location: 'GPS: 44.7890, -121.5567',
      hotspots: [
        PhotoHotspot(
          id: 'hs1',
          x: 0.5,
          y: 0.7,
          description:
              'A remote cabin in the woods. The GPS coordinates are visible. Could this be where victims are taken?',
        ),
      ],
    ),
  ],
  notes: [
    Note(
      id: 'note1',
      title: 'Diary',
      content:
          'Nov 1 - My birthday. 31 years alone. But not anymore.\nI\'ve found her. Lily. She\'s perfect. Just like the others thought they were.\nBut those others... they disappointed me. Said no. Had to be dealt with.\nLily won\'t say no. I won\'t give her the choice.',
      createdAt: DateTime(2024, 11, 1),
      isLocked: true,
      password: 'lily',
    ),
    Note(
      id: 'note2',
      title: 'Schedule',
      content:
          'Lily\'s routine:\n- 7am: Leaves apt\n- 7:30: Coffee (Bean & Brew)\n- 8am: Work (Richards Law)\n- 6pm: Goes home\n- Tues/Thurs: Gym\n- Lives alone',
      createdAt: DateTime(2024, 11, 4),
    ),
  ],
  callLog: [
    CallRecord(
      id: 'call1',
      contactId: 'lily',
      phoneNumber: '555-9002',
      type: CallType.outgoing,
      timestamp: DateTime(2024, 11, 5, 23, 0),
      duration: Duration.zero,
    ),
    CallRecord(
      id: 'call2',
      contactId: 'lily',
      phoneNumber: '555-9002',
      type: CallType.outgoing,
      timestamp: DateTime(2024, 11, 6, 0, 30),
      duration: Duration.zero,
    ),
  ],
  emails: [],
  solution: CaseSolution(
    guiltyContactId: 'stalker',
    motive: 'Obsessive love/Serial predator',
    method: 'Stalking, abduction to remote cabin',
    keyClueIds: ['msg9', 'note1', 'note2', 'photo5'],
    resolution:
        'The phone owner is a serial predator. The diary confession mentions "the others" who "had to be dealt with." The stalking photos and detailed schedule show obsessive surveillance of Lily. The cabin photo with GPS coordinates led police to a remote location where evidence of the previous victims was found. Mark Davis (cousin) identified the phone owner as his cousin Derek Davis. Lily was rescued before becoming the next victim. The cabin GPS was the key to finding the crime scene.',
    options: [
      SolutionOption(
        contactId: 'stalker',
        label: 'The phone owner is a serial predator',
        isCorrect: true,
        feedback:
            'Correct! The diary confession, stalker photos, detailed victim schedule, and cabin location all prove this is a serial predator who abducted the previous missing women.',
      ),
      SolutionOption(
        contactId: 'cousin',
        label: 'Mark Davis is the actual stalker',
        isCorrect: false,
        feedback:
            'Mark appears to be a normal cousin unaware of Derek\'s crimes. The messages show he doesn\'t know about the "girlfriend."',
      ),
      SolutionOption(
        contactId: '',
        label: 'This is a false lead - phone was planted',
        isCorrect: false,
        feedback:
            'The GPS coordinates in the cabin photo led to real evidence. This phone belongs to the actual perpetrator.',
      ),
    ],
  ),
);


