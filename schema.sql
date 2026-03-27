-- ============================================================
-- Phone Detective: Production Database Schema
-- Supabase (PostgreSQL) — Run once to set up the cases table
-- ============================================================

-- Step 1: Create the cases table (safe to re-run with IF NOT EXISTS)
CREATE TABLE IF NOT EXISTS public.cases (
  id             bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  case_number    integer NOT NULL UNIQUE,

  -- Display metadata
  title          text NOT NULL,
  subtitle       text NOT NULL DEFAULT '',
  description    text NOT NULL DEFAULT '',
  scenario       text NOT NULL DEFAULT '',       -- Intro briefing shown when starting
  objective      text NOT NULL DEFAULT '',       -- Mission goal shown on case card

  -- Progression
  difficulty     text NOT NULL DEFAULT 'easy',   -- tutorial | easy | medium | hard | very_hard
  unlock_requires jsonb NOT NULL DEFAULT '[]',   -- Array of case_numbers that must be solved first

  -- Theming
  theme_color_hex text DEFAULT '#007AFF',

  -- Progressive hints (array of strings, vague → spoiler)
  hints          jsonb NOT NULL DEFAULT '[]',

  -- Battery mechanic — creates real urgency (0 = no drain, battery stays full)
  battery_start_percent   integer NOT NULL DEFAULT 100,  -- Phone battery % when player picks it up
  battery_drain_per_minute decimal(5,2) NOT NULL DEFAULT 0, -- How fast battery drains (0 = static)

  -- ─── Phone Content (all JSONB) ────────────────────────────
  contacts       jsonb NOT NULL DEFAULT '[]',
  conversations  jsonb NOT NULL DEFAULT '[]',
  photos         jsonb NOT NULL DEFAULT '[]',
  notes          jsonb NOT NULL DEFAULT '[]',
  call_log       jsonb NOT NULL DEFAULT '[]',
  emails         jsonb NOT NULL DEFAULT '[]',

  -- ─── Solution & Game Mechanics ────────────────────────────
  solution       jsonb NOT NULL DEFAULT '{}',

  -- Per-item progressive hints (vague → spoiler per clue node)
  step_hints     jsonb NOT NULL DEFAULT '[]',

  -- Thriller mechanics
  handler_briefing        text NOT NULL DEFAULT '',
  suspense_events         jsonb NOT NULL DEFAULT '[]',
  evidence_timeline       jsonb NOT NULL DEFAULT '[]',
  interrogation_questions jsonb NOT NULL DEFAULT '[]',

  -- Timestamps
  created_at     timestamptz DEFAULT now(),
  updated_at     timestamptz DEFAULT now()
);

-- Step 2: Add columns if they don't exist yet (safe for existing tables)
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'cases' AND column_name = 'unlock_requires') THEN
    ALTER TABLE public.cases ADD COLUMN unlock_requires jsonb NOT NULL DEFAULT '[]';
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'cases' AND column_name = 'suspense_events') THEN
    ALTER TABLE public.cases ADD COLUMN suspense_events jsonb NOT NULL DEFAULT '[]';
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'cases' AND column_name = 'evidence_timeline') THEN
    ALTER TABLE public.cases ADD COLUMN evidence_timeline jsonb NOT NULL DEFAULT '[]';
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'cases' AND column_name = 'interrogation_questions') THEN
    ALTER TABLE public.cases ADD COLUMN interrogation_questions jsonb NOT NULL DEFAULT '[]';
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'cases' AND column_name = 'handler_briefing') THEN
    ALTER TABLE public.cases ADD COLUMN handler_briefing text NOT NULL DEFAULT '';
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'cases' AND column_name = 'battery_start_percent') THEN
    ALTER TABLE public.cases ADD COLUMN battery_start_percent integer NOT NULL DEFAULT 100;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'cases' AND column_name = 'battery_drain_per_minute') THEN
    ALTER TABLE public.cases ADD COLUMN battery_drain_per_minute decimal(5,2) NOT NULL DEFAULT 0;
  END IF;
END
$$;

-- Step 3: Index for fast case lookups
CREATE INDEX IF NOT EXISTS idx_cases_case_number ON public.cases (case_number);

