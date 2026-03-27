// Phone Detective - Case 01: The Last Message
// Tutorial case — Sara Novak's death was ruled accidental,
// but her phone was used 35 minutes after she died.

import 'package:flutter/material.dart';
import '../../models/models.dart';

final case01TheLastMessage = CaseData(
  caseNumber: 1,
  title: 'The Last Message',
  subtitle: 'A text sent after death',
  description:
      'Sara Novak was found dead in her apartment. Ruled accidental. '
      'But a text was sent from her phone 35 minutes after she died. '
      'Someone was there.',
  scenario:
      'Sara Novak, 29, was found unresponsive in her apartment on Friday night. '
      'The coroner ruled it an accidental cardiac episode. Case closed.\n\n'
      'Except her phone tells a different story. A text message was sent to her '
      'sister at 11:58 PM — exactly 35 minutes after her recorded time of death.\n\n'
      'Someone unlocked her phone. Someone typed that message. Someone wanted '
      'the world to think Sara was still alive.',
  objective:
      'Sara\'s phone was found unlocked. A message was sent after she died. '
      'Find out who was there.',
  difficulty: CaseDifficulty.tutorial,
  themeColor: const Color(0xFF37474F),
  totalClues: 5,
  handlerBriefing: '',
  hints: [
    'Pay attention to timestamps across different apps.',
    'The phone PIN is written somewhere on this phone.',
    'Someone was in that apartment between 11:23 PM and 11:58 PM.',
  ],

  // ─── CONTACTS ──────────────────────────────────────────────
  contacts: [
    Contact(
      id: 'sara',
      firstName: 'Sara',
      lastName: 'Novak',
      phoneNumber: '555-0201',
      email: 'sara.novak@gmail.com',
      relationship: 'Phone Owner (Deceased)',
      avatarColor: const Color(0xFF7B1FA2),
    ),
    Contact(
      id: 'alex',
      firstName: 'Alex',
      lastName: 'Petrov',
      phoneNumber: '555-0202',
      email: 'alex.petrov@studio.com',
      relationship: 'Ex-Boyfriend',
      avatarColor: const Color(0xFFD32F2F),
    ),
    Contact(
      id: 'emma',
      firstName: 'Emma',
      lastName: 'Novak',
      phoneNumber: '555-0203',
      email: 'emma.novak@gmail.com',
      relationship: 'Sister',
      avatarColor: const Color(0xFFE91E63),
    ),
    Contact(
      id: 'dr_reyes',
      firstName: 'Dr. Maya',
      lastName: 'Reyes',
      phoneNumber: '555-0204',
      email: 'dr.reyes@heartcare.org',
      relationship: 'Cardiologist',
      avatarColor: const Color(0xFF1976D2),
    ),
    Contact(
      id: 'kai',
      firstName: 'Kai',
      lastName: 'Yamamoto',
      phoneNumber: '555-0205',
      email: 'kai.y@bridgeworth.com',
      relationship: 'Coworker',
      avatarColor: const Color(0xFF00897B),
    ),
  ],

  // ─── CONVERSATIONS ─────────────────────────────────────────
  conversations: [
    // --- Emma (sister) ---
    Conversation(
      id: 'conv_emma',
      contactId: 'emma',
      messages: [
        Message(
          id: 'msg_emma_1',
          conversationId: 'conv_emma',
          senderId: 'emma',
          content: 'Hey! Still on for Sunday lunch?',
          timestamp: DateTime(2025, 3, 12, 10, 0),
        ),
        Message(
          id: 'msg_emma_2',
          conversationId: 'conv_emma',
          senderId: 'owner',
          content: 'Yes! I\'ll bring that pasta you love.',
          timestamp: DateTime(2025, 3, 12, 10, 5),
        ),
        Message(
          id: 'msg_emma_3',
          conversationId: 'conv_emma',
          senderId: 'emma',
          content: 'You seem stressed lately. Everything ok with Alex?',
          timestamp: DateTime(2025, 3, 13, 18, 0),
        ),
        Message(
          id: 'msg_emma_4',
          conversationId: 'conv_emma',
          senderId: 'owner',
          content: 'We broke up. Finally. I\'m relieved honestly.',
          timestamp: DateTime(2025, 3, 13, 18, 15),
        ),
        Message(
          id: 'msg_emma_5',
          conversationId: 'conv_emma',
          senderId: 'emma',
          content:
              'Good. I never liked how he made you feel. You deserve better.',
          timestamp: DateTime(2025, 3, 13, 18, 18),
        ),
        Message(
          id: 'msg_emma_6',
          conversationId: 'conv_emma',
          senderId: 'owner',
          content: 'He keeps calling though. Won\'t accept it\'s over.',
          timestamp: DateTime(2025, 3, 13, 18, 30),
        ),
        Message(
          id: 'msg_emma_7',
          conversationId: 'conv_emma',
          senderId: 'emma',
          content: 'Block him if you have to. I\'m here if you need me.',
          timestamp: DateTime(2025, 3, 13, 18, 32),
        ),
        // THE KEY CLUE — sent 35 min after Sara's death
        Message(
          id: 'msg_late_text',
          conversationId: 'conv_emma',
          senderId: 'owner',
          content: 'I\'m fine, heading to bed early. Talk tomorrow.',
          timestamp: DateTime(2025, 3, 14, 23, 58),
          isRead: false,
        ),
      ],
    ),

    // --- Alex (ex-boyfriend / culprit) ---
    Conversation(
      id: 'conv_alex',
      contactId: 'alex',
      messages: [
        Message(
          id: 'msg_alex_1',
          conversationId: 'conv_alex',
          senderId: 'alex',
          content: 'Sara please just talk to me.',
          timestamp: DateTime(2025, 3, 12, 14, 0),
        ),
        Message(
          id: 'msg_alex_2',
          conversationId: 'conv_alex',
          senderId: 'owner',
          content: 'Alex we\'ve said everything that needs to be said.',
          timestamp: DateTime(2025, 3, 12, 14, 15),
        ),
        Message(
          id: 'msg_alex_3',
          conversationId: 'conv_alex',
          senderId: 'alex',
          content: 'You can\'t just throw away 3 years.',
          timestamp: DateTime(2025, 3, 12, 14, 17),
        ),
        Message(
          id: 'msg_alex_4',
          conversationId: 'conv_alex',
          senderId: 'owner',
          content: 'I\'ve made my decision. Please respect it.',
          timestamp: DateTime(2025, 3, 12, 14, 20),
        ),
        Message(
          id: 'msg_alex_5',
          conversationId: 'conv_alex',
          senderId: 'alex',
          content: 'I\'m not going to stop trying.',
          timestamp: DateTime(2025, 3, 12, 14, 22),
        ),
        // Night of Sara's death
        Message(
          id: 'msg_alex_6',
          conversationId: 'conv_alex',
          senderId: 'alex',
          content: 'Pick up your phone.',
          timestamp: DateTime(2025, 3, 14, 22, 50),
        ),
        // KEY CLUE — Alex announces he's coming over
        Message(
          id: 'msg_alex_coming',
          conversationId: 'conv_alex',
          senderId: 'alex',
          content: 'I\'m coming over. We need to talk.',
          timestamp: DateTime(2025, 3, 14, 23, 5),
        ),
      ],
    ),

    // --- Kai (coworker — red herring) ---
    Conversation(
      id: 'conv_kai',
      contactId: 'kai',
      messages: [
        Message(
          id: 'msg_kai_1',
          conversationId: 'conv_kai',
          senderId: 'kai',
          content: 'Great work on the Henderson pitch today!',
          timestamp: DateTime(2025, 3, 13, 17, 0),
        ),
        Message(
          id: 'msg_kai_2',
          conversationId: 'conv_kai',
          senderId: 'owner',
          content: 'Thanks! It went better than I expected.',
          timestamp: DateTime(2025, 3, 13, 17, 5),
        ),
        // RED HERRING — Kai has Sara's spare key
        Message(
          id: 'msg_kai_key',
          conversationId: 'conv_kai',
          senderId: 'kai',
          content:
              'Hey — still have your spare key from last week. Will drop '
              'it off Saturday!',
          timestamp: DateTime(2025, 3, 14, 15, 0),
        ),
        Message(
          id: 'msg_kai_4',
          conversationId: 'conv_kai',
          senderId: 'owner',
          content: 'No rush! See you Monday.',
          timestamp: DateTime(2025, 3, 14, 15, 10),
        ),
      ],
    ),
  ],

  // ─── PHOTOS ────────────────────────────────────────────────
  photos: [
    Photo(
      id: 'photo_dinner',
      title: 'Dinner with Emma',
      description:
          'Sara and her sister Emma smiling at a restaurant. A birthday '
          'cake is visible on the table. They look happy.',
      dateTaken: DateTime(2025, 3, 1, 19, 30),
      location: 'Rosario\'s Italian Kitchen',
    ),
    Photo(
      id: 'photo_work',
      title: 'Team Offsite',
      description:
          'Sara with coworkers at a company event. Kai is standing next '
          'to her. Everyone is in business casual.',
      dateTaken: DateTime(2025, 3, 10, 14, 0),
      location: 'Bridgeworth HQ',
    ),
    // KEY CLUE — last photo taken, someone was at her apartment
    Photo(
      id: 'photo_window',
      title: 'Last Photo',
      description:
          'A dark photo of an apartment window at night. The curtains are '
          'half-drawn. In the reflection of the glass, the faint silhouette '
          'of a person holding the phone is barely visible. The metadata '
          'shows this was taken at Sara\'s apartment address.',
      dateTaken: DateTime(2025, 3, 14, 23, 42),
      location: '412 Maple Ave, Apt 3B',
      hotspots: [
        PhotoHotspot(
          id: 'hs_reflection',
          x: 0.6,
          y: 0.4,
          description:
              'A faint reflection in the window glass — the silhouette of '
              'someone holding the phone. This photo was taken at 11:42 PM, '
              '19 minutes after Sara\'s time of death.',
        ),
      ],
    ),
  ],

  // ─── NOTES ─────────────────────────────────────────────────
  notes: [
    Note(
      id: 'note_reminders',
      title: 'Weekend Plans',
      content:
          '- Call mom Sunday morning\n'
          '- Grocery run (milk, bread, yogurt)\n'
          '- Return Alex\'s jacket — CANCEL, he can pick it up himself\n'
          '- Emma lunch 12pm Sunday',
      createdAt: DateTime(2025, 3, 13),
      color: NoteColor.green,
    ),
    // KEY CLUE — phone PIN, Alex's idea
    Note(
      id: 'note_pin',
      title: 'PINs & Passwords',
      content:
          'Phone: 1847 — Alex\'s idea, the year on that old exhibition '
          'poster from our first date\n'
          'Bank: 7291\n'
          'Netflix: (same as phone)\n'
          'Work email: SNovak2025!',
      createdAt: DateTime(2025, 2, 1),
      color: NoteColor.orange,
    ),
    // Bonus — locked note, teaches password mechanic
    Note(
      id: 'note_draft',
      title: 'Draft — For A.',
      content:
          'Alex,\n\n'
          'I need you to hear this even if I never send it. What we had was '
          'real once, but it became something I was afraid of. The night you '
          'grabbed my arm at the restaurant — I can\'t forget that. The way '
          'you showed up at my work. The calls at 2 AM.\n\n'
          'I don\'t hate you. But I can\'t be near you.\n\n'
          'Please. Let me go.\n\n'
          'Sara',
      createdAt: DateTime(2025, 3, 8),
      color: NoteColor.pink,
      isLocked: true,
      password: '1847',
      passwordHint: 'Try the phone unlock code',
    ),
  ],

  // ─── CALL LOG ──────────────────────────────────────────────
  callLog: [
    CallRecord(
      id: 'call_emma_morning',
      contactId: 'emma',
      phoneNumber: '555-0203',
      type: CallType.outgoing,
      timestamp: DateTime(2025, 3, 14, 9, 15),
      duration: const Duration(minutes: 8, seconds: 12),
    ),
    CallRecord(
      id: 'call_dr_voicemail',
      contactId: 'dr_reyes',
      phoneNumber: '555-0204',
      type: CallType.voicemail,
      timestamp: DateTime(2025, 3, 13, 14, 30),
      duration: const Duration(seconds: 52),
      transcription:
          'Hi Sara, this is Dr. Reyes from HeartCare. Just a reminder '
          'to take your evening medication with food — not on an empty '
          'stomach. If you feel any chest tightness, call us immediately '
          'or go to the ER. Take care.',
    ),
    // Alex called Sara on the night she died
    CallRecord(
      id: 'call_alex_night',
      contactId: 'alex',
      phoneNumber: '555-0202',
      type: CallType.incoming,
      timestamp: DateTime(2025, 3, 14, 22, 47),
      duration: const Duration(minutes: 2, seconds: 14),
    ),
    CallRecord(
      id: 'call_alex_missed',
      contactId: 'alex',
      phoneNumber: '555-0202',
      type: CallType.missed,
      timestamp: DateTime(2025, 3, 14, 22, 55),
      duration: Duration.zero,
    ),
  ],

  // ─── EMAILS ────────────────────────────────────────────────
  emails: [
    // KEY CLUE — MedAlert showing time of death
    Email(
      id: 'email_medalert',
      senderId: 'medalert',
      senderEmail: 'alerts@medalert.health',
      senderName: 'MedAlert Emergency',
      subject: 'EMERGENCY VITALS ALERT — Sara Novak',
      body:
          'AUTOMATED EMERGENCY ALERT\n\n'
          'Patient: Sara Novak\n'
          'Device: MedAlert Cardiac Monitor (Model CM-400)\n\n'
          'An irregular cardiac event was detected at 11:19 PM.\n'
          'Last stable vitals recorded: 11:23 PM, Friday March 14, 2025.\n'
          'No response detected from patient.\n\n'
          'Emergency services have been automatically notified.\n\n'
          'If this alert was triggered in error, please dismiss in the '
          'MedAlert app or contact support at 1-800-MED-ALRT.',
      timestamp: DateTime(2025, 3, 14, 23, 24),
      isRead: false,
      isStarred: false,
    ),
    // Emma's email — supporting evidence
    Email(
      id: 'email_emma_reply',
      senderId: 'emma',
      senderEmail: 'emma.novak@gmail.com',
      senderName: 'Emma Novak',
      subject: 'That text last night',
      body:
          'Sara,\n\n'
          'I got your text last night but something felt off. "Heading to '
          'bed early"? On a Friday? And you NEVER text me at midnight — you '
          'always call.\n\n'
          'I tried calling this morning but it went straight to voicemail.\n\n'
          'I\'m coming over after work. Please answer your phone.\n\n'
          'Love,\nEmma',
      timestamp: DateTime(2025, 3, 15, 8, 42),
      isRead: false,
    ),
    // Alex email from days before — shows obsessive behavior
    Email(
      id: 'email_alex_apology',
      senderId: 'alex',
      senderEmail: 'alex.petrov@studio.com',
      senderName: 'Alex Petrov',
      subject: 'Please read this',
      body:
          'Sara,\n\n'
          'I know you\'re not answering my calls. I understand. But please '
          'just read this.\n\n'
          'I\'ve been thinking about everything. I know I scared you. I know '
          'I crossed a line. But I swear I can change. Three years, Sara. You '
          'can\'t erase three years.\n\n'
          'I still have the key to your place. I\'ll return it when you\'re '
          'ready to talk. Not before.\n\n'
          'Alex',
      timestamp: DateTime(2025, 3, 10, 21, 15),
      isRead: true,
    ),
  ],

  // ─── SOLUTION ──────────────────────────────────────────────
  solution: CaseSolution(
    guiltyContactId: 'alex',
    motive:
        'Alex Petrov refused to accept Sara\'s decision to end the '
        'relationship. When he arrived at her apartment and found her '
        'unresponsive, he panicked. Instead of calling for help, he used '
        'her phone PIN to send a text to her sister — buying himself time '
        'to leave before anyone came looking.',
    method:
        'Alex used Sara\'s phone PIN (1847), which he had chosen himself '
        'years ago, to unlock the phone and send a text to Emma at 11:58 PM '
        '— 35 minutes after Sara\'s cardiac monitor recorded her death at '
        '11:23 PM. He also took a photo (accidentally or to check the '
        'window) at 11:42 PM before sending the text.',
    keyClueIds: [
      'msg_late_text',
      'note_pin',
      'photo_window',
      'email_medalert',
      'msg_alex_coming',
    ],
    resolution:
        'When confronted with the evidence — the MedAlert timestamp proving '
        'Sara died at 11:23 PM, the text sent 35 minutes later, the photo '
        'taken at her apartment at 11:42 PM, and his own message saying he '
        'was coming over — Alex Petrov confessed.\n\n'
        'He claimed he arrived to find Sara on the floor. He says he panicked '
        'and sent the text so no one would check on her before he could '
        '"figure out what to do." He left without calling 911.\n\n'
        'Sara\'s cardiac episode was real, but Alex\'s 35-minute delay may '
        'have cost her the only chance at survival. The DA charged him with '
        'obstruction and criminally negligent homicide.',
    options: [
      SolutionOption(
        contactId: 'alex',
        label: 'Alex Petrov sent the text after Sara died',
        isCorrect: true,
        feedback:
            'Correct. Alex came to her apartment that night, found her '
            'unresponsive, and used the PIN he knew (1847) to send a fake '
            'text to Emma. The MedAlert proves Sara was already gone. '
            'Alex\'s delay may have cost Sara her life.',
      ),
      SolutionOption(
        contactId: 'kai',
        label: 'Kai Yamamoto used the spare key to enter',
        isCorrect: false,
        feedback:
            'Kai had Sara\'s spare key but mentioned returning it Saturday. '
            'There\'s no evidence Kai was near the apartment that night. '
            'Look at who actually said they were coming over.',
      ),
      SolutionOption(
        contactId: 'emma',
        label: 'Emma Novak is hiding something',
        isCorrect: false,
        feedback:
            'Emma\'s email the next morning shows genuine concern — she '
            'noticed the text felt wrong. She was the one who sounded the '
            'alarm. Look at who had both the PIN and a reason to be there.',
      ),
      SolutionOption(
        contactId: '',
        label: 'Sara sent the text herself before dying',
        isCorrect: false,
        feedback:
            'The MedAlert recorded Sara\'s last vitals at 11:23 PM. The text '
            'was sent at 11:58 PM — 35 minutes later. Check the medical '
            'alert email again. Sara could not have sent that message.',
      ),
    ],
    deductionChecklist: [
      DeductionItem(
        id: 'dc_timeline',
        statement:
            'A text was sent from Sara\'s phone 35 minutes after her '
            'recorded time of death.',
        linkedClueIds: ['email_medalert', 'msg_late_text'],
      ),
      DeductionItem(
        id: 'dc_pin',
        statement: 'Alex Petrov knew Sara\'s phone PIN (1847).',
        linkedClueIds: ['note_pin'],
      ),
      DeductionItem(
        id: 'dc_presence',
        statement:
            'Alex was at Sara\'s apartment on the night she died.',
        linkedClueIds: ['msg_alex_coming', 'photo_window'],
      ),
    ],
    redHerringIds: ['msg_kai_key'],
  ),

  // ─── STEP HINTS ────────────────────────────────────────────
  stepHints: [
    StepHint(
      id: 'sh_email',
      forNodeId: 'email_medalert',
      stepNumber: 1,
      title: 'Time of Death',
      hints: [
        'Check Sara\'s email inbox for any automated alerts.',
        'MedAlert sent an emergency notification — open it.',
        'The MedAlert email shows Sara\'s last vitals at 11:23 PM on March 14.',
      ],
    ),
    StepHint(
      id: 'sh_text',
      forNodeId: 'msg_late_text',
      stepNumber: 2,
      title: 'The Suspicious Text',
      hints: [
        'Read Sara\'s conversation with her sister Emma.',
        'Scroll to the most recent message in Emma\'s thread.',
        'The last text was sent at 11:58 PM — 35 minutes after the MedAlert.',
      ],
    ),
    StepHint(
      id: 'sh_pin',
      forNodeId: 'note_pin',
      stepNumber: 3,
      title: 'Who Knew the PIN?',
      hints: [
        'Open Sara\'s Notes app and look around.',
        'Find the note about passwords and PINs.',
        'The phone PIN is 1847 — and it was "Alex\'s idea."',
      ],
    ),
    StepHint(
      id: 'sh_photo',
      forNodeId: 'photo_window',
      stepNumber: 4,
      title: 'Someone Was There',
      hints: [
        'Check the Gallery for the most recent photo.',
        'Look at the timestamp and location of the last photo taken.',
        'Photo taken at 11:42 PM at Sara\'s apartment — 19 minutes after death.',
      ],
    ),
    StepHint(
      id: 'sh_alex',
      forNodeId: 'msg_alex_coming',
      stepNumber: 5,
      title: 'He Said He Was Coming',
      hints: [
        'Read the conversation with Alex Petrov.',
        'Alex sent a message on the night Sara died.',
        'At 11:05 PM Alex texted: "I\'m coming over. We need to talk."',
      ],
    ),
    StepHint(
      id: 'sh_solution',
      forNodeId: 'solution',
      stepNumber: 6,
      title: 'Put It Together',
      hints: [
        'You have all the clues. Who had means, motive, and opportunity?',
        'Alex knew the PIN. He was at the apartment. He sent the text.',
        'Go to the Journal, mark Alex as a suspect, and solve the case.',
      ],
    ),
  ],

  // ─── SUSPENSE EVENTS ───────────────────────────────────────
  suspenseEvents: [
    SuspenseEvent(
      id: 'se_timestamp',
      trigger: SuspenseTrigger.afterClue,
      triggerClueId: 'msg_late_text',
      type: SuspenseType.warning,
      title: 'TIMESTAMP ANOMALY',
      message:
          'This message was sent at 11:58 PM — 35 minutes after the '
          'MedAlert recorded Sara\'s last vitals. Someone else sent this.',
      iconName: 'schedule',
      delaySeconds: 2,
    ),
    SuspenseEvent(
      id: 'se_photo',
      trigger: SuspenseTrigger.afterClue,
      triggerClueId: 'photo_window',
      type: SuspenseType.notification,
      title: 'PHOTO METADATA',
      message:
          'Location data matches Sara\'s apartment: 412 Maple Ave, Apt 3B. '
          'Timestamp: 11:42 PM. Sara was already gone by then.',
      iconName: 'location_on',
      delaySeconds: 2,
    ),
    SuspenseEvent(
      id: 'se_timed_warning',
      trigger: SuspenseTrigger.afterTime,
      type: SuspenseType.incoming,
      title: 'UNKNOWN NUMBER',
      message: 'You shouldn\'t be looking at this phone. Stop digging.',
      iconName: 'phone',
      delaySeconds: 90,
    ),
  ],

  // ─── EVIDENCE TIMELINE ─────────────────────────────────────
  evidenceTimeline: [
    TimelineEvent(
      id: 'et_call',
      eventText: 'Alex Petrov calls Sara Novak (2 min 14 sec)',
      correctOrder: 1,
      linkedClueId: 'call_alex_night',
      timestamp: DateTime(2025, 3, 14, 22, 47),
    ),
    TimelineEvent(
      id: 'et_text_alex',
      eventText: 'Alex texts Sara: "I\'m coming over. We need to talk."',
      correctOrder: 2,
      linkedClueId: 'msg_alex_coming',
      timestamp: DateTime(2025, 3, 14, 23, 5),
    ),
    TimelineEvent(
      id: 'et_death',
      eventText: 'MedAlert records Sara\'s last stable vitals (time of death)',
      correctOrder: 3,
      linkedClueId: 'email_medalert',
      timestamp: DateTime(2025, 3, 14, 23, 23),
    ),
    TimelineEvent(
      id: 'et_photo',
      eventText: 'Photo taken at Sara\'s apartment by unknown person',
      correctOrder: 4,
      linkedClueId: 'photo_window',
      timestamp: DateTime(2025, 3, 14, 23, 42),
    ),
    TimelineEvent(
      id: 'et_fake_text',
      eventText:
          'Text sent from Sara\'s phone to Emma: '
          '"I\'m fine, heading to bed early."',
      correctOrder: 5,
      linkedClueId: 'msg_late_text',
      timestamp: DateTime(2025, 3, 14, 23, 58),
    ),
  ],

  // No interrogation for tutorial case
  interrogationQuestions: [],

  unlockRequires: [],
);
