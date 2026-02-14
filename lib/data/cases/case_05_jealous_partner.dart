// Phone Detective - Case 05: The Influencer's Shadow

import 'package:flutter/material.dart';
import '../../models/models.dart';

final case05JealousPartner = CaseData(
  caseNumber: 5,
  title: 'The Influencer\'s Shadow',
  subtitle: 'A livestream murder mystery',
  description:
      'A popular streamer died live on camera. The killer was masked, but the chat logs reveal a dark obsession.',
  scenario:
      'Bella "B-Live" Minton was murdered during a broadcast. The police arrested her ex-boyfriend, Liam, because he threatened to "come over" just hours before. But the digital evidence tells a different story. You need to prove Liam\'s innocence and find the real stalker hiding in plain sight among her "supportive" moderators.',
  objective: 'Prove Liam is innocent and identify the true killer.',
  difficulty: CaseDifficulty.hard, // 4 stars -> hard?
  themeColor: const Color(0xFFB71C1C),
  totalClues: 3, // Based on solution key_clue_ids
  contacts: [
    Contact(
      id: 'bella',
      firstName: 'Bella',
      lastName: 'Minton',
      phoneNumber: '555-0900',
      relationship: 'Phone Owner (Victim)',
      avatarColor: const Color(0xFFF48FB1),
    ),
    Contact(
      id: 'chloe',
      firstName: 'Chloe',
      lastName: 'Day',
      phoneNumber: '555-0901',
      relationship: 'Rival Streamer',
      avatarColor: const Color(0xFF9C27B0),
    ),
    Contact(
      id: 'toby',
      firstName: 'Toby',
      lastName: 'Reed',
      phoneNumber: '555-0902',
      relationship: 'Moderator (Superfan)',
      avatarColor: const Color(0xFF4CAF50),
      birthday: '1998-08-08',
    ),
    Contact(
      id: 'liam',
      firstName: 'Liam',
      lastName: 'Katz',
      phoneNumber: '555-0903',
      relationship: 'Ex-Boyfriend (Suspect)',
      avatarColor: const Color(0xFF607D8B),
    ),
  ],
  conversations: [
    Conversation(
      id: 'conv_liam',
      contactId: 'liam',
      messages: [
        Message(
          id: 'm1',
          conversationId: 'conv_liam',
          senderId: 'liam',
          content: 'I want my hoodie back, Bella. Today.',
          timestamp: DateTime.utc(2024, 7, 21, 18, 0),
        ),
        Message(
          id: 'm2',
          conversationId: 'conv_liam',
          senderId: 'owner',
          content: 'Stop texting me. I threw it out.',
          timestamp: DateTime.utc(2024, 7, 21, 18, 5),
        ),
        Message(
          id: 'm3',
          conversationId: 'conv_liam',
          senderId: 'liam',
          content: 'You\'re lying. I\'m coming over there right now to get it.',
          timestamp: DateTime.utc(2024, 7, 21, 18, 10),
        ),
        Message(
          id: 'm4',
          conversationId: 'conv_liam',
          senderId: 'owner',
          content: 'If you come here, I\'m calling the cops.',
          timestamp: DateTime.utc(2024, 7, 21, 18, 12),
        ),
      ],
    ),
    Conversation(
      id: 'conv_toby',
      contactId: 'toby',
      messages: [
        Message(
          id: 'm5',
          conversationId: 'conv_toby',
          senderId: 'toby',
          content:
              'Don\'t worry about Liam. I banned him from the chat. I\'m keeping watch.',
          timestamp: DateTime.utc(2024, 7, 21, 18, 30),
        ),
        Message(
          id: 'm6',
          conversationId: 'conv_toby',
          senderId: 'owner',
          content: 'Thanks Toby. I feel like everyone is against me today.',
          timestamp: DateTime.utc(2024, 7, 21, 18, 35),
        ),
        Message(
          id: 'm7',
          conversationId: 'conv_toby',
          senderId: 'toby',
          content:
              'Not me. I\'m the only one who truly gets you. Btw, here is that verification photo you asked for so I can become Head Mod.',
          timestamp: DateTime.utc(2024, 7, 10, 10, 0),
        ),
        Message(
          id: 'm8',
          conversationId: 'conv_toby',
          senderId: 'toby',
          content: '(Image attachment hidden in files: toby_selfie.jpg)',
          timestamp: DateTime.utc(2024, 7, 10, 10, 1),
        ),
      ],
    ),
  ],
  photos: [
    Photo(
      id: 'ph1',
      title: 'Toby Verification',
      dateTaken: DateTime.utc(2024, 7, 10, 10, 0),
      location: 'Toby\'s Room',
      hotspots: [
        PhotoHotspot(
          id: 'h1',
          x: 0.8,
          y: 0.8,
          description:
              'Toby is holding up a sign saying "Mod 4 Life". On his wrist is a distinctive orange Casio watch with a cracked screen.',
        ),
      ],
    ),
    Photo(
      id: 'ph2',
      title: 'Crime Scene Reflection',
      dateTaken: DateTime.utc(2024, 7, 21, 20, 15),
      location: 'Living Room',
      hotspots: [
        PhotoHotspot(
          id: 'h2',
          x: 0.4,
          y: 0.3,
          description:
              'A photo taken accidentally as the phone fell. In the reflection of the TV, you can see a masked man\'s hand grabbing the doorframe. He is wearing an orange Casio watch with a cracked screen.',
        ),
      ],
    ),
  ],
  notes: [
    Note(
      id: 'nt1',
      title: 'Stream Schedule',
      content:
          '8:00 PM - Just Chatting\n9:00 PM - Gaming\n\nNote: Tell mods to auto-ban word "Liam"',
      createdAt: DateTime.utc(2024, 7, 21, 12, 0),
    ),
    Note(
      id: 'nt_logs',
      title: 'Server Logs',
      content:
          'Admin Access Granted.\nUser "Toby_Mod_God" location IP: 192.168.1.15 (Local Network)\nUser "Bella_Live" location IP: 192.168.1.10 (Local Network)\n\nWARNING: Simultaneous login from same location detected.',
      createdAt: DateTime.utc(2024, 7, 21, 14, 0),
      isLocked: true,
      password: '0808',
      passwordHint: 'Try Toby\'s birthday (MMDD)',
    ),
  ],
  callLog: [
    CallRecord(
      id: 'cl1',
      contactId: 'liam',
      phoneNumber: '555-0903',
      type: CallType.missed,
      timestamp: DateTime.utc(2024, 7, 21, 20, 15),
      duration: Duration.zero,
    ),
    CallRecord(
      id: 'cl2',
      contactId: 'liam',
      phoneNumber: '555-0903',
      type: CallType.voicemail,
      timestamp: DateTime.utc(2024, 7, 21, 20, 16),
      duration: const Duration(seconds: 15),
      transcription:
          "(Heavy breathing, car blinker sound in background) Bella! Pick up! I'm watching the stream on my phone... there's someone in your hallway! Run! I'm 10 minutes away, just LOCK THE DOOR!",
    ),
  ],
  emails: [
    Email(
      id: 'em1',
      senderId: 'toby',
      senderEmail: 'toby_mod_god@gmail.com',
      senderName: 'Toby Reed',
      subject: 'Re: Mod Application',
      body:
          'I know I live 4 hours away, but I can move closer if you need better security. I would never let anyone hurt you.',
      timestamp: DateTime.utc(2024, 7, 1, 9, 0),
    ),
    Email(
      id: 'em_welcome',
      senderId: 'admin', // System sender
      senderEmail: 'support@stream.tv',
      senderName: 'StreamTV Support',
      subject: 'Welcome to StreamTV!',
      body:
          'Welcome Bella! We are excited to have you.\n\nYour stream key is: live_559483\nYour account recovery PIN is: 8842\n\nKeep this safe!',
      timestamp: DateTime.utc(2024, 1, 15, 10, 0),
      isCorrupted: true,
      corruptedContent:
          'W#lc@me t0 Str#amTV! \n\nY%ur str#am k#y is: l*ve_559... [CORRUPTED]\nY#ur acc@unt r#c@very P!N is: 88**\n\nK##p th!s s@f#!',
    ),
  ],
  solution: CaseSolution(
    guiltyContactId: 'toby',
    motive: 'Delusional Protection (Hero Syndrome)',
    method: 'Broke in to "save" her, then snapped',
    keyClueIds: ['ph1', 'ph2', 'cl2'],
    resolution:
        'Toby Reed is the killer. The visual evidence is the smoking gun: the distinctive orange watch in his verification photo (ph1) matches the watch on the killer\'s wrist in the TV reflection (ph2). Liam is innocent despite his threats; his voicemail (cl2) proves he was driving (car sounds) and watching the stream remotely when the attack happened, desperately trying to warn her.',
    options: [
      SolutionOption(
        contactId: 'liam',
        label: 'Liam Katz - The Angry Ex',
        isCorrect: false,
        feedback:
            'Liam threatened to come over, making him the police\'s prime suspect. However, his voicemail at 20:16 contains background car noise and him warning Bella about the intruder seen on stream. He couldn\'t be the intruder and the caller simultaneously.',
      ),
      SolutionOption(
        contactId: 'toby',
        label: 'Toby Reed - The Moderator',
        isCorrect: true,
        feedback:
            'Correct. While Toby pretended to live far away (email), he was actually the stalker. The cracked orange watch in his verification selfie matches perfectly with the watch visible in the crime scene reflection.',
      ),
      SolutionOption(
        contactId: 'chloe',
        label: 'Chloe Day - The Rival',
        isCorrect: false,
        feedback:
            'Chloe was streaming live on her own channel at the exact same time Bella was murdered. Thousands of witnesses confirm her alibi.',
      ),
    ],
  ),
);
