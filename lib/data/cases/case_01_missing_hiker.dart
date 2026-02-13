// Phone Detective - Case 01: The Missing Hiker

import 'package:flutter/material.dart';
import '../../models/models.dart';

final case01MissingHiker = CaseData(
  caseNumber: 1,
  title: 'The Missing Hiker',
  subtitle: 'A phone found on a hiking trail',
  description:
      'A phone was found on a remote hiking trail. The owner, Sarah Chen, hasn\'t returned. Is it an accident or something more sinister?',
  scenario:
      'A ranger found this phone near Eagle Peak Trail. The owner, Sarah Chen, was part of a hiking group that set out three days ago. She\'s the only one who hasn\'t returned. The others claim they got separated, but their stories don\'t quite match up. Investigate the phone to find out what really happened.',
  objective:
      'Find out what happened to Sarah Miller and identify her location.',
  difficulty: CaseDifficulty.tutorial,
  themeColor: const Color(0xFF2E7D32),
  totalClues: 5,
  hints: [
    "Check the messages between the hiker and his friend. There might be a mention of a meeting spot.",
    "Look closely at the photo from the hiking trail.",
  ],
  contacts: [
    Contact(
      id: 'sarah',
      firstName: 'Sarah',
      lastName: 'Chen',
      phoneNumber: '555-0101',
      email: 'sarah.chen@email.com',
      relationship: 'Phone Owner',
      avatarColor: const Color(0xFF7B1FA2),
    ),
    Contact(
      id: 'mike',
      firstName: 'Mike',
      lastName: 'Torres',
      phoneNumber: '555-0102',
      relationship: 'Hiking Partner',
      avatarColor: const Color(0xFF1976D2),
    ),
    Contact(
      id: 'jenny',
      firstName: 'Jenny',
      lastName: 'Park',
      phoneNumber: '555-0103',
      relationship: 'Best Friend',
      avatarColor: const Color(0xFFE91E63),
    ),
    Contact(
      id: 'david',
      firstName: 'David',
      lastName: 'Wilson',
      phoneNumber: '555-0104',
      relationship: 'Ex-Boyfriend',
      avatarColor: const Color(0xFFFF5722),
    ),
    Contact(
      id: 'ranger',
      firstName: 'Tom',
      lastName: 'Bradley',
      phoneNumber: '555-0199',
      relationship: 'Park Ranger',
      avatarColor: const Color(0xFF388E3C),
    ),
  ],
  conversations: [
    Conversation(
      id: 'conv_mike',
      contactId: 'mike',
      messages: [
        Message(
          id: 'msg1',
          conversationId: 'conv_mike',
          senderId: 'mike',
          content: 'Hey, are we still on for Saturday?',
          timestamp: DateTime(2024, 3, 15, 9, 30),
        ),
        Message(
          id: 'msg2',
          conversationId: 'conv_mike',
          senderId: 'owner',
          content: 'Yes! So excited for Eagle Peak!',
          timestamp: DateTime(2024, 3, 15, 9, 32),
        ),
        Message(
          id: 'msg3',
          conversationId: 'conv_mike',
          senderId: 'mike',
          content: 'Great. David wants to join too...',
          timestamp: DateTime(2024, 3, 15, 9, 35),
        ),
        Message(
          id: 'msg4',
          conversationId: 'conv_mike',
          senderId: 'owner',
          content: 'What?! Why would you invite him?',
          timestamp: DateTime(2024, 3, 15, 9, 36),
        ),
        Message(
          id: 'msg5',
          conversationId: 'conv_mike',
          senderId: 'mike',
          content: 'He asked. I couldn\'t say no. Is that a problem?',
          timestamp: DateTime(2024, 3, 15, 9, 40),
        ),
        Message(
          id: 'msg6',
          conversationId: 'conv_mike',
          senderId: 'owner',
          content: 'You know it is. We broke up for a reason.',
          timestamp: DateTime(2024, 3, 15, 9, 42),
        ),
        Message(
          id: 'msg7',
          conversationId: 'conv_mike',
          senderId: 'mike',
          content: 'Look, just ignore him. It\'ll be fine.',
          timestamp: DateTime(2024, 3, 15, 9, 45),
        ),
      ],
    ),
    Conversation(
      id: 'conv_jenny',
      contactId: 'jenny',
      messages: [
        Message(
          id: 'msg8',
          conversationId: 'conv_jenny',
          senderId: 'jenny',
          content: 'How\'s the hike going?',
          timestamp: DateTime(2024, 3, 16, 14, 20),
        ),
        Message(
          id: 'msg9',
          conversationId: 'conv_jenny',
          senderId: 'owner',
          content: 'Terrible. David is being weird.',
          timestamp: DateTime(2024, 3, 16, 14, 25),
        ),
        Message(
          id: 'msg10',
          conversationId: 'conv_jenny',
          senderId: 'jenny',
          content: 'Weird how?',
          timestamp: DateTime(2024, 3, 16, 14, 26),
        ),
        Message(
          id: 'msg11',
          conversationId: 'conv_jenny',
          senderId: 'owner',
          content:
              'Following me, taking photos of me without asking. I\'m going to take a different trail back.',
          timestamp: DateTime(2024, 3, 16, 14, 30),
        ),
        Message(
          id: 'msg12',
          conversationId: 'conv_jenny',
          senderId: 'jenny',
          content: 'That sounds scary. Please be careful!',
          timestamp: DateTime(2024, 3, 16, 14, 31),
        ),
        Message(
          id: 'msg13',
          conversationId: 'conv_jenny',
          senderId: 'owner',
          content: 'I know a shortcut through Hollow Creek. I\'ll be fine.',
          timestamp: DateTime(2024, 3, 16, 14, 35),
          isRead: false,
        ),
      ],
    ),
    Conversation(
      id: 'conv_david',
      contactId: 'david',
      messages: [
        Message(
          id: 'msg14',
          conversationId: 'conv_david',
          senderId: 'david',
          content: 'We need to talk about us.',
          timestamp: DateTime(2024, 3, 16, 10, 0),
        ),
        Message(
          id: 'msg15',
          conversationId: 'conv_david',
          senderId: 'owner',
          content: 'There is no us. Leave me alone.',
          timestamp: DateTime(2024, 3, 16, 10, 5),
        ),
        Message(
          id: 'msg16',
          conversationId: 'conv_david',
          senderId: 'david',
          content: 'I made a mistake. Give me another chance.',
          timestamp: DateTime(2024, 3, 16, 10, 10),
        ),
        Message(
          id: 'msg17',
          conversationId: 'conv_david',
          senderId: 'owner',
          content: 'No.',
          timestamp: DateTime(2024, 3, 16, 10, 11),
        ),
        Message(
          id: 'msg18',
          conversationId: 'conv_david',
          senderId: 'david',
          content: 'You\'ll regret this.',
          timestamp: DateTime(2024, 3, 16, 10, 15),
        ),
      ],
    ),
  ],
  photos: [
    Photo(
      id: 'photo1',
      title: 'Trail Start',
      dateTaken: DateTime(2024, 3, 16, 8, 0),
      location: 'Eagle Peak Trailhead',
    ),
    Photo(
      id: 'photo2',
      title: 'Group Photo',
      dateTaken: DateTime(2024, 3, 16, 10, 30),
      location: 'Eagle Peak Trail',
    ),
    Photo(
      id: 'photo3',
      title: 'Mountain View',
      dateTaken: DateTime(2024, 3, 16, 12, 0),
      location: 'Eagle Peak Summit',
    ),
    Photo(
      id: 'photo4',
      title: 'Hollow Creek Sign',
      dateTaken: DateTime(2024, 3, 16, 14, 45),
      location: 'Hollow Creek Junction',
      hotspots: [
        PhotoHotspot(
          id: 'hs1',
          x: 0.3,
          y: 0.6,
          description:
              'A trail sign pointing to "Hollow Creek Cabin - 2 miles". This matches Sarah\'s message about taking a shortcut.',
        ),
      ],
    ),
    Photo(
      id: 'photo5',
      title: 'Selfie at Creek',
      dateTaken: DateTime(2024, 3, 16, 15, 20),
      location: 'Hollow Creek',
    ),
  ],
  notes: [
    Note(
      id: 'note1',
      title: 'Hiking Checklist',
      content:
          '- Water bottles ✓\n- First aid kit ✓\n- Emergency beacon (in car)\n- Map of trails\n- Extra food',
      createdAt: DateTime(2024, 3, 14),
    ),
    Note(
      id: 'note2',
      title: 'Hollow Creek Cabin',
      content:
          'Jenny told me about this old ranger cabin at Hollow Creek. It\'s unlocked and has supplies. Good place to wait if you get lost. Coordinates: 45.2341, -122.8976',
      createdAt: DateTime(2024, 3, 10),
    ),
  ],
  callLog: [
    CallRecord(
      id: 'call1',
      contactId: 'mike',
      phoneNumber: '555-0102',
      type: CallType.outgoing,
      timestamp: DateTime(2024, 3, 16, 8, 15),
      duration: const Duration(minutes: 2),
    ),
    CallRecord(
      id: 'call2',
      contactId: 'ranger',
      phoneNumber: '555-0199',
      type: CallType.missed,
      timestamp: DateTime(2024, 3, 16, 15, 45),
      duration: Duration.zero,
    ),
    CallRecord(
      id: 'call3',
      contactId: 'ranger',
      phoneNumber: '555-0199',
      type: CallType.outgoing,
      timestamp: DateTime(2024, 3, 16, 15, 50),
      duration: const Duration(seconds: 30),
    ),
  ],
  emails: [
    Email(
      id: 'email1',
      senderId: 'ranger',
      senderEmail: 'ranger@parkservice.gov',
      senderName: 'Park Service',
      subject: 'Trail Closure Notice',
      body:
          'Dear Hikers,\n\nPlease note that Hollow Creek Trail has been closed due to recent flooding. The bridge at mile marker 3 is unsafe.\n\nAlternative routes are available via North Ridge.\n\nStay safe,\nPark Service',
      timestamp: DateTime(2024, 3, 14),
    ),
  ],
  solution: CaseSolution(
    guiltyContactId: '',
    motive: 'No crime committed',
    method: 'Sarah took a shortcut and found shelter',
    keyClueIds: ['note2', 'msg13', 'photo4'],
    resolution:
        'Sarah is safe! She took the Hollow Creek shortcut to avoid David and found the old ranger cabin. Due to the flooded bridge (mentioned in the park email), she couldn\'t cross back and waited for rescue. The coordinates in her note led search teams directly to her. David\'s behavior was concerning but not criminal.',
    options: [
      SolutionOption(
        contactId: 'david',
        label: 'David Wilson did something to her',
        isCorrect: false,
        feedback:
            'While David\'s behavior was inappropriate, the evidence shows Sarah left voluntarily. Check her notes and messages for where she went.',
      ),
      SolutionOption(
        contactId: 'mike',
        label: 'Mike Torres is hiding something',
        isCorrect: false,
        feedback:
            'Mike invited David without thinking, but there\'s no evidence of wrongdoing. Look at Sarah\'s last messages.',
      ),
      SolutionOption(
        contactId: '',
        label: 'Sarah is safe, waiting at Hollow Creek Cabin',
        isCorrect: true,
        feedback:
            'Correct! The note about the cabin coordinates, her message about the shortcut, and the photo at Hollow Creek Junction all point to her location.',
      ),
      SolutionOption(
        contactId: 'ranger',
        label: 'The ranger is involved',
        isCorrect: false,
        feedback:
            'The ranger only sent a trail closure warning. No evidence suggests involvement.',
      ),
    ],
  ),
);
