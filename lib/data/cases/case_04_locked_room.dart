// Phone Detective - Case 04: Locked Room Mystery

import 'package:flutter/material.dart';
import '../../models/models.dart';

final case04LockedRoom = CaseData(
  caseNumber: 4,
  title: 'Locked Room Mystery',
  subtitle: 'Death in a locked apartment',
  description:
      'A woman found dead in a locked apartment. Was it suicide or murder?',
  scenario:
      'Victoria Lane was found dead in her locked apartment. The door was chained from inside. Police ruled it suicide, but her family suspects murder. This is her phone. The timestamps don\'t add up...',
  difficulty: CaseDifficulty.medium,
  themeColor: const Color(0xFF5D4037),
  totalClues: 7,
  contacts: [
    Contact(
      id: 'victoria',
      firstName: 'Victoria',
      lastName: 'Lane',
      phoneNumber: '555-4001',
      relationship: 'Victim',
      avatarColor: const Color(0xFF9C27B0),
    ),
    Contact(
      id: 'emily',
      firstName: 'Emily',
      lastName: 'Brooks',
      phoneNumber: '555-4002',
      relationship: 'Best Friend',
      avatarColor: const Color(0xFFE91E63),
    ),
    Contact(
      id: 'james',
      firstName: 'James',
      lastName: 'Turner',
      phoneNumber: '555-4003',
      relationship: 'Boyfriend',
      avatarColor: const Color(0xFF2196F3),
    ),
    Contact(
      id: 'mother',
      firstName: 'Carol',
      lastName: 'Lane',
      phoneNumber: '555-4010',
      relationship: 'Mother',
      avatarColor: const Color(0xFF4CAF50),
    ),
  ],
  conversations: [
    Conversation(
      id: 'conv_emily',
      contactId: 'emily',
      messages: [
        Message(
          id: 'msg1',
          conversationId: 'conv_emily',
          senderId: 'emily',
          content: 'Are you okay? You seemed off yesterday.',
          timestamp: DateTime(2024, 6, 15, 18, 0),
        ),
        Message(
          id: 'msg2',
          conversationId: 'conv_emily',
          senderId: 'owner',
          content: 'I\'m fine! Just tired. Big week at work.',
          timestamp: DateTime(2024, 6, 15, 18, 10),
        ),
        Message(
          id: 'msg3',
          conversationId: 'conv_emily',
          senderId: 'emily',
          content: 'Okay. Dinner Friday?',
          timestamp: DateTime(2024, 6, 15, 18, 15),
        ),
        Message(
          id: 'msg4',
          conversationId: 'conv_emily',
          senderId: 'owner',
          content: 'Definitely! I\'ll make reservations.',
          timestamp: DateTime(2024, 6, 15, 18, 20),
        ),
        // These messages were sent AFTER death timestamp
        Message(
          id: 'msg5',
          conversationId: 'conv_emily',
          senderId: 'owner',
          content: 'I can\'t do this anymore. Goodbye.',
          timestamp: DateTime(2024, 6, 16, 2, 30),
        ),
        Message(
          id: 'msg6',
          conversationId: 'conv_emily',
          senderId: 'owner',
          content: 'Tell my mom I love her.',
          timestamp: DateTime(2024, 6, 16, 2, 35),
        ),
      ],
    ),
    Conversation(
      id: 'conv_james',
      contactId: 'james',
      messages: [
        Message(
          id: 'msg7',
          conversationId: 'conv_james',
          senderId: 'james',
          content: 'We need to talk about the key.',
          timestamp: DateTime(2024, 6, 14, 20, 0),
        ),
        Message(
          id: 'msg8',
          conversationId: 'conv_james',
          senderId: 'owner',
          content: 'What key?',
          timestamp: DateTime(2024, 6, 14, 20, 5),
        ),
        Message(
          id: 'msg9',
          conversationId: 'conv_james',
          senderId: 'james',
          content: 'The spare key you gave me. I still have it.',
          timestamp: DateTime(2024, 6, 14, 20, 10),
        ),
        Message(
          id: 'msg10',
          conversationId: 'conv_james',
          senderId: 'owner',
          content: 'Please return it. We\'re over.',
          timestamp: DateTime(2024, 6, 14, 20, 15),
        ),
      ],
    ),
  ],
  photos: [
    Photo(
      id: 'photo1',
      title: 'Apartment Living Room',
      dateTaken: DateTime(2024, 6, 10),
      location: 'Home',
    ),
    Photo(
      id: 'photo2',
      title: 'Victoria and Emily',
      dateTaken: DateTime(2024, 6, 12),
      location: 'Cafe',
    ),
    Photo(
      id: 'photo3',
      title: 'Chain Lock',
      dateTaken: DateTime(2024, 6, 5),
      description: 'Victoria had just installed this new chain lock',
      hotspots: [
        PhotoHotspot(
          id: 'hs1',
          x: 0.5,
          y: 0.5,
          description:
              'The chain lock can be manipulated from outside using a string. There are videos online showing this technique.',
        ),
      ],
    ),
  ],
  notes: [
    Note(
      id: 'note1',
      title: 'Suicide Note',
      content:
          'I can\'t take the pain anymore. This is the only way out. Don\'t blame yourselves. I\'m finally at peace.\n\n- Victoria',
      createdAt: DateTime(2024, 6, 16, 1, 0),
    ),
    Note(
      id: 'note2',
      title: 'Diary Entry',
      content:
          'June 15 - Great day at work! Got the promotion! Emily and I are having dinner Friday. Life is good. Can\'t wait to tell Mom the news.',
      createdAt: DateTime(2024, 6, 15, 22, 0),
    ),
  ],
  callLog: [
    CallRecord(
      id: 'call1',
      contactId: 'mother',
      phoneNumber: '555-4010',
      type: CallType.outgoing,
      timestamp: DateTime(2024, 6, 15, 19, 0),
      duration: const Duration(minutes: 15),
    ),
    CallRecord(
      id: 'call2',
      contactId: 'emily',
      phoneNumber: '555-4002',
      type: CallType.outgoing,
      timestamp: DateTime(2024, 6, 15, 21, 30),
      duration: const Duration(minutes: 8),
    ),
  ],
  emails: [
    Email(
      id: 'email1',
      senderId: 'work',
      senderEmail: 'hr@company.com',
      senderName: 'HR Department',
      subject: 'Congratulations on Your Promotion!',
      body:
          'Dear Victoria,\n\nWe are pleased to inform you that you have been promoted to Senior Manager. Your new position begins July 1st.\n\nCongratulations!',
      timestamp: DateTime(2024, 6, 15, 16, 0),
    ),
  ],
  solution: CaseSolution(
    guiltyContactId: 'emily',
    motive: 'Jealousy over Victoria\'s success',
    method:
        'Strangled Victoria, used string to lock chain from outside, sent fake suicide messages',
    keyClueIds: ['msg5', 'note2', 'email1', 'photo3'],
    resolution:
        'Emily Brooks murdered Victoria out of jealousy. The "suicide" messages were sent at 2:30 AM—but Victoria\'s diary shows she was happy about her promotion hours earlier. The medical examiner estimated death around midnight, BEFORE the messages. Emily had a key (Victoria mentioned giving one to her "in case"). She used the string-and-chain technique shown online. The writing style in the "suicide note" doesn\'t match Victoria\'s actual diary entries.',
    options: [
      SolutionOption(
        contactId: 'james',
        label: 'James Turner - used his spare key',
        isCorrect: false,
        feedback:
            'James had a key but returned it before the murder. Security footage shows him at a bar that night.',
      ),
      SolutionOption(
        contactId: 'emily',
        label: 'Emily Brooks - staged the suicide',
        isCorrect: true,
        feedback:
            'Correct! The timestamps prove messages were sent after death. Emily knew about the chain lock, had key access, and the "suicide note" doesn\'t match Victoria\'s happy diary entries.',
      ),
      SolutionOption(
        contactId: '',
        label: 'It was actually suicide',
        isCorrect: false,
        feedback:
            'The timeline doesn\'t work. Victoria was excited about her promotion and made dinner plans. The messages were sent after the estimated time of death.',
      ),
    ],
  ),
);


