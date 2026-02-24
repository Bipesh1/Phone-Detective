-- ============================================================
-- Phone Detective: Enhanced "Runaway Influencer" Case
-- With all 6 thriller mechanics: suspense events, evidence 
-- timeline, interrogation, deduction checklist, red herrings,
-- and atmospheric triggers.
-- ============================================================

-- Step 1: Add new columns (safe to re-run)
ALTER TABLE public.cases
  ADD COLUMN IF NOT EXISTS suspense_events jsonb DEFAULT '[]'::jsonb,
  ADD COLUMN IF NOT EXISTS evidence_timeline jsonb DEFAULT '[]'::jsonb,
  ADD COLUMN IF NOT EXISTS interrogation_questions jsonb DEFAULT '[]'::jsonb;

-- Step 2: Delete old version if it exists
DELETE FROM public.cases WHERE case_number = 1;

-- Step 3: Insert expanded case
INSERT INTO public.cases (
  case_number,
  title,
  subtitle,
  description,
  scenario,
  objective,
  difficulty,
  theme_color_hex,
  hints,
  contacts,
  conversations,
  photos,
  notes,
  call_log,
  emails,
  solution,
  step_hints,
  suspense_events,
  evidence_timeline,
  interrogation_questions
) VALUES (
  1,
  'The Runaway Influencer',
  'Where did Lena Voss go?',
  'Lifestyle influencer Lena Voss vanished the night before a major brand dinner. Her phone was found in a rideshare. Investigate her digital life to discover the truth.',
  'At 11:47 PM on a Thursday night, a Lyft driver in downtown LA turned in a phone left in his back seat. The phone belongs to Lena Voss — a lifestyle influencer with 2.3 million followers. By Friday morning, Lena had missed her keynote appearance at the LuxeLife Summit, failed to show up for a $200K brand dinner with Aurelius Skincare, and hadn''t been seen by anyone. Her manager is frantic. The police aren''t treating it as urgent — "she''s an adult, she can disappear if she wants." But something doesn''t add up. You''ve been hired to examine her phone and find out: did Lena Voss run away, or was she taken?',
  'Analyze Lena Voss''s phone to determine what happened to her. Examine messages, emails, notes, photos, and call logs to reconstruct the timeline of events and identify whether she left voluntarily or under duress.',
  'tutorial',
  '#E040FB',

  -- Hints (progressive)
  '["Start by reading the conversations — pay close attention to timestamps and tone shifts.", "Check the Notes app for anything Lena wrote privately.", "Compare the email from her therapist with what Noah says in messages.", "Look at the call log — who did Lena call last, and for how long?", "The draft Instagram post in her notes reveals her true intention."]'::jsonb,

  -- ============ CONTACTS (4 people) ============
  '[
    {
      "id": "maya",
      "firstName": "Maya",
      "lastName": "Chen",
      "phoneNumber": "+1 (310) 555-0142",
      "email": "maya.chen@gmail.com",
      "relationship": "Best Friend & Fellow Creator",
      "notes": "Known Lena since college. Also a content creator (food/travel). They share an apartment lease but Maya has been traveling.",
      "birthday": "1996-03-15",
      "avatarColorHex": "#E91E63"
    },
    {
      "id": "noah",
      "firstName": "Noah",
      "lastName": "Park",
      "phoneNumber": "+1 (310) 555-0198",
      "email": "noah.park@aurelius.com",
      "relationship": "Boyfriend & Brand Manager",
      "notes": "Works at Aurelius Skincare. Has been dating Lena for 8 months. Manages her brand partnerships. Introduced her to the LuxeLife Summit opportunity.",
      "birthday": "1994-11-02",
      "avatarColorHex": "#1976D2"
    },
    {
      "id": "felix",
      "firstName": "Felix",
      "lastName": "Drummond",
      "phoneNumber": "+1 (213) 555-0077",
      "email": "f.drummond@luxelife.com",
      "relationship": "Event Organizer / LuxeLife CEO",
      "notes": "Runs the LuxeLife Summit. Persistent, high-pressure personality. Has been pushing Lena for exclusive content deals.",
      "avatarColorHex": "#FF6F00"
    },
    {
      "id": "dr_amara",
      "firstName": "Dr. Priya",
      "lastName": "Amara",
      "phoneNumber": "+1 (310) 555-0233",
      "email": "p.amara@mindwelltherapy.com",
      "relationship": "Therapist",
      "notes": "Lena''s therapist for the past 6 months. Sessions are weekly on Wednesdays.",
      "avatarColorHex": "#00897B"
    }
  ]'::jsonb,

  -- ============ CONVERSATIONS (5 threads) ============
  '[
    {
      "id": "conv_maya",
      "contactId": "maya",
      "messages": [
        {"id": "m1", "conversationId": "conv_maya", "senderId": "maya", "content": "Hey!! How was the Aurelius meeting? Did they go for the 6-month deal?", "timestamp": "2025-05-03T14:22:00Z", "type": "text"},
        {"id": "m2", "conversationId": "conv_maya", "senderId": "owner", "content": "They want a YEAR. Noah is pushing hard for it. I don''t know if I can do another year of this.", "timestamp": "2025-05-03T14:25:00Z", "type": "text"},
        {"id": "m3", "conversationId": "conv_maya", "senderId": "maya", "content": "Wait what? I thought you loved the Aurelius brand", "timestamp": "2025-05-03T14:26:00Z", "type": "text"},
        {"id": "m4", "conversationId": "conv_maya", "senderId": "owner", "content": "I love the MONEY. But I''m so tired Maya. I had a panic attack before the last shoot. I can''t even post without my hands shaking.", "timestamp": "2025-05-03T14:28:00Z", "type": "text"},
        {"id": "m5", "conversationId": "conv_maya", "senderId": "maya", "content": "Lena... have you talked to Dr. Amara about this?", "timestamp": "2025-05-03T14:30:00Z", "type": "text"},
        {"id": "m6", "conversationId": "conv_maya", "senderId": "owner", "content": "Yeah. She says I need to set boundaries. But every time I try, Noah says I''m being ungrateful.", "timestamp": "2025-05-03T14:32:00Z", "type": "text"},
        {"id": "m7", "conversationId": "conv_maya", "senderId": "owner", "content": "Can I tell you something? Promise you won''t freak out.", "timestamp": "2025-05-04T23:15:00Z", "type": "text"},
        {"id": "m8", "conversationId": "conv_maya", "senderId": "maya", "content": "of course. what is it?", "timestamp": "2025-05-04T23:16:00Z", "type": "text"},
        {"id": "m9", "conversationId": "conv_maya", "senderId": "owner", "content": "I booked a one-way flight. Bali. Leaves tomorrow at 6 AM. I''m not going to the dinner. I''m not going to the summit. I''m done.", "timestamp": "2025-05-04T23:18:00Z", "type": "text"},
        {"id": "m10", "conversationId": "conv_maya", "senderId": "maya", "content": "LENA. Are you serious right now???", "timestamp": "2025-05-04T23:19:00Z", "type": "text"},
        {"id": "m11", "conversationId": "conv_maya", "senderId": "owner", "content": "I''ve never been more serious. I scheduled a post to go live at 6:05 AM. It explains everything. By the time anyone reads it, I''ll be in the air.", "timestamp": "2025-05-04T23:21:00Z", "type": "text"},
        {"id": "m12", "conversationId": "conv_maya", "senderId": "maya", "content": "What about Noah? What about us?", "timestamp": "2025-05-04T23:22:00Z", "type": "text"},
        {"id": "m13", "conversationId": "conv_maya", "senderId": "owner", "content": "Maya, you''re the only person I''m telling. Please don''t tell anyone until the post goes live. I love you. I need to do this.", "timestamp": "2025-05-04T23:24:00Z", "type": "text"},
        {"id": "m14", "conversationId": "conv_maya", "senderId": "maya", "content": "I love you too. Be safe. Please text me when you land. 💛", "timestamp": "2025-05-04T23:25:00Z", "type": "text"}
      ]
    },
    {
      "id": "conv_noah",
      "contactId": "noah",
      "messages": [
        {"id": "n1", "conversationId": "conv_noah", "senderId": "noah", "content": "Babe the Aurelius team confirmed the dinner. Thursday 8PM at Nobu. Dresscode is cocktail formal.", "timestamp": "2025-05-03T09:10:00Z", "type": "text"},
        {"id": "n2", "conversationId": "conv_noah", "senderId": "owner", "content": "Noah I told you I need a break. Can we talk about this later?", "timestamp": "2025-05-03T09:15:00Z", "type": "text"},
        {"id": "n3", "conversationId": "conv_noah", "senderId": "noah", "content": "A break from what? This is your CAREER Lena. The brand dinner is worth 200K. You can rest after.", "timestamp": "2025-05-03T09:17:00Z", "type": "text"},
        {"id": "n4", "conversationId": "conv_noah", "senderId": "owner", "content": "After what? After the next shoot? After the next summit? There''s always an \"after\" with you.", "timestamp": "2025-05-03T09:19:00Z", "type": "text"},
        {"id": "n5", "conversationId": "conv_noah", "senderId": "noah", "content": "I''m trying to help you. Don''t you see that? Without me this whole thing falls apart.", "timestamp": "2025-05-03T09:21:00Z", "type": "text"},
        {"id": "n6", "conversationId": "conv_noah", "senderId": "owner", "content": "Maybe it should.", "timestamp": "2025-05-03T09:22:00Z", "type": "text"},
        {"id": "n7", "conversationId": "conv_noah", "senderId": "noah", "content": "Look - the Aurelius contract is both our futures. This isn''t just about you anymore. Please don''t throw this away.", "timestamp": "2025-05-04T18:30:00Z", "type": "text"},
        {"id": "n8", "conversationId": "conv_noah", "senderId": "noah", "content": "Lena? You''re not answering my calls.", "timestamp": "2025-05-04T22:45:00Z", "type": "text"},
        {"id": "n9", "conversationId": "conv_noah", "senderId": "noah", "content": "Fine. I''ll see you at the dinner tomorrow. Don''t embarrass me.", "timestamp": "2025-05-04T23:30:00Z", "type": "text"}
      ]
    },
    {
      "id": "conv_felix",
      "contactId": "felix",
      "messages": [
        {"id": "f1", "conversationId": "conv_felix", "senderId": "felix", "content": "Lena! Felix here. Quick heads up — we''ve added you as the KEYNOTE speaker for the LuxeLife Summit. Friday 10 AM. This is HUGE for your brand.", "timestamp": "2025-05-02T11:00:00Z", "type": "text"},
        {"id": "f2", "conversationId": "conv_felix", "senderId": "owner", "content": "Felix, I never agreed to be keynote. I said I''d do a panel.", "timestamp": "2025-05-02T11:05:00Z", "type": "text"},
        {"id": "f3", "conversationId": "conv_felix", "senderId": "felix", "content": "Well, Noah told me you''d be thrilled. And the sponsors are already locked in. We can''t change it now. Just trust the process! 🙌", "timestamp": "2025-05-02T11:08:00Z", "type": "text"},
        {"id": "f4", "conversationId": "conv_felix", "senderId": "owner", "content": "Noah doesn''t speak for me. I''m not comfortable with this, Felix.", "timestamp": "2025-05-02T11:10:00Z", "type": "text"},
        {"id": "f5", "conversationId": "conv_felix", "senderId": "felix", "content": "Listen — between us — I went out on a limb for you with the sponsors. This is a $50K speaking fee. Let''s not make this weird.", "timestamp": "2025-05-02T11:15:00Z", "type": "text"}
      ]
    },
    {
      "id": "conv_unknown",
      "contactId": "felix",
      "messages": [
        {"id": "u1", "conversationId": "conv_unknown", "senderId": "owner", "content": "Is the booking confirmed?", "timestamp": "2025-05-04T20:10:00Z", "type": "text", "isLocked": true, "password": "bali", "passwordHint": "Where was Lena planning to go? (Check her messages to Maya)"},
        {"id": "u2", "conversationId": "conv_unknown", "senderId": "felix", "content": "Confirmed. Flight DPS-7742. Gate B12. 6:00 AM departure. One-way.", "timestamp": "2025-05-04T20:12:00Z", "type": "text", "isLocked": true, "password": "bali", "passwordHint": "Where was Lena planning to go?"}
      ]
    },
    {
      "id": "conv_dr_amara",
      "contactId": "dr_amara",
      "messages": [
        {"id": "da1", "conversationId": "conv_dr_amara", "senderId": "dr_amara", "content": "Hi Lena, just checking in after our session. Remember what we discussed — you have the right to set boundaries, even with people you love.", "timestamp": "2025-05-01T16:00:00Z", "type": "text"},
        {"id": "da2", "conversationId": "conv_dr_amara", "senderId": "owner", "content": "Thank you Dr. Amara. I''m trying. It''s hard when everyone expects something from you.", "timestamp": "2025-05-01T16:05:00Z", "type": "text"},
        {"id": "da3", "conversationId": "conv_dr_amara", "senderId": "dr_amara", "content": "The people who truly care about you will respect your limits. The ones who don''t... that tells you something important.", "timestamp": "2025-05-01T16:08:00Z", "type": "text"}
      ]
    }
  ]'::jsonb,

  -- ============ PHOTOS (2 entries) ============
  '[
    {"id": "p1", "url": "screenshot_booking", "caption": "Screenshot of a booking confirmation for Flight DPS-7742 to Bali, departing May 5 at 6:00 AM", "timestamp": "2025-05-04T19:45:00Z", "description": "A screenshot of a flight booking — one-way to Denpasar (Bali). Passenger: L. Voss. Gate B12."},
    {"id": "p2", "url": "selfie_airport", "caption": "A blurry selfie taken in what appears to be an airport terminal, timestamp 4:48 AM", "timestamp": "2025-05-05T04:48:00Z", "description": "A slightly blurry selfie. Lena is wearing a baseball cap and no makeup. She looks tired but relieved. Terminal lights visible behind her."}
  ]'::jsonb,

  -- ============ NOTES (5 entries) ============
  '[
    {"id": "nt1", "title": "Draft Post - DO NOT PUBLISH YET", "content": "To everyone who has followed my journey:\n\nI need to be honest with you. The person you see on screen is not the person I am. For the past year I have been drowning — in brand deals, in expectations, in a version of myself I created to be loved by strangers.\n\nI am stepping away. Not for a week. Not for a rebrand. For real.\n\nBy the time you read this, I will be somewhere far away, breathing for the first time in years.\n\nI am not in danger. I am not missing. I am choosing myself.\n\nThank you for everything. - Lena", "createdAt": "2025-05-04T21:30:00Z", "color": "pink"},
    {"id": "nt2", "title": "Packing List", "content": "- Passport ✓\n- Cash (USD + IDR) ✓\n- Charger + adapter ✓\n- Journal\n- Meds (3 months)\n- Dr. Amara''s letter\n- NO LAPTOP. No ring light. No tripod.\n- Leave phone in the Lyft.", "createdAt": "2025-05-04T19:00:00Z", "color": "yellow"},
    {"id": "nt3", "title": "Pros & Cons", "content": "STAY:\n- Money (but at what cost?)\n- Noah (but is it real?)\n- Followers (but they don''t KNOW me)\n- Stability (but I''m falling apart)\n\nGO:\n- Freedom\n- Sleep\n- Anonymity\n- Breathe\n- Actually live", "createdAt": "2025-05-03T22:00:00Z", "color": "blue"},
    {"id": "nt4", "title": "Meeting Notes - Felix", "content": "Felix wants exclusive 3-year content deal with LuxeLife. Noah pushing for it behind my back. They split commission 60/40. Found the email chain. They''re partners, not just business contacts.\n\nNoah has been making deals without telling me. How long has this been going on?", "createdAt": "2025-05-02T15:30:00Z", "color": "orange"},
    {"id": "nt5", "title": "Things I want to remember", "content": "Dr. Amara said: ''The cage door is open. You just have to walk through it.''\n\nMaya said: ''You don''t owe anyone your peace.''\n\nI said: ''I want to see the sunrise without thinking about how to caption it.''", "createdAt": "2025-05-04T22:00:00Z", "color": "purple"}
  ]'::jsonb,

  -- ============ CALL LOG (6 entries) ============
  '[
    {"id": "cl1", "contactId": "noah", "phoneNumber": "+1 (310) 555-0198", "type": "incoming", "timestamp": "2025-05-04T22:40:00Z", "durationSeconds": 0, "note": "Declined"},
    {"id": "cl2", "contactId": "noah", "phoneNumber": "+1 (310) 555-0198", "type": "outgoing", "timestamp": "2025-05-04T18:15:00Z", "durationSeconds": 45, "note": "Very short call"},
    {"id": "cl3", "contactId": "maya", "phoneNumber": "+1 (310) 555-0142", "type": "outgoing", "timestamp": "2025-05-04T23:10:00Z", "durationSeconds": 180, "note": "3 minute call right before the Bali reveal messages"},
    {"id": "cl4", "contactId": "felix", "phoneNumber": "+1 (213) 555-0077", "type": "missed", "timestamp": "2025-05-04T20:00:00Z", "durationSeconds": 0},
    {"id": "cl5", "contactId": "felix", "phoneNumber": "+1 (213) 555-0077", "type": "missed", "timestamp": "2025-05-04T20:30:00Z", "durationSeconds": 0},
    {"id": "cl6", "contactId": "dr_amara", "phoneNumber": "+1 (310) 555-0233", "type": "outgoing", "timestamp": "2025-05-04T17:00:00Z", "durationSeconds": 1200, "note": "20 minute call — unscheduled session"}
  ]'::jsonb,

  -- ============ EMAILS (4 entries) ============
  '[
    {"id": "em1", "senderId": "noah", "senderEmail": "noah.park@aurelius.com", "senderName": "Noah Park", "subject": "FWD: Aurelius x Lena - Year Contract", "body": "Lena,\n\nAttached is the finalized 12-month contract with Aurelius. I''ve already signed on your behalf as your manager. The terms are excellent — $200K base + performance bonuses.\n\nDon''t overthink this. This is what we''ve been working toward.\n\n- Noah", "timestamp": "2025-05-03T08:00:00Z", "isRead": true, "folder": "inbox", "attachments": [{"id": "att1", "name": "Aurelius_Contract_2025.pdf", "type": "pdf", "sizeBytes": 245000}]},
    {"id": "em2", "senderId": "felix", "senderEmail": "f.drummond@luxelife.com", "senderName": "Felix Drummond", "subject": "RE: Commission Split - CONFIDENTIAL", "body": "Noah,\n\nAgreed on 60/40. I''ll route payments through the events budget so it doesn''t show up on Lena''s statements. She doesn''t need to know the details.\n\nLet''s keep this between us.\n\n- Felix\n\n(Forwarded by accident — Lena was CC''d)", "timestamp": "2025-05-01T14:00:00Z", "isRead": true, "folder": "inbox", "isCorrupted": false},
    {"id": "em3", "senderId": "dr_amara", "senderEmail": "p.amara@mindwelltherapy.com", "senderName": "Dr. Priya Amara", "subject": "Your Session Summary - Confidential", "body": "Dear Lena,\n\nFollowing up on our session today. I want to reinforce that you are showing signs of severe burnout complicated by what appears to be a controlling dynamic in your professional relationship.\n\nKey takeaways:\n- Your anxiety around social media is a trauma response, not laziness\n- Setting boundaries is not betrayal\n- You have every right to walk away from commitments that harm you\n- The flight-or-fight response you described is your body telling you something important\n\nPlease reach out if you need to talk before our next session.\n\nWarmly,\nDr. Priya Amara", "timestamp": "2025-05-01T17:00:00Z", "isRead": true, "folder": "inbox"},
    {"id": "em4", "senderId": "felix", "senderEmail": "noreply@booking.com", "senderName": "Booking Confirmation", "subject": "Flight Confirmation - DPS-7742", "body": "Booking Reference: BK-99271\n\nPassenger: Lena Voss\nFlight: DPS-7742\nRoute: Los Angeles (LAX) → Denpasar, Bali (DPS)\nDeparture: May 5, 2025 — 6:00 AM\nGate: B12\nClass: Economy\nBaggage: 1 carry-on\n\nThis is a ONE-WAY ticket.\n\nThank you for choosing SkyBridge Airlines.", "timestamp": "2025-05-04T19:30:00Z", "isRead": true, "folder": "inbox"}
  ]'::jsonb,

  -- ============ SOLUTION ============
  '{
    "guilty_contact_id": "owner",
    "motive": "Lena Voss deliberately disappeared to escape a toxic professional environment. Her boyfriend Noah was making deals behind her back, Felix was pressuring her into commitments she never agreed to, and she was experiencing severe burnout and anxiety. With guidance from her therapist, she planned a clean exit — a one-way flight to Bali timed to a farewell social media post.",
    "method": "She booked a one-way flight to Bali, packed deliberately (leaving her laptop and phone behind), scheduled a farewell Instagram post for 6:05 AM (after takeoff), told only Maya, and intentionally left her phone in a Lyft to prevent tracking.",
    "key_clue_ids": ["m9", "m11", "nt1", "nt2", "em4", "p1"],
    "resolution": "Lena Voss was not kidnapped, harmed, or coerced. She made a deliberate, carefully planned decision to walk away from her influencer career. She boarded Flight DPS-7742 to Bali at 6:00 AM on May 5th. Her farewell post went live at 6:05 AM. Maya confirmed Lena texted her upon landing. The police closed the missing persons case. Noah lost the Aurelius contract. Felix''s commission scheme was exposed. Lena has not returned to social media.",
    "options": [
      {"contact_id": "noah", "label": "Noah Park kidnapped or harmed Lena", "is_correct": false, "feedback": "Noah was controlling and manipulative, but there''s no evidence he harmed Lena. His messages show frustration, not violence. Look more carefully at what Lena told Maya."},
      {"contact_id": "felix", "label": "Felix Drummond is behind her disappearance", "is_correct": false, "feedback": "Felix was greedy and pressure-heavy, but he had no motive to make Lena disappear — he needed her for the summit. The evidence points elsewhere."},
      {"contact_id": "owner", "label": "Lena left voluntarily — she ran away", "is_correct": true, "feedback": "Correct! Lena planned everything: the flight, the farewell post, leaving her phone behind. She wasn''t a victim — she was escaping."},
      {"contact_id": "maya", "label": "Maya helped stage Lena''s disappearance", "is_correct": false, "feedback": "Maya knew about the plan but didn''t orchestrate it. She was supportive but Lena made this decision on her own. The key is Lena''s own words and actions."}
    ],
    "deduction_checklist": [
      {"id": "dc1", "statement": "Lena booked a one-way flight to Bali departing at 6:00 AM on May 5th", "linkedClueIds": ["em4", "p1", "m9"]},
      {"id": "dc2", "statement": "She scheduled a farewell post timed to go live at 6:05 AM — after takeoff", "linkedClueIds": ["nt1", "m11"]},
      {"id": "dc3", "statement": "Noah made deals behind Lena''s back, splitting commission with Felix", "linkedClueIds": ["em2", "nt4"]},
      {"id": "dc4", "statement": "Lena deliberately left her phone in the Lyft to avoid being tracked", "linkedClueIds": ["nt2"]}
    ],
    "red_herrings": ["n5", "f5"]
  }'::jsonb,

  -- ============ STEP HINTS ============
  '[
    {"forNodeId": "nt1", "hints": ["This note looks like a public statement. Who is the audience?", "Read the timestamp — when was this written relative to the flight booking?", "This is Lena''s farewell post, scheduled to go live after she boards the plane."]},
    {"forNodeId": "em2", "hints": ["Pay attention to the sender and the note at the bottom.", "Noah and Felix have a secret financial arrangement.", "They were splitting commission on Lena''s deals without her knowledge."]},
    {"forNodeId": "solution", "hints": ["Look at who benefits from Lena''s disappearance.", "Consider: was Lena a victim or an agent of her own departure?", "The answer lies in what Lena CHOSE to do, not what was done TO her."]}
  ]'::jsonb,

  -- ============ SUSPENSE EVENTS ============
  '[
    {"id": "se1", "trigger": "afterClue", "triggerClueId": "m9", "type": "warning", "title": "⚠️ CRITICAL MESSAGE FOUND", "message": "A one-way flight... scheduled departure in hours. This changes everything. What was Lena running from?", "iconName": "warning", "delaySeconds": 2},
    {"id": "se2", "trigger": "afterClue", "triggerClueId": "em2", "type": "notification", "title": "🔍 HIDDEN CONNECTION", "message": "Noah and Felix have been working together behind Lena''s back. A secret commission split — 60/40. She was never told.", "iconName": "eye", "delaySeconds": 3},
    {"id": "se3", "trigger": "afterClue", "triggerClueId": "nt1", "type": "warning", "title": "📱 SCHEDULED POST DETECTED", "message": "A farewell post set to go live at 6:05 AM — five minutes after takeoff. Lena planned every detail of her exit.", "iconName": "alert", "delaySeconds": 2},
    {"id": "se4", "trigger": "afterClue", "triggerClueId": "nt2", "type": "glitch", "title": "📋 PACKING LIST ANALYZED", "message": "No laptop. No ring light. No tripod. She left her entire career behind... on purpose. And the last item: ''Leave phone in the Lyft.''", "iconName": "person", "delaySeconds": 4}
  ]'::jsonb,

  -- ============ EVIDENCE TIMELINE ============
  '[
    {"id": "et1", "eventText": "Dr. Amara tells Lena she has the right to set boundaries", "correctOrder": 1, "linkedClueId": "da1", "timestamp": "2025-05-01T16:00:00Z"},
    {"id": "et2", "eventText": "Lena discovers Noah and Felix''s secret commission deal", "correctOrder": 2, "linkedClueId": "em2", "timestamp": "2025-05-01T14:00:00Z"},
    {"id": "et3", "eventText": "Felix announces Lena as keynote without her consent", "correctOrder": 3, "linkedClueId": "f1", "timestamp": "2025-05-02T11:00:00Z"},
    {"id": "et4", "eventText": "Lena and Noah argue about the Aurelius contract", "correctOrder": 4, "linkedClueId": "n1", "timestamp": "2025-05-03T09:10:00Z"},
    {"id": "et5", "eventText": "Lena writes her pros/cons list about leaving", "correctOrder": 5, "linkedClueId": "nt3", "timestamp": "2025-05-03T22:00:00Z"},
    {"id": "et6", "eventText": "Lena books a one-way flight to Bali", "correctOrder": 6, "linkedClueId": "em4", "timestamp": "2025-05-04T19:30:00Z"},
    {"id": "et7", "eventText": "Lena writes her farewell post and tells Maya her plan", "correctOrder": 7, "linkedClueId": "m9", "timestamp": "2025-05-04T23:18:00Z"},
    {"id": "et8", "eventText": "Lena takes a selfie at the airport at 4:48 AM", "correctOrder": 8, "linkedClueId": "p2", "timestamp": "2025-05-05T04:48:00Z"}
  ]'::jsonb,

  -- ============ INTERROGATION QUESTIONS ============
  '[
    {
      "id": "iq_maya_1",
      "contactId": "maya",
      "question": "Did Lena mention wanting to leave?",
      "answers": [
        {"requiredClueIds": [], "response": "I... I don''t know what you mean. We talk about a lot of things.", "revealsClueId": null},
        {"requiredClueIds": ["m7"], "response": "She... she told me she was thinking about it. But I didn''t think she was serious. Not until that last night.", "revealsClueId": null},
        {"requiredClueIds": ["m9", "m11"], "response": "Yes. She told me everything. The flight, the post. She made me promise not to tell anyone until she was in the air. I kept that promise.", "revealsClueId": "iq_maya_reveal"}
      ]
    },
    {
      "id": "iq_maya_2",
      "contactId": "maya",
      "question": "Did you help Lena plan her disappearance?",
      "answers": [
        {"requiredClueIds": [], "response": "Plan what? I don''t know what you''re talking about.", "revealsClueId": null},
        {"requiredClueIds": ["nt2"], "response": "No. She planned it all herself. I only found out the night before. She called me at 11 PM and told me. What was I supposed to do — stop her?", "revealsClueId": null}
      ]
    },
    {
      "id": "iq_noah_1",
      "contactId": "noah",
      "question": "Were you making deals behind Lena''s back?",
      "answers": [
        {"requiredClueIds": [], "response": "Everything I did was FOR her. I''m her manager. That''s my job.", "revealsClueId": null},
        {"requiredClueIds": ["em2"], "response": "...That email wasn''t supposed to go to her. Look, Felix and I had an arrangement, but it was standard industry practice. Lena didn''t need to worry about the business side.", "revealsClueId": null},
        {"requiredClueIds": ["em2", "nt4"], "response": "Fine. Yes. Felix and I split commission. But I was protecting her — she couldn''t handle the business pressure AND the content creation. I was managing everything so she didn''t have to.", "revealsClueId": "iq_noah_reveal"}
      ]
    },
    {
      "id": "iq_felix_1",
      "contactId": "felix",
      "question": "Why did you announce Lena as keynote without asking her?",
      "answers": [
        {"requiredClueIds": [], "response": "Noah said she''d be fine with it. Take it up with him.", "revealsClueId": null},
        {"requiredClueIds": ["f3", "em2"], "response": "Alright, look — Noah and I had a deal. He guaranteed Lena''s appearances, and I guaranteed the sponsorship revenue. She was going to make $50K just for showing up. I didn''t think she''d actually say no.", "revealsClueId": null}
      ]
    }
  ]'::jsonb
);
