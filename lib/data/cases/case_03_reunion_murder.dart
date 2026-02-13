// Phone Detective - Case 03: The Reunion Murder

import 'package:flutter/material.dart';
import '../../models/models.dart';

final case03ReunionMurder = CaseData(
  caseNumber: 3,
  title: 'The Reunion Murder',
  subtitle: 'Death at a high school reunion',
  description:
      'Someone died at a reunion party. The victim\'s phone holds secrets.',
  scenario:
      'Robert Hayes was found dead at his 20-year high school reunion. The phone belonged to him. Five former classmates were at the party, and old grudges run deep. Someone wanted Robert dead. Find out who.',
  objective: 'Uncover the murderer among the former classmates.',
  difficulty: CaseDifficulty.medium,
  themeColor: const Color(0xFF8E24AA),
  totalClues: 8,
  contacts: [
    Contact(
      id: 'robert',
      firstName: 'Robert',
      lastName: 'Hayes',
      phoneNumber: '555-3001',
      relationship: 'Phone Owner (Victim)',
      avatarColor: const Color(0xFF607D8B),
    ),
    Contact(
      id: 'amanda',
      firstName: 'Amanda',
      lastName: 'Pierce',
      phoneNumber: '555-3002',
      relationship: 'Ex-girlfriend',
      avatarColor: const Color(0xFFE91E63),
    ),
    Contact(
      id: 'steve',
      firstName: 'Steve',
      lastName: 'Morrison',
      phoneNumber: '555-3003',
      relationship: 'Former rival',
      avatarColor: const Color(0xFF3F51B5),
    ),
    Contact(
      id: 'diana',
      firstName: 'Diana',
      lastName: 'Chen',
      phoneNumber: '555-3004',
      relationship: 'Classmate',
      avatarColor: const Color(0xFF9C27B0),
    ),
    Contact(
      id: 'greg',
      firstName: 'Greg',
      lastName: 'Thompson',
      phoneNumber: '555-3005',
      relationship: 'Best friend',
      avatarColor: const Color(0xFF4CAF50),
    ),
  ],
  conversations: [
    Conversation(
      id: 'conv_amanda',
      contactId: 'amanda',
      messages: [
        Message(
          id: 'msg1',
          conversationId: 'conv_amanda',
          senderId: 'amanda',
          content: 'I know what you did to Diana senior year.',
          timestamp: DateTime(2024, 5, 1, 18, 0),
        ),
        Message(
          id: 'msg2',
          conversationId: 'conv_amanda',
          senderId: 'owner',
          content: 'That was 20 years ago. Let it go.',
          timestamp: DateTime(2024, 5, 1, 18, 10),
        ),
        Message(
          id: 'msg3',
          conversationId: 'conv_amanda',
          senderId: 'amanda',
          content: 'Pay me \$10,000 or I tell everyone at the reunion.',
          timestamp: DateTime(2024, 5, 1, 18, 15),
        ),
        Message(
          id: 'msg4',
          conversationId: 'conv_amanda',
          senderId: 'owner',
          content: 'You\'re bluffing.',
          timestamp: DateTime(2024, 5, 1, 18, 20),
        ),
        Message(
          id: 'msg5',
          conversationId: 'conv_amanda',
          senderId: 'amanda',
          content: 'Try me.',
          timestamp: DateTime(2024, 5, 1, 18, 25),
        ),
      ],
    ),
    Conversation(
      id: 'conv_steve',
      contactId: 'steve',
      messages: [
        Message(
          id: 'msg6',
          conversationId: 'conv_steve',
          senderId: 'steve',
          content: 'Ready to lose again at the reunion golf thing?',
          timestamp: DateTime(2024, 5, 5, 10, 0),
        ),
        Message(
          id: 'msg7',
          conversationId: 'conv_steve',
          senderId: 'owner',
          content:
              'I destroyed your business, Steve. Golf is the least of your problems.',
          timestamp: DateTime(2024, 5, 5, 10, 15),
        ),
        Message(
          id: 'msg8',
          conversationId: 'conv_steve',
          senderId: 'steve',
          content: 'You\'ll pay for that. I swear you\'ll pay.',
          timestamp: DateTime(2024, 5, 5, 10, 20),
        ),
      ],
    ),
    Conversation(
      id: 'conv_greg',
      contactId: 'greg',
      messages: [
        Message(
          id: 'msg9',
          conversationId: 'conv_greg',
          senderId: 'owner',
          content:
              'Greg, I need to tell you something. I\'ve been hiding this for years.',
          timestamp: DateTime(2024, 5, 10, 21, 0),
        ),
        Message(
          id: 'msg10',
          conversationId: 'conv_greg',
          senderId: 'greg',
          content: 'What is it?',
          timestamp: DateTime(2024, 5, 10, 21, 5),
        ),
        Message(
          id: 'msg11',
          conversationId: 'conv_greg',
          senderId: 'owner',
          content: 'Senior year. Diana. I did something terrible to her.',
          timestamp: DateTime(2024, 5, 10, 21, 10),
        ),
        Message(
          id: 'msg12',
          conversationId: 'conv_greg',
          senderId: 'greg',
          content: 'Diana Chen? What did you do?',
          timestamp: DateTime(2024, 5, 10, 21, 12),
        ),
        Message(
          id: 'msg13',
          conversationId: 'conv_greg',
          senderId: 'owner',
          content:
              'I\'ll tell you at the reunion. It\'s time to make things right.',
          timestamp: DateTime(2024, 5, 10, 21, 15),
        ),
      ],
    ),
  ],
  photos: [
    Photo(
      id: 'photo1',
      title: 'Reunion Venue',
      dateTaken: DateTime(2024, 5, 11, 19, 0),
      location: 'Hilltop Country Club',
    ),
    Photo(
      id: 'photo2',
      title: 'Group Photo',
      dateTaken: DateTime(2024, 5, 11, 20, 30),
      location: 'Main Hall',
    ),
    Photo(
      id: 'photo3',
      title: 'Robert with Amanda',
      dateTaken: DateTime(2024, 5, 11, 21, 0),
    ),
    Photo(
      id: 'photo4',
      title: 'Balcony View',
      dateTaken: DateTime(2024, 5, 11, 22, 15),
      location: 'Balcony',
      hotspots: [
        PhotoHotspot(
          id: 'hs1',
          x: 0.7,
          y: 0.4,
          description:
              'A figure in dark clothing can be seen in the reflection. Hard to identify.',
        ),
      ],
    ),
  ],
  notes: [
    Note(
      id: 'note1',
      title: 'Confession Speech',
      content:
          'Draft:\n"I need to apologize to Diana Chen. Twenty years ago, I spread rumors that destroyed her reputation. I was young and stupid. Diana, if you\'re here, I\'m sorry. I\'m donating \$100,000 to women\'s shelters in your name."',
      createdAt: DateTime(2024, 5, 10),
    ),
  ],
  callLog: [
    CallRecord(
      id: 'call1',
      contactId: 'amanda',
      phoneNumber: '555-3002',
      type: CallType.incoming,
      timestamp: DateTime(2024, 5, 11, 17, 0),
      duration: const Duration(minutes: 5),
    ),
    CallRecord(
      id: 'call2',
      contactId: 'steve',
      phoneNumber: '555-3003',
      type: CallType.missed,
      timestamp: DateTime(2024, 5, 11, 21, 45),
      duration: Duration.zero,
    ),
    CallRecord(
      id: 'call3',
      contactId: 'steve',
      phoneNumber: '555-3003',
      type: CallType.missed,
      timestamp: DateTime(2024, 5, 11, 22, 0),
      duration: Duration.zero,
    ),
  ],
  emails: [
    Email(
      id: 'email1',
      senderId: 'amanda',
      senderEmail: 'amanda.p@gmail.com',
      senderName: 'Amanda Pierce',
      subject: 'Last Chance',
      body:
          'Robert,\n\nThis is your last chance. Transfer the money by tonight or I \'m going up on that stage and telling everyone what you did.\n\nAmanda',
      timestamp: DateTime(2024, 5, 11, 14, 0),
    ),
  ],
  solution: CaseSolution(
    guiltyContactId: 'steve',
    motive: 'Revenge for destroyed business',
    method: 'Pushed Robert from the balcony',
    keyClueIds: ['msg8', 'call2', 'photo4'],
    resolution:
        'Steve Morrison killed Robert in revenge for destroying his business. The missed calls at 21:45 and 22:00 show Steve trying to lure Robert outside. The reflection in the balcony photo shows a figure in Steve\'s distinctive dark coat. Amanda was blackmailing Robert but wouldn\'t kill her meal ticket. Diana had motive but an alibi. Greg genuinely wanted reconciliation.',
    options: [
      SolutionOption(
        contactId: 'amanda',
        label: 'Amanda Pierce - the blackmailer',
        isCorrect: false,
        feedback:
            'Amanda was blackmailing Robert, but killing him would end her income stream. She had no reason to murder him.',
      ),
      SolutionOption(
        contactId: 'steve',
        label: 'Steve Morrison - the ruined rival',
        isCorrect: true,
        feedback:
            'Correct! Steve\'s threatening messages, the suspicious missed calls at the time of death, and his silhouette in the balcony photo all prove his guilt.',
      ),
      SolutionOption(
        contactId: 'diana',
        label: 'Diana Chen - the victim of rumors',
        isCorrect: false,
        feedback:
            'Diana had motive from the past, but she was in the main hall with witnesses when Robert died.',
      ),
      SolutionOption(
        contactId: 'greg',
        label: 'Greg Thompson - the "best friend"',
        isCorrect: false,
        feedback:
            'Greg was genuinely trying to help Robert confess. No evidence suggests involvement.',
      ),
    ],
  ),
);
