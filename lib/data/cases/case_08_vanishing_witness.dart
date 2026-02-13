// Phone Detective - Case 08: The Vanishing Witness

import 'package:flutter/material.dart';
import '../../models/models.dart';

final case08VanishingWitness = CaseData(
  caseNumber: 8,
  title: 'The Vanishing Witness',
  subtitle: 'A witness went missing before trial',
  description:
      'A key witness disappeared before testifying against the mob. But is it what it seems?',
  scenario:
      'Carlos Mendez was going to testify against the Rosetti crime family. He vanished two days before trial. His phone was found at his apartment. Did the mob get him, or did he get himself out?',
  objective: 'Locate the missing witness and uncover the truth.',
  difficulty: CaseDifficulty.hard,
  themeColor: const Color(0xFF424242),
  totalClues: 8,
  contacts: [
    Contact(
      id: 'carlos',
      firstName: 'Carlos',
      lastName: 'Mendez',
      phoneNumber: '555-8001',
      relationship: 'Phone Owner (Missing)',
      avatarColor: const Color(0xFF795548),
    ),
    Contact(
      id: 'agent',
      firstName: 'Agent',
      lastName: 'Morrison',
      phoneNumber: '555-8002',
      relationship: 'FBI Handler',
      avatarColor: const Color(0xFF1976D2),
    ),
    Contact(
      id: 'maria',
      firstName: 'Maria',
      lastName: 'Mendez',
      phoneNumber: '555-8003',
      relationship: 'Wife',
      avatarColor: const Color(0xFFE91E63),
    ),
    Contact(
      id: 'unknown',
      firstName: 'Blocked',
      lastName: 'Number',
      phoneNumber: '000-0000',
      relationship: 'Unknown',
      avatarColor: const Color(0xFF616161),
    ),
  ],
  conversations: [
    Conversation(
      id: 'conv_agent',
      contactId: 'agent',
      messages: [
        Message(
          id: 'msg1',
          conversationId: 'conv_agent',
          senderId: 'agent',
          content:
              'Everything is set for the safe house. We move you tomorrow.',
          timestamp: DateTime(2024, 10, 5, 14, 0),
        ),
        Message(
          id: 'msg2',
          conversationId: 'conv_agent',
          senderId: 'owner',
          content: 'And after I testify? New identity like we discussed?',
          timestamp: DateTime(2024, 10, 5, 14, 10),
        ),
        Message(
          id: 'msg3',
          conversationId: 'conv_agent',
          senderId: 'agent',
          content: 'Full witness protection. You and Maria start fresh.',
          timestamp: DateTime(2024, 10, 5, 14, 15),
        ),
      ],
    ),
    Conversation(
      id: 'conv_maria',
      contactId: 'maria',
      messages: [
        Message(
          id: 'msg4',
          conversationId: 'conv_maria',
          senderId: 'maria',
          content: 'I can\'t do this anymore, Carlos. I\'m scared.',
          timestamp: DateTime(2024, 10, 6, 20, 0),
        ),
        Message(
          id: 'msg5',
          conversationId: 'conv_maria',
          senderId: 'owner',
          content: 'Trust me. One more day and we\'re free.',
          timestamp: DateTime(2024, 10, 6, 20, 10),
        ),
        Message(
          id: 'msg6',
          conversationId: 'conv_maria',
          senderId: 'maria',
          content: 'Someone followed me today. Black SUV.',
          timestamp: DateTime(2024, 10, 6, 20, 15),
        ),
        Message(
          id: 'msg7',
          conversationId: 'conv_maria',
          senderId: 'owner',
          content:
              'Pack only essentials. Leave phone behind. Trust no one except Morrison.',
          timestamp: DateTime(2024, 10, 6, 20, 20),
        ),
      ],
    ),
    Conversation(
      id: 'conv_unknown',
      contactId: 'unknown',
      messages: [
        Message(
          id: 'msg8',
          conversationId: 'conv_unknown',
          senderId: 'unknown',
          content: 'Your testimony dies with you.',
          timestamp: DateTime(2024, 10, 6, 23, 0),
        ),
      ],
    ),
  ],
  photos: [
    Photo(
      id: 'photo1',
      title: 'Black SUV',
      dateTaken: DateTime(2024, 10, 6, 18, 0),
      description: 'Photo of suspicious vehicle',
    ),
    Photo(
      id: 'photo2',
      title: 'Plane Tickets',
      dateTaken: DateTime(2024, 10, 4),
      hotspots: [
        PhotoHotspot(
          id: 'hs1',
          x: 0.5,
          y: 0.5,
          description:
              'Two tickets to Buenos Aires for Oct 7th under fake names: "James and Elena Vargas"',
        ),
      ],
    ),
  ],
  notes: [
    Note(
      id: 'note1',
      title: 'Exit Plan',
      content:
          'Oct 7 - 6am flight to Buenos Aires\nNew names: James & Elena Vargas\nCash: \$10,000 (from safety deposit)\nContact in Argentina: Uncle Roberto\n\nLeave phones. Cut all ties. Disappear before trial.',
      createdAt: DateTime(2024, 10, 3),
      isLocked: true,
      password: 'freedom',
    ),
  ],
  callLog: [
    CallRecord(
      id: 'call1',
      contactId: 'agent',
      phoneNumber: '555-8002',
      type: CallType.incoming,
      timestamp: DateTime(2024, 10, 6, 9, 0),
      duration: const Duration(minutes: 10),
    ),
    CallRecord(
      id: 'call2',
      contactId: 'unknown',
      phoneNumber: '000-0000',
      type: CallType.incoming,
      timestamp: DateTime(2024, 10, 6, 23, 5),
      duration: Duration.zero,
    ),
  ],
  emails: [
    Email(
      id: 'email1',
      senderId: 'travel',
      senderEmail: 'confirm@airlinesecure.com',
      senderName: 'AirLine Secure',
      subject: 'Booking Confirmation',
      body:
          'Thank you for your booking!\n\nPassengers: James Vargas, Elena Vargas\nFlight: AS-442 to Buenos Aires\nDeparture: Oct 7, 6:00 AM\n\nPlease arrive 3 hours early.',
      timestamp: DateTime(2024, 10, 4),
    ),
  ],
  solution: CaseSolution(
    guiltyContactId: '',
    motive: 'Self-preservation - Carlos chose to run',
    method: 'Voluntarily fled to Argentina with wife under fake names',
    keyClueIds: ['note1', 'photo2', 'email1', 'msg7'],
    resolution:
        'Carlos wasn\'t abducted—he ran. The mob threats scared him into abandoning witness protection for his own escape plan. His note reveals the entire exit strategy: fake identities, Buenos Aires tickets, and cash. He and Maria flew out the morning he "vanished." The threatening message was real, but Carlos had already planned to disappear. He\'s safe but the Rosetti trial collapsed without his testimony.',
    options: [
      SolutionOption(
        contactId: '',
        label: 'Carlos fled voluntarily - hiding in Argentina',
        isCorrect: true,
        feedback:
            'Correct! The plane tickets, fake IDs, and exit plan note prove Carlos chose to run rather than testify. The mob threats were real but he escaped before they could act.',
      ),
      SolutionOption(
        contactId: 'unknown',
        label: 'The mob killed him',
        isCorrect: false,
        feedback:
            'The threatening message was real, but the plane tickets and exit plan show Carlos had already arranged his escape.',
      ),
      SolutionOption(
        contactId: 'agent',
        label: 'Agent Morrison is a mole who betrayed him',
        isCorrect: false,
        feedback:
            'Morrison appears to be legitimate FBI. Carlos simply didn\'t trust the system and made his own plan.',
      ),
    ],
  ),
);
