-- ============================================================
-- Phone Detective: Case 1 — "The Last Login"
-- ============================================================
-- Run this in Supabase SQL Editor (or psql).
--
-- STEP 1: Run schema.sql first — it handles all ALTER TABLE
--         migrations (battery_start_percent, battery_drain_per_minute, etc.)
--
-- STEP 2: Run this file to delete the old Case 1 and insert
--         the new one.
--
-- STEP 3: For existing Cases 2+, see the guidance block at
--         the bottom of this file.
-- ============================================================

-- ── Remove old Case 1 ────────────────────────────────────────
DELETE FROM public.cases WHERE case_number = 1;

-- ── Insert new Case 1 ────────────────────────────────────────
INSERT INTO public.cases (
  case_number,
  title,
  subtitle,
  description,
  scenario,
  objective,
  difficulty,
  unlock_requires,
  theme_color_hex,
  hints,
  battery_start_percent,
  battery_drain_per_minute,
  contacts,
  conversations,
  photos,
  notes,
  call_log,
  emails,
  solution,
  step_hints,
  handler_briefing,
  suspense_events,
  evidence_timeline,
  interrogation_questions
) VALUES (
  1,

  -- ── Metadata ──────────────────────────────────────────────
  'The Last Login',
  'A developer is dead. His phone knows why.',
  'Marcus Chen, 34, lead developer at NovaTech, was found at the bottom of his apartment stairwell Monday morning. His phone was on his bed — last active at 11:58 PM Sunday. Police are calling it an accident. You don''t buy it.',
  'Marcus Chen was found face-down at the base of his apartment stairwell at 9:23 AM Monday, March 24th, 2026. Preliminary ruling: accidental fall. But his phone was discovered on his bed — not near the body. The last message on it arrived at 11:58 PM Sunday night. Someone was in that apartment. Someone who had every reason to be there, and every reason to make sure Marcus never made it to Monday morning.',
  'Determine who was present at Marcus Chen''s apartment on the night of March 23rd and establish their motive.',
  'easy',
  '[]',
  '#4A9EFF',
  '[
    "Start with the most recent conversations — the 48 hours before his death tell a complete story.",
    "Someone was trying to stop Marcus before a Monday morning meeting. Find out what that meeting was about.",
    "The motive is scattered across every app on this phone — not in one place, but in all of them."
  ]',

  -- ── Battery ───────────────────────────────────────────────
  -- Phone starts at 85%. Drains 1.2% per minute.
  -- Gentle pressure — player has ~70 minutes before the phone dies.
  85,
  1.2,

  -- ── Contacts ──────────────────────────────────────────────
  '[
    {
      "id": "owner",
      "firstName": "Marcus",
      "lastName": "Chen",
      "phoneNumber": "+1 (415) 555-0192",
      "email": "marcus.chen@novatech.io",
      "relationship": "Phone Owner",
      "notes": "Lead Developer at NovaTech. Age 34. Methodical, principled. Had scheduled a 9:00 AM board presentation Monday morning. Never made it.",
      "birthday": "1991-11-14",
      "avatarColorHex": "#4FC3F7"
    },
    {
      "id": "claire",
      "firstName": "Claire",
      "lastName": "Huang",
      "phoneNumber": "+1 (415) 555-0234",
      "email": "claire.huang@gmail.com",
      "relationship": "Girlfriend",
      "notes": "Has been dating Marcus for two years. Was supposed to come over Sunday evening. He cancelled. She called at 3 AM when she couldn''t sleep.",
      "birthday": "1993-03-08",
      "avatarColorHex": "#F48FB1"
    },
    {
      "id": "daniel",
      "firstName": "Daniel",
      "lastName": "Voss",
      "phoneNumber": "+1 (415) 555-0187",
      "email": "daniel.voss@novatech.io",
      "relationship": "CTO — NovaTech",
      "notes": "Marcus''s direct superior. Built NovaTech from seed stage to Series A. Demanding, controlling, and deeply invested in the company''s reputation.",
      "birthday": "1982-07-19",
      "avatarColorHex": "#CE93D8"
    },
    {
      "id": "priya",
      "firstName": "Priya",
      "lastName": "Patel",
      "phoneNumber": "+1 (415) 555-0361",
      "email": "priya.patel@novatech.io",
      "relationship": "Coworker — Senior Engineer",
      "notes": "Senior engineer, reports to Marcus. Close professional confidant. Marcus reached out to her the night he made the discovery.",
      "birthday": "1990-09-22",
      "avatarColorHex": "#A5D6A7"
    },
    {
      "id": "unknown",
      "firstName": "Unknown",
      "lastName": "Caller",
      "phoneNumber": "+1 (408) 555-0912",
      "email": "",
      "relationship": "Unknown",
      "notes": "Called twice in the early hours of Monday March 24th. No voicemail. Number traces to a prepaid SIM purchased with cash.",
      "birthday": null,
      "avatarColorHex": "#90A4AE"
    },
    {
      "id": "mom",
      "firstName": "Elaine",
      "lastName": "Chen",
      "phoneNumber": "+1 (626) 555-0083",
      "email": "elaine.chen62@gmail.com",
      "relationship": "Mother",
      "notes": "Lives in Pasadena. Spoke to Marcus Saturday. Thought he seemed distracted. He promised to call Sunday. He never did.",
      "birthday": "1962-04-30",
      "avatarColorHex": "#FFCC80"
    }
  ]',

  -- ── Conversations ─────────────────────────────────────────
  '[
    {
      "id": "conv_claire",
      "contactId": "claire",
      "messages": [
        {
          "id": "mc_c1", "conversationId": "conv_claire", "senderId": "owner",
          "content": "Hey, still on for tonight? Thinking Sotto Mare?",
          "timestamp": "2026-03-22T14:45:00Z", "type": "text"
        },
        {
          "id": "mc_c2", "conversationId": "conv_claire", "senderId": "claire",
          "content": "YES. I''ve been thinking about their cioppino all week 😭",
          "timestamp": "2026-03-22T14:52:00Z", "type": "text"
        },
        {
          "id": "mc_c3", "conversationId": "conv_claire", "senderId": "owner",
          "content": "God I''m sorry. Daniel called. Major fire at work. Can''t make it tonight.",
          "timestamp": "2026-03-22T20:44:00Z", "type": "text"
        },
        {
          "id": "mc_c4", "conversationId": "conv_claire", "senderId": "claire",
          "content": "Marcus. This is the third weekend in a row.",
          "timestamp": "2026-03-22T20:49:00Z", "type": "text"
        },
        {
          "id": "mc_c5", "conversationId": "conv_claire", "senderId": "owner",
          "content": "I know. I''m sorry. Something huge came up. I''ll explain everything soon, I promise.",
          "timestamp": "2026-03-22T21:02:00Z", "type": "text"
        },
        {
          "id": "mc_c6", "conversationId": "conv_claire", "senderId": "claire",
          "content": "Morning. You okay? You seemed off last night.",
          "timestamp": "2026-03-23T11:30:00Z", "type": "text"
        },
        {
          "id": "mc_c7", "conversationId": "conv_claire", "senderId": "owner",
          "content": "Better. Come over tonight? I need to tell you something.",
          "timestamp": "2026-03-23T11:47:00Z", "type": "text"
        },
        {
          "id": "mc_c8", "conversationId": "conv_claire", "senderId": "claire",
          "content": "Now you''re scaring me. Is everything okay?",
          "timestamp": "2026-03-23T11:51:00Z", "type": "text"
        },
        {
          "id": "mc_c9", "conversationId": "conv_claire", "senderId": "owner",
          "content": "It''s fine. Just... big. I found something at work. I''m handling it. See you at 8?",
          "timestamp": "2026-03-23T11:55:00Z", "type": "text"
        },
        {
          "id": "mc_c10", "conversationId": "conv_claire", "senderId": "claire",
          "content": "Of course. I''ll bring wine. Love you ❤️",
          "timestamp": "2026-03-23T12:01:00Z", "type": "text"
        },
        {
          "id": "mc_c11", "conversationId": "conv_claire", "senderId": "owner",
          "content": "Love you too.",
          "timestamp": "2026-03-23T12:03:00Z", "type": "text"
        },
        {
          "id": "mc_c12", "conversationId": "conv_claire", "senderId": "owner",
          "content": "Hey... I have to cancel tonight. I''m so sorry. Daniel just texted. He''s coming over — says it''s urgent.",
          "timestamp": "2026-03-23T19:44:00Z", "type": "text"
        },
        {
          "id": "mc_c13", "conversationId": "conv_claire", "senderId": "claire",
          "content": "Are you serious right now? Marcus this is the second time this weekend.",
          "timestamp": "2026-03-23T19:49:00Z", "type": "text"
        },
        {
          "id": "mc_c14", "conversationId": "conv_claire", "senderId": "owner",
          "content": "I know. I''ll explain everything tomorrow. I promise. I just need to deal with this tonight.",
          "timestamp": "2026-03-23T19:51:00Z", "type": "text"
        },
        {
          "id": "mc_c15", "conversationId": "conv_claire", "senderId": "claire",
          "content": "Fine. But we''re talking tomorrow. For real.",
          "timestamp": "2026-03-23T19:56:00Z", "type": "text"
        },
        {
          "id": "mc_c16", "conversationId": "conv_claire", "senderId": "owner",
          "content": "Tomorrow. 100%. Get some sleep ❤️",
          "timestamp": "2026-03-23T19:58:00Z", "type": "text"
        }
      ]
    },

    {
      "id": "conv_daniel",
      "contactId": "daniel",
      "messages": [
        {
          "id": "md_d1", "conversationId": "conv_daniel", "senderId": "daniel",
          "content": "Need to talk about the Apex deployment. Can you check the auth token refresh logic when you get a chance?",
          "timestamp": "2026-03-22T20:47:00Z", "type": "text"
        },
        {
          "id": "md_d2", "conversationId": "conv_daniel", "senderId": "owner",
          "content": "Already on it. Found something weird in the commit history actually. Can we talk Monday?",
          "timestamp": "2026-03-22T20:51:00Z", "type": "text"
        },
        {
          "id": "md_d3", "conversationId": "conv_daniel", "senderId": "daniel",
          "content": "What kind of weird? We have a deployment window tonight, I need to know if it''s blocking.",
          "timestamp": "2026-03-22T20:55:00Z", "type": "text"
        },
        {
          "id": "md_d4", "conversationId": "conv_daniel", "senderId": "owner",
          "content": "It''s not a deployment issue. It can wait.",
          "timestamp": "2026-03-22T21:03:00Z", "type": "text"
        },
        {
          "id": "md_d5", "conversationId": "conv_daniel", "senderId": "daniel",
          "content": "Marcus. What did you find.",
          "timestamp": "2026-03-22T21:09:00Z", "type": "text"
        },
        {
          "id": "md_d6", "conversationId": "conv_daniel", "senderId": "owner",
          "content": "Like I said. Let''s talk Monday.",
          "timestamp": "2026-03-22T21:14:00Z", "type": "text"
        },
        {
          "id": "md_d7", "conversationId": "conv_daniel", "senderId": "daniel",
          "content": "We need to talk. Tonight. I''m coming to your place.",
          "timestamp": "2026-03-23T19:31:00Z", "type": "text"
        },
        {
          "id": "md_d8", "conversationId": "conv_daniel", "senderId": "owner",
          "content": "Tonight''s not good. I have plans.",
          "timestamp": "2026-03-23T19:33:00Z", "type": "text"
        },
        {
          "id": "md_d9", "conversationId": "conv_daniel", "senderId": "daniel",
          "content": "Cancel them. This is important. I''ll be there at 8.",
          "timestamp": "2026-03-23T19:35:00Z", "type": "text"
        },
        {
          "id": "md_d10", "conversationId": "conv_daniel", "senderId": "owner",
          "content": "Daniel —",
          "timestamp": "2026-03-23T19:36:00Z", "type": "text"
        },
        {
          "id": "md_d11", "conversationId": "conv_daniel", "senderId": "daniel",
          "content": "Don''t make this into something it doesn''t have to be. 8 o''clock.",
          "timestamp": "2026-03-23T19:39:00Z", "type": "text"
        },
        {
          "id": "m_daniel_outside", "conversationId": "conv_daniel", "senderId": "daniel",
          "content": "I''m outside.",
          "timestamp": "2026-03-23T22:58:00Z", "type": "text"
        }
      ]
    },

    {
      "id": "conv_priya",
      "contactId": "priya",
      "messages": [
        {
          "id": "mp_p1", "conversationId": "conv_priya", "senderId": "priya",
          "content": "Your review comments on my PR are brutal, just saying 😭",
          "timestamp": "2026-03-20T16:23:00Z", "type": "text"
        },
        {
          "id": "mp_p2", "conversationId": "conv_priya", "senderId": "owner",
          "content": "brutal = thorough. You''ll thank me when it ships clean.",
          "timestamp": "2026-03-20T16:41:00Z", "type": "text"
        },
        {
          "id": "mp_p3", "conversationId": "conv_priya", "senderId": "priya",
          "content": "You''re going to regret this, Marcus.",
          "timestamp": "2026-03-20T16:44:00Z", "type": "text"
        },
        {
          "id": "mp_p4", "conversationId": "conv_priya", "senderId": "owner",
          "content": "😂 noted.",
          "timestamp": "2026-03-20T16:45:00Z", "type": "text"
        },
        {
          "id": "mp_p5", "conversationId": "conv_priya", "senderId": "owner",
          "content": "Hey, weird question — you have access to the Apex repo history right?",
          "timestamp": "2026-03-22T23:48:00Z", "type": "text"
        },
        {
          "id": "mp_p6", "conversationId": "conv_priya", "senderId": "priya",
          "content": "Yeah why? What''s going on?",
          "timestamp": "2026-03-22T23:54:00Z", "type": "text"
        },
        {
          "id": "mp_p7", "conversationId": "conv_priya", "senderId": "owner",
          "content": "Pull up commits from Dec 15 to Jan 4. Look at anything from dvoss@novatech.io and diff it against the Meridian core-auth repo.",
          "timestamp": "2026-03-22T23:57:00Z", "type": "text"
        },
        {
          "id": "mp_p8", "conversationId": "conv_priya", "senderId": "priya",
          "content": "Oh my god.",
          "timestamp": "2026-03-23T00:03:00Z", "type": "text"
        },
        {
          "id": "mp_p9", "conversationId": "conv_priya", "senderId": "owner",
          "content": "Yeah.",
          "timestamp": "2026-03-23T00:04:00Z", "type": "text"
        },
        {
          "id": "mp_p10", "conversationId": "conv_priya", "senderId": "priya",
          "content": "Is this what I think it is?",
          "timestamp": "2026-03-23T00:05:00Z", "type": "text"
        },
        {
          "id": "mp_p11", "conversationId": "conv_priya", "senderId": "owner",
          "content": "He copied the Meridian auth module almost verbatim. Their proprietary rate-limiting logic — over 40 commits between December and January. It''s not a coincidence.",
          "timestamp": "2026-03-23T00:06:00Z", "type": "text"
        },
        {
          "id": "mp_p12", "conversationId": "conv_priya", "senderId": "priya",
          "content": "Marcus... do you have any idea how big this is? If this gets out NovaTech could be sued into the ground.",
          "timestamp": "2026-03-23T00:09:00Z", "type": "text"
        },
        {
          "id": "mp_p13", "conversationId": "conv_priya", "senderId": "owner",
          "content": "Which is exactly why I''m taking it to the board Monday morning. I have screenshots. I have the commit diffs.",
          "timestamp": "2026-03-23T00:11:00Z", "type": "text"
        },
        {
          "id": "mp_p14", "conversationId": "conv_priya", "senderId": "priya",
          "content": "Be careful. Daniel is not just going to let this go.",
          "timestamp": "2026-03-23T00:13:00Z", "type": "text"
        },
        {
          "id": "mp_p15", "conversationId": "conv_priya", "senderId": "owner",
          "content": "I know. But I''m not going to bury it either.",
          "timestamp": "2026-03-23T00:15:00Z", "type": "text"
        },
        {
          "id": "mp_p16", "conversationId": "conv_priya", "senderId": "priya",
          "content": "I''ve got your back, whatever you need. Just... watch yourself, okay?",
          "timestamp": "2026-03-23T00:17:00Z", "type": "text"
        },
        {
          "id": "mp_p17", "conversationId": "conv_priya", "senderId": "priya",
          "content": "Hey, you go dark? Checking in. Let me know you''re okay.",
          "timestamp": "2026-03-24T06:42:00Z", "type": "text"
        }
      ]
    },

    {
      "id": "conv_mom",
      "contactId": "mom",
      "messages": [
        {
          "id": "mm_m1", "conversationId": "conv_mom", "senderId": "mom",
          "content": "Hi sweetheart! Dad and I are watching that detective show you recommended. Very good! Are you eating?",
          "timestamp": "2026-03-22T10:05:00Z", "type": "text"
        },
        {
          "id": "mm_m2", "conversationId": "conv_mom", "senderId": "owner",
          "content": "Hi Mom 😄 Yes eating fine. Glad you like it.",
          "timestamp": "2026-03-22T10:31:00Z", "type": "text"
        },
        {
          "id": "mm_m3", "conversationId": "conv_mom", "senderId": "mom",
          "content": "You look tired in your last photo. You working too much?",
          "timestamp": "2026-03-22T10:33:00Z", "type": "text"
        },
        {
          "id": "mm_m4", "conversationId": "conv_mom", "senderId": "owner",
          "content": "A little. Big stuff happening at work. All good though.",
          "timestamp": "2026-03-22T10:38:00Z", "type": "text"
        },
        {
          "id": "mm_m5", "conversationId": "conv_mom", "senderId": "mom",
          "content": "Don''t let that company take everything from you. Family first! Call me Sunday?",
          "timestamp": "2026-03-22T10:41:00Z", "type": "text"
        },
        {
          "id": "mm_m6", "conversationId": "conv_mom", "senderId": "owner",
          "content": "I will Mom. Love you.",
          "timestamp": "2026-03-22T10:43:00Z", "type": "text"
        },
        {
          "id": "mm_m7", "conversationId": "conv_mom", "senderId": "mom",
          "content": "Marcus? Thought you were calling today. Did you forget? 😅",
          "timestamp": "2026-03-23T18:05:00Z", "type": "text"
        }
      ]
    }
  ]',

  -- ── Photos ────────────────────────────────────────────────
  '[
    {
      "id": "ph_github",
      "caption": "GitHub — dvoss commits to external repo",
      "description": "A screenshot of GitHub showing a commit history from the account dvoss@novatech.io. The repository is not NovaTech''s — it belongs to a company called Meridian Technologies. Repository name: meridiantech/core-auth-v2. Commits run from December 15, 2025 through January 4, 2026. 43 commits total. The repository is marked private.",
      "timestamp": "2026-03-22T23:45:00Z"
    },
    {
      "id": "ph_diff",
      "caption": "Code comparison: Meridian vs NovaTech Apex",
      "description": "A side-by-side code comparison captured by Marcus. Left panel: Meridian Technologies'' proprietary authentication rate-limiter, file dated November 2024, stamped CONFIDENTIAL. Right panel: NovaTech Apex product file apex/src/auth/rate_limit.js, dated January 3, 2026. The logic is nearly identical. Variable names changed. Comments removed. Six function signatures are copied verbatim — word for word.",
      "timestamp": "2026-03-23T00:00:00Z"
    },
    {
      "id": "ph_slack_dm",
      "caption": "Slack DM — Daniel to Marcus, Jan 5",
      "description": "A screenshot of a Slack direct message from Daniel Voss to Marcus Chen, January 5, 2026 at 11:42 AM. The message reads: \"The new auth module is live on Apex. Don''t look too closely at where the rate-limiting logic came from. Some things are better left alone, yeah? 😉\" Marcus took this screenshot and sent it to Priya the same night he discovered the commit history.",
      "timestamp": "2026-03-23T00:05:00Z"
    },
    {
      "id": "ph_calendar",
      "caption": "Calendar — Monday March 24",
      "description": "Marcus''s phone calendar showing Monday March 24, 2026. At 9:00 AM there is a meeting block titled ''BOARD — D.V. EVIDENCE''. The notes field reads: ''Bring the Meridian comparison. Print the commit log. Do not back down. This is not just about the company — it is about what is right.'' The meeting was never attended.",
      "timestamp": "2026-03-23T20:00:00Z"
    }
  ]',

  -- ── Notes ─────────────────────────────────────────────────
  '[
    {
      "id": "nt_evidence",
      "title": "Evidence — D.V.",
      "content": "DANIEL VOSS — CODE THEFT SUMMARY\n\nRepo: meridiantech/core-auth-v2 (PRIVATE — not NovaTech)\nCommits: Dec 15, 2025 — Jan 4, 2026\nAccount: dvoss@novatech.io\nTotal commits: 43\n\nFiles copied into Apex:\n- apex/src/auth/rate_limit.js  [from: Meridian auth/rate_limiter.py]\n- apex/src/auth/token_bucket.js  [from: Meridian auth/bucket.py]\n- apex/src/middleware/throttle.js  [partial — ~60% match]\n\nMeridian legal already contacted NovaTech March 18 (see email). They know something is wrong.\n\nACTION MONDAY 9AM:\nPrint everything. Bring the commit log. Bring the Slack DM. Send to legal simultaneously.\n\nThis ends Monday.",
      "createdAt": "2026-03-23T09:00:00Z",
      "color": "orange",
      "isLocked": true,
      "password": "novapro",
      "passwordHint": "The product NovaTech shipped in Q3 2025"
    },
    {
      "id": "nt_todo",
      "title": "Monday — Do This",
      "content": "7:00 AM — Email full evidence backup to personal Gmail (before anything else)\n8:00 AM — Print evidence packet at FedEx on Brannan\n8:30 AM — Get to NovaTech early, find board members before Daniel does\n9:00 AM — Board presentation\n\nAfter:\n- Call Claire\n- Tell Priya the outcome\n- Contact Meridian legal to confirm I acted in good faith",
      "createdAt": "2026-03-23T22:30:00Z",
      "color": "yellow",
      "isLocked": false,
      "password": null,
      "passwordHint": null
    },
    {
      "id": "nt_passwords",
      "title": "Dev Stuff — DO NOT LOSE",
      "content": "GitHub personal: mc_dev_91\nAWS root: Kf$9mXq!2026\nNovaTech VPN: chen_dev + RSA token\nFigma: same as work email\n\n[NovaTech staging]\nDB host: staging-db.novatech.internal\nDB user: marcus_dev\nDB pass: Pr@gmatic91!\n\nPersonal backup drive: under the desk, left side drawer",
      "createdAt": "2026-01-12T14:00:00Z",
      "color": "blue",
      "isLocked": true,
      "password": "13chen1991",
      "passwordHint": "Lucky number + last name + birth year"
    }
  ]',

  -- ── Call Log ──────────────────────────────────────────────
  '[
    {
      "id": "cl_dan_sat",
      "contactId": "daniel",
      "phoneNumber": "+1 (415) 555-0187",
      "type": "incoming",
      "timestamp": "2026-03-22T20:38:00Z",
      "durationSeconds": 374,
      "note": "6-minute call. This is what cancelled Marcus''s Saturday plans with Claire."
    },
    {
      "id": "cl_dan_sat2",
      "contactId": "daniel",
      "phoneNumber": "+1 (415) 555-0187",
      "type": "outgoing",
      "timestamp": "2026-03-22T21:03:00Z",
      "durationSeconds": 112,
      "note": "Marcus called Daniel back after the texts started."
    },
    {
      "id": "cl_mom_missed",
      "contactId": "mom",
      "phoneNumber": "+1 (626) 555-0083",
      "type": "missed",
      "timestamp": "2026-03-23T18:05:00Z",
      "durationSeconds": 0,
      "note": "The Sunday call he promised her. He never answered."
    },
    {
      "id": "cl_daniel_late",
      "contactId": "daniel",
      "phoneNumber": "+1 (415) 555-0187",
      "type": "incoming",
      "timestamp": "2026-03-23T22:52:00Z",
      "durationSeconds": 183,
      "note": "3-minute call from Daniel — 6 minutes before he texted ''I''m outside.''"
    },
    {
      "id": "cl_unknown_1",
      "contactId": "unknown",
      "phoneNumber": "+1 (408) 555-0912",
      "type": "missed",
      "timestamp": "2026-03-24T01:14:00Z",
      "durationSeconds": 0,
      "note": "Unknown number. Prepaid SIM. No voicemail left."
    },
    {
      "id": "cl_unknown_2",
      "contactId": "unknown",
      "phoneNumber": "+1 (408) 555-0912",
      "type": "missed",
      "timestamp": "2026-03-24T01:47:00Z",
      "durationSeconds": 0,
      "note": "Same unknown number. Called again 33 minutes later."
    },
    {
      "id": "cl_claire_missed",
      "contactId": "claire",
      "phoneNumber": "+1 (415) 555-0234",
      "type": "missed",
      "timestamp": "2026-03-24T03:02:00Z",
      "durationSeconds": 0,
      "note": "Claire called at 3 AM. Said she couldn''t sleep. Marcus never picked up."
    },
    {
      "id": "cl_claire_vm",
      "contactId": "claire",
      "phoneNumber": "+1 (415) 555-0234",
      "type": "voicemail",
      "timestamp": "2026-03-24T03:05:00Z",
      "durationSeconds": 28,
      "transcription": "Marcus, it''s me. I know it''s the middle of the night. Something just felt wrong and I... I needed to hear your voice. I''m sorry about earlier. Call me when you get this. Please. I love you.",
      "note": "Left 3 minutes after the missed call."
    }
  ]',

  -- ── Emails ────────────────────────────────────────────────
  '[
    {
      "id": "em_draft",
      "senderId": "owner",
      "senderEmail": "marcus.chen@novatech.io",
      "senderName": "Marcus Chen",
      "subject": "URGENT: Code Integrity Violation — Immediate Board Review Required",
      "body": "To: board@novatech.io\nCC: legal@novatech.io\n\nBoard Members,\n\nI am writing to report a serious intellectual property violation by a member of NovaTech''s executive leadership.\n\nBetween December 15, 2025 and January 4, 2026, Daniel Voss (CTO) made 43 commits to a private Meridian Technologies repository (meridiantech/core-auth-v2) using his NovaTech company credentials. The code committed during this window was subsequently integrated into NovaTech''s Apex product — specifically the authentication rate-limiting module (apex/src/auth/) — in a manner that constitutes direct IP theft from a competitor.\n\nI have compiled:\n1. GitHub commit history export (see attachment)\n2. Side-by-side code comparison — Meridian source vs. NovaTech Apex\n3. A Slack DM from Daniel Voss (Jan 5) in which he explicitly asks me not to investigate the origin of this code\n\nNote that Meridian Technologies'' legal team has already contacted NovaTech (March 18). The company is exposed. Disclosure now, in good faith, is the only path that limits our liability.\n\nI will present this evidence in full at the 9:00 AM board meeting Monday morning.\n\nMarcus Chen\nLead Developer, NovaTech",
      "timestamp": "2026-03-23T23:00:00Z",
      "isRead": false,
      "folder": "drafts",
      "attachments": [
        {"id": "att1", "name": "github_commits_dvoss_dec15_jan4.pdf", "type": "pdf", "sizeBytes": 387000},
        {"id": "att2", "name": "code_comparison_meridian_vs_apex.pdf", "type": "pdf", "sizeBytes": 512000},
        {"id": "att3", "name": "slack_dm_daniel_jan5.png", "type": "image", "sizeBytes": 84000}
      ],
      "isLocked": false,
      "isCorrupted": false
    },
    {
      "id": "em_daniel_monday",
      "senderId": "daniel",
      "senderEmail": "daniel.voss@novatech.io",
      "senderName": "Daniel Voss",
      "subject": "Board meeting this morning",
      "body": "Marcus,\n\nHaven''t heard from you this morning — board meeting is at 9. You coming? Let me know if you''re running late, I can cover the Apex update in the meantime.\n\nD",
      "timestamp": "2026-03-24T07:15:00Z",
      "isRead": false,
      "folder": "inbox",
      "attachments": [],
      "isLocked": false,
      "isCorrupted": false
    },
    {
      "id": "em_priya_sat",
      "senderId": "priya",
      "senderEmail": "priya.patel@novatech.io",
      "senderName": "Priya Patel",
      "subject": "Re: Apex commit history",
      "body": "Marcus,\n\nI pulled the history like you asked. Exported a zip of the commit diffs — it''s sitting in your Downloads folder on your work laptop. Filename: apex_commits_dvoss_dec_jan.zip.\n\nI also did a manual diff against a Meridian public repo I found on GitHub. There''s enough there. The rate limiter is essentially a direct copy with a surface-level rename.\n\nYou''re doing the right thing. Let me know if you need anything else before Monday.\n\n— P",
      "timestamp": "2026-03-23T00:54:00Z",
      "isRead": true,
      "folder": "inbox",
      "attachments": [],
      "isLocked": false,
      "isCorrupted": false
    },
    {
      "id": "em_meridian_legal",
      "senderId": "meridian_legal",
      "senderEmail": "legalnotice@meridiantech.com",
      "senderName": "Meridian Technologies Legal Affairs",
      "subject": "Re: NovaTech API Integration — Preliminary Review",
      "body": "Dear NovaTech Engineering Team,\n\nFollowing a preliminary technical review, we have identified patterns in NovaTech''s Apex product that closely mirror proprietary components of our core authentication system, specifically the rate-limiting and token bucket implementations.\n\nWe believe there may be grounds for an IP infringement discussion and would like to schedule a call with your engineering leadership at your earliest convenience.\n\nThis communication is confidential and intended solely for authorized NovaTech personnel.\n\nRegards,\nMeridian Technologies Legal Affairs",
      "timestamp": "2026-03-18T16:30:00Z",
      "isRead": true,
      "folder": "inbox",
      "attachments": [],
      "isLocked": false,
      "isCorrupted": false
    },
    {
      "id": "em_newsletter",
      "senderId": "hr_novatech",
      "senderEmail": "noreply@novatech.io",
      "senderName": "NovaTech People Team",
      "subject": "This Week at NovaTech — March 21",
      "body": "Hi team!\n\nHappy Friday. Here''s what''s happening:\n\n🎉 Apex milestone: 10,000 active users — incredible work everyone!\n📋 Q1 performance reviews: book your 1:1 with your manager before April 4\n🍕 All-hands lunch: Tuesday March 25, noon, main floor\n\nHave a great weekend,\nThe People Team",
      "timestamp": "2026-03-20T18:00:00Z",
      "isRead": false,
      "folder": "inbox",
      "attachments": [],
      "isLocked": false,
      "isCorrupted": false
    }
  ]',

  -- ── Solution ──────────────────────────────────────────────
  '{
    "guilty_contact_id": "daniel",
    "motive": "Daniel Voss had stolen proprietary authentication code from Meridian Technologies and embedded it in NovaTech''s Apex product. Marcus Chen discovered the theft through commit history analysis and had compiled extensive evidence — screenshots, code diffs, a Slack DM from Daniel himself — to present to the NovaTech board on Monday morning. Faced with criminal liability, the collapse of everything he built, and no way to stop Marcus through legitimate means, Daniel chose to silence him permanently.",
    "method": "Daniel arrived at Marcus''s apartment at approximately 11:00 PM Sunday, having called ahead at 10:52 PM and texted ''I''m outside'' at 10:58 PM. He entered under the pretense of working things out privately. An argument on the staircase ended with Marcus at the bottom of it. Daniel spent several minutes on Marcus''s phone attempting to delete messages before leaving. By 7:15 AM Monday he was composing a ''checking in'' email — playing the role of a confused, unaware colleague.",
    "key_clue_ids": ["m_daniel_outside", "nt_evidence", "em_draft", "ph_github", "cl_daniel_late"],
    "resolution": "Daniel Voss was arrested at NovaTech offices at 8:47 AM Monday — 43 minutes before the board meeting was scheduled to begin. The unsent draft email recovered from Marcus''s phone was submitted as primary evidence. Meridian Technologies independently confirmed the IP theft. Daniel was charged with first-degree murder and corporate espionage. Priya Patel was appointed interim CTO. Claire Huang was notified by police at 10:15 AM.",
    "red_herrings": ["cl_unknown_1", "cl_unknown_2", "nt_passwords", "mp_p3"],
    "motive_options": [
      {
        "id": "mo1",
        "text": "Silencing a whistleblower — Marcus was about to expose Daniel''s theft of proprietary code to the NovaTech board",
        "is_correct": true
      },
      {
        "id": "mo2",
        "text": "Business rivalry — Daniel wanted to remove Marcus and take full control of NovaTech''s technical direction",
        "is_correct": false
      },
      {
        "id": "mo3",
        "text": "Personal grievance — a long-running dispute over credit for NovaTech''s core product and shared IP",
        "is_correct": false
      },
      {
        "id": "mo4",
        "text": "Financial motive — Marcus had recently updated a financial arrangement that put Daniel at a significant disadvantage",
        "is_correct": false
      }
    ],
    "clue_insights": {},
    "options": [],
    "deduction_checklist": []
  }',

  -- ── Step Hints ────────────────────────────────────────────
  '[
    {
      "forNodeId": "nt_evidence",
      "hints": [
        "This note is locked. The password is connected to something Marcus worked on at NovaTech.",
        "Think about what NovaTech launched publicly in the third quarter of 2025.",
        "The password is: novapro"
      ]
    },
    {
      "forNodeId": "em_draft",
      "hints": [
        "Not everything important is in the inbox.",
        "Marcus started writing something he never got to send. Check every folder.",
        "Look in the Drafts folder. The email is addressed to the NovaTech board."
      ]
    },
    {
      "forNodeId": "ph_github",
      "hints": [
        "The photos on this phone are screenshots Marcus took himself as evidence.",
        "Look for anything screenshotted between Saturday night and Sunday.",
        "It shows Daniel Voss''s work account accessing a private repository at a competitor company."
      ]
    },
    {
      "forNodeId": "m_daniel_outside",
      "hints": [
        "Someone came to Marcus''s apartment Sunday night. Look at who was texting him that evening.",
        "Daniel told Marcus he was coming over earlier. Did he show up?",
        "The message ''I''m outside'' from Daniel was sent at 10:58 PM Sunday — hours before the estimated time of death."
      ]
    },
    {
      "forNodeId": "cl_daniel_late",
      "hints": [
        "Look at who called Marcus in the hours before he died.",
        "Daniel called at 10:52 PM — 6 minutes before texting ''I''m outside.'' Why call AND text?",
        "A 3-minute phone call right before arriving in person. He was warning Marcus. Or negotiating."
      ]
    }
  ]',

  -- ── Handler Briefing ──────────────────────────────────────
  'Detective — Marcus Chen was found at the base of his apartment stairwell at 9:23 AM Monday. Preliminary ruling is accidental fall, but forensics don''t support it. His phone was recovered on his bed — not near the body. Last screen activity logged at 11:58 PM Sunday. Someone was in that apartment and they were not a welcome guest. We need you inside his phone before the DA closes this as an accident. Find out who was there. Find out why. Our window is narrow.',

  -- ── Suspense Events ───────────────────────────────────────
  '[
    {
      "id": "se_outside",
      "trigger": "afterClue",
      "triggerClueId": "m_daniel_outside",
      "type": "warning",
      "title": "SUSPECT PLACED AT SCENE",
      "message": "Daniel Voss texted ''I''m outside'' at 10:58 PM. Police estimate time of death between 1:00 AM and 3:00 AM. Daniel was at that apartment.",
      "iconName": "warning",
      "delaySeconds": 1
    },
    {
      "id": "se_draft",
      "trigger": "afterClue",
      "triggerClueId": "em_draft",
      "type": "notification",
      "title": "UNSENT EMAIL RECOVERED",
      "message": "Marcus wrote this three hours before he died. He had everything — the names, the dates, the code. He was ready. Someone made sure he never sent it.",
      "iconName": "email",
      "delaySeconds": 2
    },
    {
      "id": "se_timed_daniel",
      "trigger": "afterTime",
      "triggerClueId": null,
      "type": "incoming",
      "title": "NEW EMAIL — DANIEL VOSS",
      "message": "Daniel Voss sent a ''checking in'' email at 7:15 AM Monday morning — two hours before police found the body. He''s constructing a paper trail of normalcy.",
      "iconName": "message",
      "delaySeconds": 180
    }
  ]',

  -- ── Evidence Timeline ─────────────────────────────────────
  '[
    {
      "id": "et1",
      "eventText": "Daniel Voss begins copying Meridian Technologies'' proprietary authentication code into NovaTech''s Apex product",
      "correctOrder": 1,
      "linkedClueId": "ph_github",
      "timestamp": "2025-12-15T00:00:00Z"
    },
    {
      "id": "et2",
      "eventText": "Final stolen commit pushed — 43 commits total spanning 20 days",
      "correctOrder": 2,
      "linkedClueId": "ph_diff",
      "timestamp": "2026-01-04T00:00:00Z"
    },
    {
      "id": "et3",
      "eventText": "Daniel messages Marcus on Slack: ''Don''t look too closely at where the rate-limiting logic came from''",
      "correctOrder": 3,
      "linkedClueId": "ph_slack_dm",
      "timestamp": "2026-01-05T11:42:00Z"
    },
    {
      "id": "et4",
      "eventText": "Meridian Technologies legal team sends formal inquiry to NovaTech regarding potential IP infringement",
      "correctOrder": 4,
      "linkedClueId": "em_meridian_legal",
      "timestamp": "2026-03-18T16:30:00Z"
    },
    {
      "id": "et5",
      "eventText": "Marcus discovers Daniel''s commit history while reviewing the Apex auth module",
      "correctOrder": 5,
      "linkedClueId": "ph_github",
      "timestamp": "2026-03-22T20:44:00Z"
    },
    {
      "id": "et6",
      "eventText": "Marcus contacts Priya to verify his findings — she confirms at midnight",
      "correctOrder": 6,
      "linkedClueId": "mp_p8",
      "timestamp": "2026-03-23T00:03:00Z"
    },
    {
      "id": "et7",
      "eventText": "Marcus creates locked evidence note and drafts email to the board — plans to present Monday at 9 AM",
      "correctOrder": 7,
      "linkedClueId": "nt_evidence",
      "timestamp": "2026-03-23T09:00:00Z"
    },
    {
      "id": "et8",
      "eventText": "Daniel texts Marcus: ''I''m coming to your place. Cancel your plans.''",
      "correctOrder": 8,
      "linkedClueId": "md_d7",
      "timestamp": "2026-03-23T19:31:00Z"
    },
    {
      "id": "et9",
      "eventText": "Daniel calls Marcus for 3 minutes",
      "correctOrder": 9,
      "linkedClueId": "cl_daniel_late",
      "timestamp": "2026-03-23T22:52:00Z"
    },
    {
      "id": "et10",
      "eventText": "Daniel texts ''I''m outside'' — last recorded contact before Marcus''s death",
      "correctOrder": 10,
      "linkedClueId": "m_daniel_outside",
      "timestamp": "2026-03-23T22:58:00Z"
    },
    {
      "id": "et11",
      "eventText": "Daniel sends ''checking in'' email as if unaware of Marcus''s death — constructing an alibi",
      "correctOrder": 11,
      "linkedClueId": "em_daniel_monday",
      "timestamp": "2026-03-24T07:15:00Z"
    },
    {
      "id": "et12",
      "eventText": "Marcus Chen''s body is discovered at the base of his apartment stairwell",
      "correctOrder": 12,
      "linkedClueId": null,
      "timestamp": "2026-03-24T09:23:00Z"
    }
  ]',

  -- ── Interrogation Questions ───────────────────────────────
  '[]'
);