-- ============================================================
-- JSONB SCHEMA REFERENCE (for case authors)
-- ============================================================
--
-- contacts: [
--   {
--     "id": "unique_id",
--     "firstName": "Jane",
--     "lastName": "Doe",
--     "phoneNumber": "+1 (555) 123-4567",
--     "email": "jane@example.com",
--     "relationship": "Best Friend",
--     "notes": "Background info for the detective",
--     "birthday": "1995-06-15",
--     "avatarColorHex": "#E91E63"
--   }
-- ]
--
-- conversations: [
--   {
--     "id": "conv_jane",
--     "contactId": "jane",               -- must match a contact id
--     "messages": [
--       {
--         "id": "m1",
--         "conversationId": "conv_jane",
--         "senderId": "jane",            -- or "owner" for the victim
--         "content": "Hey, are you coming tonight?",
--         "timestamp": "2025-05-03T14:22:00Z",
--         "type": "text",                -- text | image | link | deleted
--         "isLocked": false,             -- optional: password-protected message
--         "password": null,              -- optional: password to unlock
--         "passwordHint": null,          -- optional: hint shown to player
--         "isCorrupted": false,          -- optional: corrupted/garbled message
--         "corruptedContent": null       -- optional: garbled text shown before restore
--       }
--     ]
--   }
-- ]
--
-- photos: [
--   {
--     "id": "p1",
--     "caption": "Screenshot of flight booking",
--     "description": "Detailed description of what the player sees in this photo",
--     "timestamp": "2025-05-04T19:45:00Z"
--   }
-- ]
--
-- notes: [
--   {
--     "id": "nt1",
--     "title": "Packing List",
--     "content": "Full text content of the note...",
--     "createdAt": "2025-05-04T19:00:00Z",
--     "color": "yellow",                 -- yellow | orange | pink | purple | blue | green
--     "isLocked": false,                 -- optional
--     "password": null,                  -- optional
--     "passwordHint": null               -- optional
--   }
-- ]
--
-- call_log: [
--   {
--     "id": "cl1",
--     "contactId": "jane",
--     "phoneNumber": "+1 (555) 123-4567",
--     "type": "incoming",                -- incoming | outgoing | missed | voicemail
--     "timestamp": "2025-05-04T22:40:00Z",
--     "durationSeconds": 180,
--     "note": "3 minute call right before midnight"
--   }
-- ]
--
-- emails: [
--   {
--     "id": "em1",
--     "senderId": "jane",
--     "senderEmail": "jane@example.com",
--     "senderName": "Jane Doe",
--     "subject": "RE: Meeting Tomorrow",
--     "body": "Full email body text...",
--     "timestamp": "2025-05-03T08:00:00Z",
--     "isRead": true,
--     "folder": "inbox",                 -- inbox | sent | trash | drafts
--     "attachments": [
--       {"id": "att1", "name": "document.pdf", "type": "pdf", "sizeBytes": 245000}
--     ],
--     "isLocked": false,                 -- optional
--     "isCorrupted": false               -- optional
--   }
-- ]
--
-- solution: {
--   "guilty_contact_id": "jane",         -- contact id of the culprit
--   "motive": "Full motive description shown after case is solved...",
--   "method": "How they did it, shown after case is solved...",
--   "key_clue_ids": ["m9", "nt1", "em4"], -- INTERNAL: used for post-solve scoring only
--   "resolution": "What happened after the case was solved...",
--   "red_herrings": ["n5", "f5"],         -- IDs of misleading evidence
--
--   -- Accusation screen: player picks motive from these options (all plausible from evidence).
--   -- One and only one should have "is_correct": true.
--   -- If empty, motive step is skipped in the accusation flow.
--   "motive_options": [
--     {
--       "id": "mo1",
--       "text": "Financial gain from a life insurance policy",
--       "is_correct": false
--     },
--     {
--       "id": "mo2",
--       "text": "Jealousy — she discovered a secret affair",
--       "is_correct": true
--     },
--     {
--       "id": "mo3",
--       "text": "Fear of being exposed for embezzlement",
--       "is_correct": false
--     },
--     {
--       "id": "mo4",
--       "text": "Revenge for a past betrayal",
--       "is_correct": false
--     }
--   ],
--
--   -- DEPRECATED: kept for backward compatibility with older cases in the DB.
--   -- No longer used in gameplay — accusation is now open (all contacts pickable).
--   "options": [],
--   "deduction_checklist": [],
--   "clue_insights": {}
-- }
--
-- step_hints: [
--   {
--     "forNodeId": "nt1",                -- ID of the evidence item
--     "hints": [
--       "Vague hint...",
--       "Medium hint...",
--       "Direct spoiler hint..."
--     ]
--   }
-- ]
--
-- suspense_events: [
--   -- Triggered when player finds a specific clue:
--   {
--     "id": "se1",
--     "trigger": "afterClue",            -- fires after marking a specific clue
--     "triggerClueId": "m9",             -- which clue ID triggers this
--     "type": "warning",                 -- notification | warning | glitch | incoming
--     "title": "CRITICAL MESSAGE FOUND",
--     "message": "Atmospheric text shown to player...",
--     "iconName": "warning",
--     "delaySeconds": 2
--   },
--   -- Timed event: fires X seconds after player enters investigation:
--   {
--     "id": "se_timed_1",
--     "trigger": "afterTime",
--     "triggerClueId": null,
--     "type": "incoming",
--     "title": "NEW MESSAGE RECEIVED",
--     "message": "A new message just arrived from an unknown contact...",
--     "iconName": "message",
--     "delaySeconds": 120
--   }
-- ]
--
-- evidence_timeline: [
--   {
--     "id": "et1",
--     "eventText": "What happened at this point in time",
--     "correctOrder": 1,
--     "linkedClueId": "da1",
--     "timestamp": "2025-05-01T16:00:00Z"
--   }
-- ]
--
-- interrogation_questions: [
--   {
--     "id": "iq_jane_1",
--     "contactId": "jane",
--     "question": "Where were you that night?",
--     "answers": [
--       {
--         "requiredClueIds": [],
--         "response": "I was at home.",
--         "revealsClueId": null
--       },
--       {
--         "requiredClueIds": ["m9"],
--         "response": "Okay fine, I was there. But I didn't do anything!",
--         "revealsClueId": "iq_jane_reveal"
--       }
--     ]
--   }
-- ]
--
-- battery_start_percent: 23
-- battery_drain_per_minute: 2.5
--   → Phone starts at 23% battery, drains 2.5% per minute.
--   → Player must prioritize apps — can't check everything leisurely.
--   → At 0% the phone dies and investigation is forced to close.
--   → Use 100 / 0 for cases with no battery pressure (default).
