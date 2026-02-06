// Phone Detective - Case 02: Office Theft

import 'package:flutter/material.dart';
import '../../models/models.dart';

final case02OfficeTheft = CaseData(
  caseNumber: 2,
  title: 'Office Theft',
  subtitle: 'A laptop stolen from the office',
  description: 'A laptop containing sensitive data was stolen. The suspect\'s phone was found by security.',
  scenario: 'TechCorp reported a stolen laptop from the 5th floor. Security found this phone near the fire exit. It belongs to Marcus Reed, an employee with access to that floor. But is he the thief, or is he being framed?',
  difficulty: CaseDifficulty.easy,
  themeColor: const Color(0xFF1976D2),
  totalClues: 6,
  contacts: [
    Contact(id: 'marcus', firstName: 'Marcus', lastName: 'Reed', phoneNumber: '555-2001', email: 'marcus.r@techcorp.com', relationship: 'Phone Owner', avatarColor: const Color(0xFF455A64)),
    Contact(id: 'lisa', firstName: 'Lisa', lastName: 'Chang', phoneNumber: '555-2002', relationship: 'Coworker', avatarColor: const Color(0xFFE91E63)),
    Contact(id: 'pawnshop', firstName: 'Quick', lastName: 'Cash Pawn', phoneNumber: '555-7777', relationship: 'Pawn Shop', avatarColor: const Color(0xFFFF9800)),
    Contact(id: 'landlord', firstName: 'Mr.', lastName: 'Patterson', phoneNumber: '555-2010', relationship: 'Landlord', avatarColor: const Color(0xFF795548)),
    Contact(id: 'brother', firstName: 'Kevin', lastName: 'Reed', phoneNumber: '555-2020', relationship: 'Brother', avatarColor: const Color(0xFF4CAF50)),
  ],
  conversations: [
    Conversation(id: 'conv_lisa', contactId: 'lisa', messages: [
      Message(id: 'msg1', conversationId: 'conv_lisa', senderId: 'lisa', content: 'Hey, HR is doing layoffs next week', timestamp: DateTime(2024, 4, 10, 11, 0)),
      Message(id: 'msg2', conversationId: 'conv_lisa', senderId: 'owner', content: 'What? Are we on the list?', timestamp: DateTime(2024, 4, 10, 11, 5)),
      Message(id: 'msg3', conversationId: 'conv_lisa', senderId: 'lisa', content: 'I don\'t know. But I heard finance team is getting cut.', timestamp: DateTime(2024, 4, 10, 11, 10)),
    ]),
    Conversation(id: 'conv_pawn', contactId: 'pawnshop', messages: [
      Message(id: 'msg4', conversationId: 'conv_pawn', senderId: 'owner', content: 'How much do you pay for laptops?', timestamp: DateTime(2024, 4, 12, 19, 30)),
      Message(id: 'msg5', conversationId: 'conv_pawn', senderId: 'pawnshop', content: 'Depends on condition. Bring it in, we\'ll look at it.', timestamp: DateTime(2024, 4, 12, 19, 45)),
      Message(id: 'msg6', conversationId: 'conv_pawn', senderId: 'owner', content: 'Dell business laptop, good condition. How much roughly?', timestamp: DateTime(2024, 4, 12, 19, 50)),
      Message(id: 'msg7', conversationId: 'conv_pawn', senderId: 'pawnshop', content: '\$100-400. Need serial number and ID.', timestamp: DateTime(2024, 4, 12, 20, 0)),
    ]),
    Conversation(id: 'conv_landlord', contactId: 'landlord', messages: [
      Message(id: 'msg8', conversationId: 'conv_landlord', senderId: 'landlord', content: 'Marcus, rent is 2 weeks overdue. Final notice.', timestamp: DateTime(2024, 4, 11, 9, 0)),
      Message(id: 'msg9', conversationId: 'conv_landlord', senderId: 'owner', content: 'I know, I\'m sorry. I\'ll have it by Friday, I promise.', timestamp: DateTime(2024, 4, 11, 9, 30)),
      Message(id: 'msg10', conversationId: 'conv_landlord', senderId: 'landlord', content: 'That\'s what you said last week. Three days or eviction.', timestamp: DateTime(2024, 4, 11, 10, 0)),
    ]),
    Conversation(id: 'conv_brother', contactId: 'brother', messages: [
      Message(id: 'msg11', conversationId: 'conv_brother', senderId: 'brother', content: 'Bro, I need your help', timestamp: DateTime(2024, 4, 12, 14, 0)),
      Message(id: 'msg12', conversationId: 'conv_brother', senderId: 'owner', content: 'What now?', timestamp: DateTime(2024, 4, 12, 14, 10)),
      Message(id: 'msg13', conversationId: 'conv_brother', senderId: 'brother', content: 'I owe some people money. \$100. By tomorrow or they\'ll hurt me.', timestamp: DateTime(2024, 4, 12, 14, 15)),
      Message(id: 'msg14', conversationId: 'conv_brother', senderId: 'owner', content: 'I don\'t have that kind of money!', timestamp: DateTime(2024, 4, 12, 14, 20)),
      Message(id: 'msg15', conversationId: 'conv_brother', senderId: 'brother', content: 'Please Marcus. I\'m desperate.', timestamp: DateTime(2024, 4, 12, 14, 25)),
    ]),
  ],
  photos: [
    Photo(id: 'photo1', title: 'Office Layout', dateTaken: DateTime(2024, 4, 10, 12, 0), location: 'TechCorp 5th Floor', description: 'Photo of the office floor plan'),
    Photo(id: 'photo2', title: 'Server Room Door', dateTaken: DateTime(2024, 4, 11, 18, 30), location: 'TechCorp 5th Floor'),
    Photo(id: 'photo3', title: 'Fire Exit Route', dateTaken: DateTime(2024, 4, 12, 17, 45), location: 'TechCorp Stairwell'),
  ],
  notes: [
    Note(id: 'note1', title: 'Money Needed', content: 'Rent: \$100 overdue\nKevin debt: \$100\nTotal: \$1300\n\nOptions:\n- Sell old laptop \$100?\n- Ask mom? No.\n- Work laptop worth ~\$100...', createdAt: DateTime(2024, 4, 12, 15, 0)),
  ],
  callLog: [
    CallRecord(id: 'call1', contactId: 'pawnshop', phoneNumber: '555-7777', type: CallType.outgoing, timestamp: DateTime(2024, 4, 12, 16, 0), duration: const Duration(minutes: 3)),
    CallRecord(id: 'call2', contactId: 'brother', phoneNumber: '555-2020', type: CallType.incoming, timestamp: DateTime(2024, 4, 12, 18, 30), duration: const Duration(minutes: 10)),
  ],
  emails: [
    Email(id: 'email1', senderId: 'hr', senderEmail: 'hr@techcorp.com', senderName: 'TechCorp HR', subject: 'Performance Review Reminder', body: 'Dear Marcus,\n\nYour annual performance review is scheduled for April 20th. Please prepare your self-assessment.\n\nBest,\nHR Team', timestamp: DateTime(2024, 4, 8)),
  ],
  solution: CaseSolution(
    guiltyContactId: 'marcus',
    motive: 'Financial desperation',
    method: 'Stole laptop to pawn for money',
    keyClueIds: ['note1', 'msg4', 'msg8', 'photo3'],
    resolution: 'Marcus Reed stole the laptop due to severe financial pressure. His note reveals he was considering it, and his texts with the pawn shop show premeditation. The landlord threats and brother\'s gambling debts pushed him over the edge. He confessed when confronted with the evidence.',
    options: [
      SolutionOption(contactId: 'marcus', label: 'Marcus Reed stole it for money', isCorrect: true, feedback: 'Correct! The financial pressure from rent and his brother\'s debt, combined with the pawn shop messages and his notes, prove premeditated theft.'),
      SolutionOption(contactId: 'lisa', label: 'Lisa Chang is framing Marcus', isCorrect: false, feedback: 'There\'s no evidence Lisa was involved. Her messages only discussed layoff rumors.'),
      SolutionOption(contactId: 'brother', label: 'Kevin Reed took it, not Marcus', isCorrect: false, feedback: 'Kevin asked for money but there\'s no evidence he entered the office. The photos on Marcus\'s phone show he scouted the location.'),
    ],
  ),
);


