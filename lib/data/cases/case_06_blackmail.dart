// Phone Detective - Case 06: The Blackmail Files

import 'package:flutter/material.dart';
import '../../models/models.dart';

final case06Blackmail = CaseData(
  caseNumber: 6,
  title: 'The Blackmail Files',
  subtitle: 'A CEO found dead. Secrets in every app.',
  description:
      'A tech CEO was murdered in his penthouse. His phone contains evidence of blackmail, affairs, and corporate espionage.',
  scenario:
      'Marcus Chen, CEO of NexTech Industries, was found dead with a gunshot wound. The police ruled it suicide, but his assistant claims he was being blackmailed. You have his phone. Four files are password-protected. Use the clues to unlock the truth.',
  objective: 'Unlock all protected files and identify the blackmailer.',
  difficulty: CaseDifficulty.hard,
  themeColor: const Color(0xFF1A237E),
  totalClues: 3,
  hints: [
    "Each locked file has a clue. Search carefully across all apps.",
    "Some passwords are names, others are numbers.",
    "Pay attention to dates and timestamps.",
  ],
  contacts: [
    Contact(
      id: 'marcus',
      firstName: 'Marcus',
      lastName: 'Chen',
      phoneNumber: '555-1000',
      relationship: 'Phone Owner (Victim)',
      avatarColor: const Color(0xFF1976D2),
      birthday: '1978-05-12',
    ),
    Contact(
      id: 'vanessa',
      firstName: 'Vanessa',
      lastName: 'Torres',
      phoneNumber: '555-1001',
      relationship: 'Executive Assistant',
      avatarColor: const Color(0xFFE91E63),
      birthday: '1985-03-08',
    ),
    Contact(
      id: 'derek',
      firstName: 'Derek',
      lastName: 'Wu',
      phoneNumber: '555-1002',
      relationship: 'CFO',
      avatarColor: const Color(0xFF424242),
      birthday: '1980-11-23',
    ),
    Contact(
      id: 'sophia',
      firstName: 'Sophia',
      lastName: 'Lin',
      phoneNumber: '555-1003',
      relationship: 'Mistress',
      avatarColor: const Color(0xFF9C27B0),
      birthday: '1992-07-19',
    ),
  ],
  conversations: [
    Conversation(
      id: 'conv_vanessa',
      contactId: 'vanessa',
      messages: [
        Message(
          id: 'm1',
          conversationId: 'conv_vanessa',
          senderId: 'vanessa',
          content: 'Marcus, I found the USB drive. It was in the safe.',
          timestamp: DateTime.utc(2024, 8, 15, 9, 0),
        ),
        Message(
          id: 'm2',
          conversationId: 'conv_vanessa',
          senderId: 'owner',
          content: "Good. Don't tell anyone. Not even Derek.",
          timestamp: DateTime.utc(2024, 8, 15, 9, 5),
        ),
        Message(
          id: 'm3',
          conversationId: 'conv_vanessa',
          senderId: 'vanessa',
          content: "What's on it?",
          timestamp: DateTime.utc(2024, 8, 15, 9, 10),
        ),
        Message(
          id: 'm4',
          conversationId: 'conv_vanessa',
          senderId: 'owner',
          content: "Evidence. If it gets out, I'm finished.",
          timestamp: DateTime.utc(2024, 8, 15, 9, 12),
        ),
        Message(
          id: 'm5',
          conversationId: 'conv_vanessa',
          senderId: 'vanessa',
          content: "I locked it back. Combination is November 23.",
          timestamp: DateTime.utc(2024, 8, 15, 9, 15),
        ),
        Message(
          id: 'm6',
          conversationId: 'conv_vanessa',
          senderId: 'owner',
          content: "Wait, that's not MY birthday...",
          timestamp: DateTime.utc(2024, 8, 15, 9, 16),
          isLocked: true,
          password: 'VANESSA',
          passwordHint: "Who keeps the secrets safe? Her name unlocks this.",
        ),
      ],
    ),
    Conversation(
      id: 'conv_derek',
      contactId: 'derek',
      messages: [
        Message(
          id: 'm7',
          conversationId: 'conv_derek',
          senderId: 'derek',
          content: "We need to talk. About the offshore accounts.",
          timestamp: DateTime.utc(2024, 8, 10, 15, 0),
        ),
        Message(
          id: 'm8',
          conversationId: 'conv_derek',
          senderId: 'owner',
          content: "Not over text.",
          timestamp: DateTime.utc(2024, 8, 10, 15, 5),
        ),
      ],
    ),
    Conversation(
      id: 'conv_sophia',
      contactId: 'sophia',
      messages: [
        Message(
          id: 'm9',
          conversationId: 'conv_sophia',
          senderId: 'sophia',
          content: "I can't do this anymore. Your wife is getting suspicious.",
          timestamp: DateTime.utc(2024, 8, 10, 22, 0),
        ),
        Message(
          id: 'm10',
          conversationId: 'conv_sophia',
          senderId: 'owner',
          content: "Just a little longer. After the merger, we'll go public.",
          timestamp: DateTime.utc(2024, 8, 10, 22, 5),
        ),
      ],
    ),
  ],
  photos: [],
  notes: [
    Note(
      id: 'nt1',
      title: 'Meeting_Aug10.txt',
      content:
          "Meeting with Derek (CFO):\n- Discussed offshore accounts\n- He knows about the embezzlement\n- Threatened to go to the board unless I pay \$500K\n- Wire transfer scheduled for Aug 20",
      createdAt: DateTime.utc(2024, 8, 10, 16, 0),
      isLocked: true,
      password: '1123',
      passwordHint: "The safe code was mentioned in a private conversation.",
    ),
    Note(
      id: 'nt2',
      title: 'Voicemail_Transcript.txt',
      content:
          "Transcript of Unknown Caller (Aug 14, 11:45 PM):\n\"Marcus, this is your last warning. Pay me \$2 million or I send the affair photos to your wife AND the board. You have 48 hours. The account number is in the email I sent.\"",
      createdAt: DateTime.utc(2024, 8, 15, 8, 0),
      isLocked: true,
      password: '081445',
      passwordHint: "The timestamp of the threat is the key.",
    ),
    Note(
      id: 'nt3',
      title: 'BLACKMAILER_IDENTITY.txt',
      content:
          "I figured it out.\n\nThe blackmailer is Derek Wu (CFO).\n\nProof:\n1. The \"affair photos\" threat matches the camera timestamps from his office.\n2. The offshore account in the threatening email is registered to a shell company he controls.\n3. Vanessa overheard him on the phone saying \"Chen won't last the week.\"\n\nI confronted him tonight. He pulled a gun. I'm hiding in the bathroom. If you're reading this, I'm already dead.",
      createdAt: DateTime.utc(2024, 8, 15, 23, 55),
      isLocked: true,
      password: '0512',
      passwordHint: "The victim's origin date. MMDD format.",
    ),
  ],
  callLog: [
    CallRecord(
      id: 'cl1',
      contactId: 'derek',
      phoneNumber: '555-1002',
      type: CallType.outgoing,
      timestamp: DateTime.utc(2024, 8, 15, 20, 0),
      duration: const Duration(seconds: 120),
    ),
    CallRecord(
      id: 'cl2',
      contactId: 'unknown',
      phoneNumber: 'Unknown',
      type: CallType.voicemail,
      timestamp: DateTime.utc(2024, 8, 14, 23, 45),
      duration: const Duration(seconds: 22),
      transcription:
          "Marcus, this is your last warning. Pay me \$2 million or I send the affair photos to your wife AND the board. You have 48 hours.",
    ),
  ],
  emails: [
    Email(
      id: 'em1',
      senderId: 'derek',
      senderEmail: 'accounting@nextech.com',
      senderName: 'Derek Wu',
      subject: 'Quarterly Report',
      body:
          "Attached is the Q3 financial report. Let me know if you need clarification on the offshore transfers.",
      timestamp: DateTime.utc(2024, 8, 10, 10, 0),
    ),
    Email(
      id: 'em2',
      senderId: 'unknown',
      senderEmail: 'anonymous2024@protonmail.com',
      senderName: 'Anonymous',
      subject: 'Wire Instructions',
      body:
          "Account: CH-9876-5432-1111\nBank: Zurich International\nBeneficiary: Phoenix Holdings LLC\n\nYou have 48 hours.",
      timestamp: DateTime.utc(2024, 8, 14, 23, 50),
      isLocked: true,
      password: 'DEREK',
      passwordHint: "Follow the money. Who handles the accounts?",
    ),
  ],
  solution: CaseSolution(
    guiltyContactId: 'derek',
    motive: 'Blackmail and Cover-Up',
    method: 'Gunshot (Staged as Suicide)',
    keyClueIds: ['nt3', 'em2', 'cl2'],
    resolution:
        "Derek Wu (CFO) is the killer. The final locked note (nt3) contains Marcus's dying confession that Derek was blackmailing him over affair photos and embezzlement. The threatening voicemail (cl2) matches the timeline, and the offshore account in the anonymous email (em2) traces back to Derek's shell company. Marcus confronted Derek, and Derek shot him to silence him permanently.",
    options: [
      SolutionOption(
        contactId: 'derek',
        label: 'Derek Wu - CFO',
        isCorrect: true,
        feedback:
            "Correct. You unlocked all the protected files and found Marcus's final confession identifying Derek as the blackmailer and killer.",
      ),
      SolutionOption(
        contactId: 'sophia',
        label: 'Sophia Lin - Mistress',
        isCorrect: false,
        feedback:
            "Sophia was having an affair with Marcus, but she had no motive to kill him. She wanted him to leave his wife, not die.",
      ),
      SolutionOption(
        contactId: 'vanessa',
        label: 'Vanessa Torres - Assistant',
        isCorrect: false,
        feedback:
            "Vanessa was loyal to Marcus. The locked message proves she was trying to protect his secrets, not harm him.",
      ),
    ],
  ),
);
