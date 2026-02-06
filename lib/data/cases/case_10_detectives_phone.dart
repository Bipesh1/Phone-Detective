// Phone Detective - Case 10: The Detective's Phone (Final Case)

import 'package:flutter/material.dart';
import '../../models/models.dart';

final case10DetectivesPhone = CaseData(
  caseNumber: 10,
  title: 'The Detective\'s Phone',
  subtitle: 'A phone from the future - your phone',
  description: 'This phone belongs to you. From tomorrow. Something terrible happens unless you stop it.',
  scenario: 'This is impossible. This phone... it\'s yours. But the date on the messages is tomorrow. There are crime scene photos that haven\'t happened yet. You have 24 hours to prevent a murder. Your own investigation skills will be tested.',
  difficulty: CaseDifficulty.veryHard,
  themeColor: const Color(0xFF6A1B9A),
  totalClues: 12,
  contacts: [
    Contact(id: 'you', firstName: 'Detective', lastName: 'Player', phoneNumber: '555-0001', relationship: 'You (Future)', avatarColor: const Color(0xFF6A1B9A)),
    Contact(id: 'chief', firstName: 'Chief', lastName: 'Reynolds', phoneNumber: '555-0010', relationship: 'Police Chief', avatarColor: const Color(0xFF1976D2)),
    Contact(id: 'target', firstName: 'Mayor', lastName: 'Harrison', phoneNumber: '555-0020', relationship: 'Future Victim', avatarColor: const Color(0xFF388E3C)),
    Contact(id: 'suspect', firstName: 'Officer', lastName: 'Drake', phoneNumber: '555-0030', relationship: 'Colleague', avatarColor: const Color(0xFFD32F2F)),
  ],
  conversations: [
    Conversation(id: 'conv_you', contactId: 'you', messages: [
      Message(id: 'msg1', conversationId: 'conv_you', senderId: 'you', content: 'If you\'re reading this, the device worked. I\'m you from tomorrow.', timestamp: DateTime(2024, 12, 16, 8, 0)),
      Message(id: 'msg2', conversationId: 'conv_you', senderId: 'you', content: 'Mayor Harrison will be assassinated at the Charity Gala tonight at 9 PM.', timestamp: DateTime(2024, 12, 16, 8, 5)),
      Message(id: 'msg3', conversationId: 'conv_you', senderId: 'you', content: 'The killer is someone on the security team. I couldn\'t stop it.', timestamp: DateTime(2024, 12, 16, 8, 10)),
      Message(id: 'msg4', conversationId: 'conv_you', senderId: 'you', content: 'Look at the photos. Look at ALL the cases you\'ve solved. The pattern is there.', timestamp: DateTime(2024, 12, 16, 8, 15)),
      Message(id: 'msg5', conversationId: 'conv_you', senderId: 'you', content: 'Trust no one at the department. One of us is compromised.', timestamp: DateTime(2024, 12, 16, 8, 20)),
    ]),
    Conversation(id: 'conv_chief', contactId: 'chief', messages: [
      Message(id: 'msg6', conversationId: 'conv_chief', senderId: 'chief', content: 'Great work on the Serial Pattern case. You saved that woman\'s life.', timestamp: DateTime(2024, 12, 15, 16, 0)),
      Message(id: 'msg7', conversationId: 'conv_chief', senderId: 'owner', content: 'Thanks Chief. But I keep feeling like I\'m missing something bigger.', timestamp: DateTime(2024, 12, 15, 16, 10)),
      Message(id: 'msg8', conversationId: 'conv_chief', senderId: 'chief', content: 'Take a break. You\'ve earned it. Come to the Charity Gala tonight.', timestamp: DateTime(2024, 12, 15, 16, 15)),
    ]),
    Conversation(id: 'conv_suspect', contactId: 'suspect', messages: [
      Message(id: 'msg9', conversationId: 'conv_suspect', senderId: 'suspect', content: 'Hey, I\'m on security detail for the Mayor tonight. Want to swap?', timestamp: DateTime(2024, 12, 15, 14, 0)),
      Message(id: 'msg10', conversationId: 'conv_suspect', senderId: 'owner', content: 'No thanks. I\'m off duty.', timestamp: DateTime(2024, 12, 15, 14, 10)),
      Message(id: 'msg11', conversationId: 'conv_suspect', senderId: 'suspect', content: 'Come on, you\'d be closer to the action. Don\'t you want to protect the Mayor personally?', timestamp: DateTime(2024, 12, 15, 14, 15)),
    ]),
  ],
  photos: [
    Photo(id: 'photo1', title: 'Crime Scene - Tomorrow', dateTaken: DateTime(2024, 12, 16, 21, 30), description: 'A photo of a crime scene that hasn\'t happened', hotspots: [PhotoHotspot(id: 'hs1', x: 0.3, y: 0.5, description: 'The Mayor lies on the floor. Time stamp: Tomorrow, 9:30 PM.')]),
    Photo(id: 'photo2', title: 'Security Roster', dateTaken: DateTime(2024, 12, 15), hotspots: [PhotoHotspot(id: 'hs2', x: 0.5, y: 0.4, description: 'Officer Drake is positioned closest to the Mayor\'s table.')]),
    Photo(id: 'photo3', title: 'Bank Statement', dateTaken: DateTime(2024, 12, 14), hotspots: [PhotoHotspot(id: 'hs3', x: 0.5, y: 0.6, description: 'Drake received \$100,000 from an offshore account last week.')]),
  ],
  notes: [
    Note(id: 'note1', title: 'The Pattern', content: 'Looking back at ALL your cases:\n- Case 3: Corporate rival revenge\n- Case 6: Money as motive (\$175k)\n- Case 7: Hired killer (mechanic)\n\nThe current killer was HIRED. Follow the money.\nDrake is in debt. Drake is on security. Drake received a wire transfer.\n\nSTOP DRAKE AT 9 PM.', createdAt: DateTime(2024, 12, 16)),
    Note(id: 'note2', title: 'What I Know Now', content: 'By the time I figured it out, it was too late. \nDrake shot the Mayor at 9:07 PM.\nThe crowd panicked. Drake escaped in the chaos.\nIf only I had checked his bank records BEFORE the gala.\n\nYou have this chance. Don\'t waste it.', createdAt: DateTime(2024, 12, 16, 6, 0)),
  ],
  callLog: [
    CallRecord(id: 'call1', contactId: 'chief', phoneNumber: '555-0010', type: CallType.missed, timestamp: DateTime(2024, 12, 16, 21, 15), duration: Duration.zero),
  ],
  emails: [
    Email(id: 'email1', senderId: 'bank', senderEmail: 'alerts@securebank.com', senderName: 'Secure Bank', subject: 'Large Transfer Alert - Drake, M.', body: 'FLAGGED TRANSACTION\n\nAccount: Officer M. Drake\nAmount: \$100,000.00\nSource: Offshore (Cayman Islands)\nDate: Dec 10, 2024\n\nThis transaction has been flagged for review.', timestamp: DateTime(2024, 12, 14, 9, 0)),
  ],
  solution: CaseSolution(
    guiltyContactId: 'suspect',
    motive: 'Hired assassin - \$100,000 payment',
    method: 'Will shoot Mayor at Charity Gala at 9 PM',
    keyClueIds: ['msg2', 'photo2', 'photo3', 'email1', 'note1'],
    resolution: 'Officer Drake was hired to assassinate Mayor Harrison. The \$100,000 wire transfer from an offshore account proves he was paid. The security roster shows he positioned himself closest to the target. Your future self sent this phone back as a warning. By identifying Drake before the gala, you can prevent the murder. This case connects the patterns from all previous cases: hired killers, money trails, and insider betrayal. You\'ve become the detective who can see patterns others miss. Case closed—before it even happened.',
    options: [
      SolutionOption(contactId: 'suspect', label: 'Officer Drake is the hired assassin', isCorrect: true, feedback: 'Correct! The bank transfer, security position, and your future self\'s warning all prove Drake is planning to assassinate the Mayor tonight. Alert the Chief NOW.'),
      SolutionOption(contactId: 'chief', label: 'Chief Reynolds is behind it', isCorrect: false, feedback: 'The Chief invited you to the gala but has no suspicious financial activity. The money trail leads to Drake.'),
      SolutionOption(contactId: '', label: 'This phone is a hoax', isCorrect: false, feedback: 'The bank records are real. The security roster is real. Whether time travel is real doesn\'t matter—the threat is genuine.'),
    ],
  ),
);