-- ── Verify insert ─────────────────────────────────────────────
SELECT
  case_number,
  title,
  difficulty,
  battery_start_percent,
  battery_drain_per_minute,
  jsonb_array_length(contacts)      AS contact_count,
  jsonb_array_length(conversations) AS conversation_count,
  jsonb_array_length(photos)        AS photo_count,
  jsonb_array_length(notes)         AS note_count,
  jsonb_array_length(call_log)      AS call_count,
  jsonb_array_length(emails)        AS email_count,
  jsonb_array_length(solution->'motive_options') AS motive_options_count,
  jsonb_array_length(solution->'key_clue_ids')   AS key_clues_count
FROM public.cases
WHERE case_number = 1;


-- ============================================================
-- GUIDANCE: Updating existing Cases 2–10 in Supabase
-- ============================================================
--
-- The new accusation screen requires motive_options in the
-- solution JSON. Cases without it skip the motive step (player
-- only picks suspect). That is acceptable — add motive_options
-- when you want the full accusation flow.
--
-- To add motive_options to an existing case:
--
--   UPDATE public.cases
--   SET solution = solution || '{
--     "motive_options": [
--       {"id": "mo1", "text": "...", "is_correct": true},
--       {"id": "mo2", "text": "...", "is_correct": false},
--       {"id": "mo3", "text": "...", "is_correct": false},
--       {"id": "mo4", "text": "...", "is_correct": false}
--     ]
--   }'::jsonb
--   WHERE case_number = 2;  -- repeat for each case
--
-- To add battery pressure to an existing case (optional):
--
--   UPDATE public.cases
--   SET
--     battery_start_percent   = 72,   -- how full the phone is when found
--     battery_drain_per_minute = 1.8   -- % drained per minute (0 = no pressure)
--   WHERE case_number = 3;
--
-- Recommended battery values by difficulty:
--   tutorial / easy  → 85–100% start, 0.5–1.2% drain (gentle)
--   medium           → 60–80% start, 1.5–2.0% drain (moderate)
--   hard             → 35–55% start, 2.0–3.0% drain (real urgency)
--   very_hard        → 18–30% start, 3.0–4.0% drain (brutal — player must prioritize)
--
-- To remove deprecated fields from old cases (cleanup only —
-- they are already ignored by the app):
--
--   UPDATE public.cases
--   SET solution = solution
--     - 'options'
--     - 'deduction_checklist'
--   WHERE case_number IN (2, 3, 4, 5, 6, 7, 8, 9, 10);
-- ============================================================
