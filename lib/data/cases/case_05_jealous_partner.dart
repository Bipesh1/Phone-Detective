// Phone Detective - Case 05: The Jealous Partner

import 'package:flutter/material.dart';
import '../../models/models.dart';

final case05JealousPartner = CaseData(
  caseNumber: 5,
  title: 'The Jealous Partner',
  subtitle: 'Suspicion of an affair gone wrong',
  description: 'A domestic incident with a twist. Is everything as it seems?',
  scenario:
      'Ryan Miller\'s wife accused him of having an affair after finding suspicious texts and calls to an "unknown number." There was a confrontation. But the evidence tells a different story. His phone holds the truth.',
  objective: 'Investigate the suspicious activity and uncover the truth.',
  difficulty: CaseDifficulty.medium,
  themeColor: const Color(0xFFD81B60),
  totalClues: 6,
  contacts: [
    Contact(
      id: 'ryan',
      firstName: 'Ryan',
      lastName: 'Miller',
      phoneNumber: '555-5001',
      relationship: 'Phone Owner',
      avatarColor: const Color(0xFF1976D2),
    ),
    Contact(
      id: 'sarah',
      firstName: 'Sarah',
      lastName: 'Miller',
      phoneNumber: '555-5002',
      relationship: 'Wife',
      avatarColor: const Color(0xFFE91E63),
    ),
    Contact(
      id: 'unknown',
      firstName: 'Party',
      lastName: 'Planner',
      phoneNumber: '555-5099',
      relationship: 'Unknown',
      avatarColor: const Color(0xFF9C27B0),
    ),
    Contact(
      id: 'brother',
      firstName: 'Tom',
      lastName: 'Miller',
      phoneNumber: '555-5010',
      relationship: 'Brother',
      avatarColor: const Color(0xFF4CAF50),
    ),
    Contact(
      id: 'jeweler',
      firstName: 'Diamond',
      lastName: 'Dreams',
      phoneNumber: '555-5088',
      relationship: 'Jewelry Store',
      avatarColor: const Color(0xFFFF9800),
    ),
  ],
  conversations: [
    Conversation(
      id: 'conv_unknown',
      contactId: 'unknown',
      messages: [
        Message(
          id: 'msg1',
          conversationId: 'conv_unknown',
          senderId: 'owner',
          content: 'Is everything set for the 20th?',
          timestamp: DateTime(2024, 7, 10, 12, 0),
        ),
        Message(
          id: 'msg2',
          conversationId: 'conv_unknown',
          senderId: 'unknown',
          content: 'Yes! Venue booked, catering confirmed. 50 guests.',
          timestamp: DateTime(2024, 7, 10, 12, 10),
        ),
        Message(
          id: 'msg3',
          conversationId: 'conv_unknown',
          senderId: 'owner',
          content: 'She has no idea. This will be perfect.',
          timestamp: DateTime(2024, 7, 10, 12, 15),
        ),
        Message(
          id: 'msg4',
          conversationId: 'conv_unknown',
          senderId: 'unknown',
          content: 'The surprise theme looks amazing. She\'ll cry happy tears!',
          timestamp: DateTime(2024, 7, 10, 12, 20),
        ),
      ],
    ),
    Conversation(
      id: 'conv_brother',
      contactId: 'brother',
      messages: [
        Message(
          id: 'msg5',
          conversationId: 'conv_brother',
          senderId: 'owner',
          content: 'Bro, I need your help keeping Sarah busy on the 20th',
          timestamp: DateTime(2024, 7, 12, 18, 0),
        ),
        Message(
          id: 'msg6',
          conversationId: 'conv_brother',
          senderId: 'brother',
          content: 'For the anniversary party? I\'m on it.',
          timestamp: DateTime(2024, 7, 12, 18, 10),
        ),
        Message(
          id: 'msg7',
          conversationId: 'conv_brother',
          senderId: 'owner',
          content:
              'Thanks. The ring is ready too. Renewing our vows after 10 years.',
          timestamp: DateTime(2024, 7, 12, 18, 15),
        ),
      ],
    ),
    Conversation(
      id: 'conv_sarah',
      contactId: 'sarah',
      messages: [
        Message(
          id: 'msg8',
          conversationId: 'conv_sarah',
          senderId: 'sarah',
          content: 'Who is "Party Planner" in your phone?',
          timestamp: DateTime(2024, 7, 15, 20, 0),
        ),
        Message(
          id: 'msg9',
          conversationId: 'conv_sarah',
          senderId: 'owner',
          content: 'Just a work thing, don\'t worry about it',
          timestamp: DateTime(2024, 7, 15, 20, 5),
        ),
        Message(
          id: 'msg10',
          conversationId: 'conv_sarah',
          senderId: 'sarah',
          content:
              'You\'ve been lying to me. I SAW the texts. "She has no idea"?!',
          timestamp: DateTime(2024, 7, 15, 20, 10),
        ),
        Message(
          id: 'msg11',
          conversationId: 'conv_sarah',
          senderId: 'owner',
          content: 'Sarah, please, you don\'t understand!',
          timestamp: DateTime(2024, 7, 15, 20, 11),
        ),
      ],
    ),
  ],
  photos: [
    Photo(
      id: 'photo1',
      title: 'Venue Photos',
      dateTaken: DateTime(2024, 7, 8),
      location: 'Lakeside Resort',
      isHidden: true,
    ),
    Photo(
      id: 'photo2',
      title: 'Anniversary Ring',
      dateTaken: DateTime(2024, 7, 12),
      isHidden: true,
      hotspots: [
        PhotoHotspot(
          id: 'hs1',
          x: 0.5,
          y: 0.5,
          description:
              'A beautiful diamond ring with "10 Years" engraved inside.',
        ),
      ],
    ),
    Photo(
      id: 'photo3',
      title: 'Guest List',
      dateTaken: DateTime(2024, 7, 5),
      isHidden: true,
    ),
  ],
  notes: [
    Note(
      id: 'note1',
      title: 'Anniversary Plan',
      content:
          'July 20 - Our 10th Anniversary\n- Surprise party at Lakeside\n- Renew vows\n- Give her the ring\n- Montage video of our years together\n- Keep it SECRET!',
      createdAt: DateTime(2024, 7, 1),
      isLocked: true,
      password: 'anniversary',
    ),
  ],
  callLog: [
    CallRecord(
      id: 'call1',
      contactId: 'unknown',
      phoneNumber: '555-5099',
      type: CallType.outgoing,
      timestamp: DateTime(2024, 7, 10, 11, 0),
      duration: const Duration(minutes: 20),
    ),
    CallRecord(
      id: 'call2',
      contactId: 'unknown',
      phoneNumber: '555-5099',
      type: CallType.outgoing,
      timestamp: DateTime(2024, 7, 14, 15, 0),
      duration: const Duration(minutes: 10),
    ),
    CallRecord(
      id: 'call3',
      contactId: 'jeweler',
      phoneNumber: '555-5088',
      type: CallType.outgoing,
      timestamp: DateTime(2024, 7, 12, 14, 0),
      duration: const Duration(minutes: 5),
    ),
  ],
  emails: [
    Email(
      id: 'email1',
      senderId: 'jeweler',
      senderEmail: 'orders@diamonddreams.com',
      senderName: 'Diamond Dreams',
      subject: 'Your Custom Ring is Ready!',
      body:
          'Dear Mr. Miller,\n\nYour custom anniversary ring (Order #4521) is ready for pickup. The engraving "10 Years - Forever" came out beautifully.\n\nThank you for choosing Diamond Dreams!',
      timestamp: DateTime(2024, 7, 12, 10, 0),
    ),
  ],
  solution: CaseSolution(
    guiltyContactId: '',
    motive: 'No crime - misunderstanding',
    method: 'N/A',
    keyClueIds: ['msg4', 'msg7', 'email1', 'note1'],
    resolution:
        'There was no affair! Ryan was planning a surprise 10th anniversary party and vow renewal for Sarah. The "unknown" contact was a party planner, and the secret texts were about the surprise. The hidden photos show venue prep, the ring, and guest list. The locked note contains the full plan. Sarah misunderstood the secrecy. This case is a reminder that things aren\'t always what they seem.',
    options: [
      SolutionOption(
        contactId: 'ryan',
        label: 'Ryan was cheating',
        isCorrect: false,
        feedback:
            'Look more carefully at the messages. "Party Planner"? "50 guests"? "Happy tears"? This isn\'t an affair.',
      ),
      SolutionOption(
        contactId: '',
        label: 'No affair - it was a surprise party',
        isCorrect: true,
        feedback:
            'Correct! Ryan was planning a surprise anniversary party and vow renewal. The jeweler email confirms the ring, and the hidden note reveals the full plan.',
      ),
      SolutionOption(
        contactId: 'unknown',
        label: 'The "Party Planner" is the other woman',
        isCorrect: false,
        feedback:
            'Read the messages carefully. They\'re discussing venues, catering, and guests. This is clearly event planning.',
      ),
    ],
  ),
);
