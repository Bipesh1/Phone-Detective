// Phone Detective - Case 07: The Accident... or Not?

import 'package:flutter/material.dart';
import '../../models/models.dart';

final case07AccidentOrNot = CaseData(
  caseNumber: 7,
  title: 'The Accident... or Not?',
  subtitle: 'A fatal car crash under suspicious circumstances',
  description:
      'A man died when his brakes failed. His wife\'s phone tells a different story.',
  scenario:
      'Harold Price died when his car crashed into a ravine - brake failure. His wife Eleanor stands to inherit \$1 million. Police found her phone. Some messages were deleted, but not well enough...',
  objective: 'Find out who sabotaged the car and why.',
  difficulty: CaseDifficulty.hard,
  themeColor: const Color(0xFFD84315),
  totalClues: 7,
  contacts: [
    Contact(
      id: 'eleanor',
      firstName: 'Eleanor',
      lastName: 'Price',
      phoneNumber: '555-7001',
      relationship: 'Phone Owner (Widow)',
      avatarColor: const Color(0xFF7B1FA2),
    ),
    Contact(
      id: 'mechanic',
      firstName: 'Ray',
      lastName: 'Costa',
      phoneNumber: '555-7002',
      relationship: 'Mechanic',
      avatarColor: const Color(0xFF455A64),
    ),
    Contact(
      id: 'sister',
      firstName: 'Martha',
      lastName: 'Price',
      phoneNumber: '555-7003',
      relationship: 'Harold\'s Sister',
      avatarColor: const Color(0xFF00897B),
    ),
    Contact(
      id: 'insurance',
      firstName: 'Life',
      lastName: 'Guard Insurance',
      phoneNumber: '555-7010',
      relationship: 'Insurance Company',
      avatarColor: const Color(0xFF1976D2),
    ),
  ],
  conversations: [
    Conversation(
      id: 'conv_mechanic',
      contactId: 'mechanic',
      messages: [
        Message(
          id: 'msg1',
          conversationId: 'conv_mechanic',
          senderId: 'owner',
          content: 'Is it done?',
          timestamp: DateTime(2024, 9, 10, 14, 0),
        ),
        Message(
          id: 'msg2',
          conversationId: 'conv_mechanic',
          senderId: 'mechanic',
          content: 'Yeah. Brake line will fail within a week, maybe less.',
          timestamp: DateTime(2024, 9, 10, 14, 10),
        ),
        Message(
          id: 'msg3',
          conversationId: 'conv_mechanic',
          senderId: 'owner',
          content: 'And it\'ll look like an accident?',
          timestamp: DateTime(2024, 9, 10, 14, 15),
        ),
        Message(
          id: 'msg4',
          conversationId: 'conv_mechanic',
          senderId: 'mechanic',
          content: 'Wear and tear. Happens all the time with old cars.',
          timestamp: DateTime(2024, 9, 10, 14, 20),
        ),
        Message(
          id: 'msg5',
          conversationId: 'conv_mechanic',
          senderId: 'owner',
          content: 'Good. Your \$10k is ready after the insurance pays.',
          timestamp: DateTime(2024, 9, 10, 14, 25),
        ),
        Message(
          id: 'msg6',
          conversationId: 'conv_mechanic',
          senderId: 'mechanic',
          content: 'Make it \$15k. This is risky.',
          timestamp: DateTime(2024, 9, 10, 14, 30),
          isDeleted: true,
        ),
        Message(
          id: 'msg7',
          conversationId: 'conv_mechanic',
          senderId: 'owner',
          content: 'Fine. But if you talk, we both go down.',
          timestamp: DateTime(2024, 9, 10, 14, 35),
          isDeleted: true,
        ),
      ],
    ),
    Conversation(
      id: 'conv_sister',
      contactId: 'sister',
      messages: [
        Message(
          id: 'msg8',
          conversationId: 'conv_sister',
          senderId: 'sister',
          content:
              'How could this happen? Harold was so careful with that car.',
          timestamp: DateTime(2024, 9, 15, 10, 0),
        ),
        Message(
          id: 'msg9',
          conversationId: 'conv_sister',
          senderId: 'owner',
          content: 'I know, it\'s tragic. The mechanic said brakes wore out.',
          timestamp: DateTime(2024, 9, 15, 10, 10),
        ),
      ],
    ),
  ],
  photos: [
    Photo(
      id: 'photo1',
      title: 'Insurance Policy',
      dateTaken: DateTime(2024, 9, 5),
      description: 'Photo of insurance policy',
      hotspots: [
        PhotoHotspot(
          id: 'hs1',
          x: 0.5,
          y: 0.6,
          description:
              'Policy shows \$1 million payout. Policy was increased just 3 months ago.',
        ),
      ],
    ),
    Photo(
      id: 'photo2',
      title: 'Mechanic Invoice',
      dateTaken: DateTime(2024, 9, 10),
    ),
  ],
  notes: [
    Note(
      id: 'note1',
      title: 'Budget',
      content:
          'Harold\'s death:\n- Insurance: \$1,000,000\n- Ray payment: -\$15,000\n- Debts cleared: -\$100,000\n- Remaining: \$1,525,000\n\nEnough to start over with Derek.',
      createdAt: DateTime(2024, 9, 8),
    ),
  ],
  callLog: [
    CallRecord(
      id: 'call1',
      contactId: 'mechanic',
      phoneNumber: '555-7002',
      type: CallType.outgoing,
      timestamp: DateTime(2024, 9, 5, 11, 0),
      duration: const Duration(minutes: 15),
    ),
    CallRecord(
      id: 'call2',
      contactId: 'insurance',
      phoneNumber: '555-7010',
      type: CallType.outgoing,
      timestamp: DateTime(2024, 9, 16, 9, 0),
      duration: const Duration(minutes: 20),
    ),
  ],
  emails: [
    Email(
      id: 'email1',
      senderId: 'insurance',
      senderEmail: 'claims@lginsurance.com',
      senderName: 'Life Guard Insurance',
      subject: 'Claim Received',
      body:
          'Dear Mrs. Price,\n\nWe have received your claim for Policy #LG-442891. An adjuster will contact you within 5 business days.\n\nOur condolences for your loss.',
      timestamp: DateTime(2024, 9, 16, 14, 0),
    ),
  ],
  solution: CaseSolution(
    guiltyContactId: 'eleanor',
    motive: 'Insurance money and affair',
    method: 'Hired mechanic to sabotage brakes',
    keyClueIds: ['msg2', 'msg5', 'note1', 'photo1'],
    resolution:
        'Eleanor Price conspired with mechanic Ray Costa to murder her husband Harold. The messages clearly show they planned the brake sabotage for \$15,000. The note reveals she was having an affair with someone named "Derek" and calculated her profits. The insurance policy increase 3 months prior shows premeditation. Both Eleanor and Ray have been arrested.',
    options: [
      SolutionOption(
        contactId: 'eleanor',
        label: 'Eleanor plotted with the mechanic',
        isCorrect: true,
        feedback:
            'Correct! The messages with Ray clearly show murder for hire, the deleted messages prove renegotiation, and her note shows financial planning and an affair motive.',
      ),
      SolutionOption(
        contactId: 'mechanic',
        label: 'Ray acted alone for payment',
        isCorrect: false,
        feedback:
            'Ray was involved but Eleanor initiated and planned everything. The messages show she approached him first.',
      ),
      SolutionOption(
        contactId: '',
        label: 'It was a genuine accident',
        isCorrect: false,
        feedback:
            'The explicit messages about sabotaging brakes and payment arrangements prove this was deliberate murder.',
      ),
    ],
  ),
);
