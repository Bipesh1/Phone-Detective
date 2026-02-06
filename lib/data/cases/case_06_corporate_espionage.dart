// Phone Detective - Case 06: Corporate Espionage

import 'package:flutter/material.dart';
import '../../models/models.dart';

final case06CorporateEspionage = CaseData(
  caseNumber: 6,
  title: 'Corporate Espionage',
  subtitle: 'Trade secrets are leaking',
  description: 'A tech company\'s designs are appearing at a competitor. Find the mole.',
  scenario: 'NovaTech\'s prototype designs keep appearing at rival company Apex. Security found a burner phone hidden in the office. It belongs to someone with high-level access. Trace the leak.',
  difficulty: CaseDifficulty.hard,
  themeColor: const Color(0xFF00897B),
  totalClues: 8,
  contacts: [
    Contact(id: 'insider', firstName: 'Unknown', lastName: 'User', phoneNumber: '555-6000', relationship: 'Phone Owner', avatarColor: const Color(0xFF607D8B)),
    Contact(id: 'apex', firstName: 'Apex', lastName: 'Contact', phoneNumber: '555-6001', relationship: 'Competitor', avatarColor: const Color(0xFFD32F2F)),
    Contact(id: 'handler', firstName: 'Mr.', lastName: 'X', phoneNumber: '555-6002', relationship: 'Unknown', avatarColor: const Color(0xFF455A64)),
  ],
  conversations: [
    Conversation(id: 'conv_handler', contactId: 'handler', messages: [
      Message(id: 'msg1', conversationId: 'conv_handler', senderId: 'handler', content: 'Did you get the Q4 designs?', timestamp: DateTime(2024, 8, 1, 23, 0)),
      Message(id: 'msg2', conversationId: 'conv_handler', senderId: 'owner', content: 'Uploading tonight. Server 7, folder marked "vacation pics"', timestamp: DateTime(2024, 8, 1, 23, 15)),
      Message(id: 'msg3', conversationId: 'conv_handler', senderId: 'handler', content: 'Good. Payment sent to usual account.', timestamp: DateTime(2024, 8, 1, 23, 20)),
      Message(id: 'msg4', conversationId: 'conv_handler', senderId: 'owner', content: 'I need out after this. It\'s getting risky.', timestamp: DateTime(2024, 8, 5, 22, 0)),
      Message(id: 'msg5', conversationId: 'conv_handler', senderId: 'handler', content: 'One more job. The Aurora project specs. Then you\'re free.', timestamp: DateTime(2024, 8, 5, 22, 10)),
    ]),
  ],
  photos: [
    Photo(id: 'photo1', title: 'Office Badge', dateTaken: DateTime(2024, 8, 1, 8, 0), hotspots: [PhotoHotspot(id: 'hs1', x: 0.5, y: 0.3, description: 'The badge shows "LEVEL 5 ACCESS - R&D DIVISION". Only 4 employees have this clearance.')]),
    Photo(id: 'photo2', title: 'Document Screenshot', dateTaken: DateTime(2024, 8, 1, 19, 0)),
  ],
  notes: [
    Note(id: 'note1', title: 'Drop Schedule', content: 'Tuesdays & Fridays - after 10pm\nServer: 7\nFolder: vacation\nPassword: aurora2024', createdAt: DateTime(2024, 7, 20)),
    Note(id: 'note2', title: 'Account', content: 'Bank: Offshore First\nAcct: 4421-8890-2234\nTotal received: \$175,000', createdAt: DateTime(2024, 8, 1)),
  ],
  callLog: [
    CallRecord(id: 'call1', contactId: 'handler', phoneNumber: '555-6002', type: CallType.incoming, timestamp: DateTime(2024, 8, 1, 22, 45), duration: const Duration(minutes: 5)),
    CallRecord(id: 'call2', contactId: 'apex', phoneNumber: '555-6001', type: CallType.outgoing, timestamp: DateTime(2024, 8, 3, 12, 0), duration: const Duration(minutes: 2)),
  ],
  emails: [],
  solution: CaseSolution(
    guiltyContactId: 'insider',
    motive: 'Money - \$175,000 received',
    method: 'Uploaded proprietary designs to hidden server folders',
    keyClueIds: ['photo1', 'note1', 'note2', 'msg2'],
    resolution: 'The phone belongs to Dr. Patricia Wells, one of only 4 employees with Level 5 R&D access. The badge photo, combined with server access logs from "Tuesday and Friday after 10pm" (matching her late-night "overtime"), and the \$175,000 in offshore payments prove her guilt. She confessed when confronted with the evidence.',
    options: [
      SolutionOption(contactId: 'insider', label: 'An R&D employee with Level 5 access', isCorrect: true, feedback: 'Correct! The badge photo shows Level 5 R&D access. Only 4 people have this. The schedule and payment records prove systematic espionage.'),
      SolutionOption(contactId: 'handler', label: 'Mr. X is an inside employee', isCorrect: false, feedback: 'Mr. X is the external handler/buyer. The mole is the phone owner who has R&D access.'),
      SolutionOption(contactId: '', label: 'It\'s a setup - phone was planted', isCorrect: false, feedback: 'The photos taken from inside R&D and the detailed server knowledge prove this is an actual insider.'),
    ],
  ),
);


