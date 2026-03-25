-- ============================================================
-- Phone Detective: Case 1 Fix
-- Run this AFTER your existing case_runaway_influencer_expanded.sql
-- or run the full replacement below.
-- ============================================================

-- ─── FIX 1: Add missing columns (safe to re-run) ────────────
ALTER TABLE public.cases
  ADD COLUMN IF NOT EXISTS total_clues integer NOT NULL DEFAULT 0,
  ADD COLUMN IF NOT EXISTS unlock_requires jsonb NOT NULL DEFAULT '[]'::jsonb;

-- ─── FIX 2: Update difficulty from 1 (easy) to 0 (tutorial) ─
UPDATE public.cases
SET difficulty = 0
WHERE case_number = 1;

-- ─── FIX 3: Set total_clues to 6 (matches key_clue_ids) ─────
UPDATE public.cases
SET total_clues = 6,
    unlock_requires = '[]'::jsonb
WHERE case_number = 1;

-- ─── FIX 4: Add travel agent contact & fix conv_unknown ──────
-- This replaces contacts and conversations to avoid duplicate Felix threads.

UPDATE public.cases
SET contacts = '[
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
    },
    {
      "id": "skybridge",
      "firstName": "SkyBridge",
      "lastName": "Airlines",
      "phoneNumber": "+1 (800) 555-0199",
      "email": "support@skybridgeair.com",
      "relationship": "Travel Booking Service",
      "notes": "Airline booking confirmation service. Lena contacted them recently.",
      "avatarColorHex": "#607D8B"
    }
  ]'::jsonb
WHERE case_number = 1;

UPDATE public.cases
SET conversations = '[
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
        {"id": "m14", "conversationId": "conv_maya", "senderId": "maya", "content": "I love you too. Be safe. Please text me when you land.", "timestamp": "2025-05-04T23:25:00Z", "type": "text"}
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
        {"id": "f3", "conversationId": "conv_felix", "senderId": "felix", "content": "Well, Noah told me you''d be thrilled. And the sponsors are already locked in. We can''t change it now. Just trust the process!", "timestamp": "2025-05-02T11:08:00Z", "type": "text"},
        {"id": "f4", "conversationId": "conv_felix", "senderId": "owner", "content": "Noah doesn''t speak for me. I''m not comfortable with this, Felix.", "timestamp": "2025-05-02T11:10:00Z", "type": "text"},
        {"id": "f5", "conversationId": "conv_felix", "senderId": "felix", "content": "Listen — between us — I went out on a limb for you with the sponsors. This is a $50K speaking fee. Let''s not make this weird.", "timestamp": "2025-05-02T11:15:00Z", "type": "text"}
      ]
    },
    {
      "id": "conv_skybridge",
      "contactId": "skybridge",
      "messages": [
        {"id": "u1", "conversationId": "conv_skybridge", "senderId": "owner", "content": "Is the booking confirmed?", "timestamp": "2025-05-04T20:10:00Z", "type": "text", "isLocked": true, "password": "bali", "passwordHint": "Where was Lena planning to go? (Check her messages to Maya)"},
        {"id": "u2", "conversationId": "conv_skybridge", "senderId": "skybridge", "content": "Confirmed. Flight DPS-7742. Gate B12. 6:00 AM departure. One-way.", "timestamp": "2025-05-04T20:12:00Z", "type": "text", "isLocked": true, "password": "bali", "passwordHint": "Where was Lena planning to go?"}
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
  ]'::jsonb
WHERE case_number = 1;
