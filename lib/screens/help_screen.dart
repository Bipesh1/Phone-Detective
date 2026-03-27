// Phone Detective - Field Guide / Help Screen

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/constants.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundSecondary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Field Guide',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
        children: const [
          _SectionHeader('HOW TO INVESTIGATE'),
          _GuideCard(
            icon: Icons.touch_app,
            iconColor: Color(0xFFFFD60A),
            title: 'Mark evidence',
            body:
                'Hold (long-press) any message, email, note, call, or photo to investigate it. A confirmation sheet appears — tap "Investigate" to add it to your evidence board.',
          ),
          _GuideCard(
            icon: Icons.bookmark,
            iconColor: AppColors.clue,
            title: 'Review your evidence',
            body:
                'Open the Detective Journal (the book icon at the bottom). Your marked clues are in the Clues tab. The Evidence Board groups them by type so you can see the full picture.',
          ),
          _GuideCard(
            icon: Icons.gavel,
            iconColor: AppColors.success,
            title: 'Make your accusation',
            body:
                'Once you have at least 3 pieces of evidence, the MAKE YOUR ACCUSATION button activates in your Journal. You don\'t need to find everything — trust your instincts when you know.',
          ),

          SizedBox(height: 8),
          _SectionHeader('THE APPS'),

          _AppGuideCard(
            emoji: '💬',
            name: 'Messages',
            color: Color(0xFF34C759),
            what: 'Text conversations between the victim and every contact.',
            howTo:
                'Tap a conversation to read it. Hold any message that feels suspicious — wrong tone, odd timing, something that doesn\'t add up.',
          ),
          _AppGuideCard(
            emoji: '📞',
            name: 'Recents (Call Log)',
            color: Color(0xFF32ADE6),
            what:
                'A record of every call — incoming, outgoing, missed, and voicemails.',
            howTo:
                'Tap a call entry to see the full details and listen to voicemails. Hold a suspicious call to mark it as evidence. A call made close to the time of death matters.',
          ),
          _AppGuideCard(
            emoji: '👥',
            name: 'Contacts',
            color: Color(0xFFFF9F0A),
            what: 'Everyone in the victim\'s address book with their profile.',
            howTo:
                'Tap a contact to see their relationship and notes. Long-press to mark them as a suspect — they\'ll appear in your Journal\'s Suspects tab.',
          ),
          _AppGuideCard(
            emoji: '📷',
            name: 'Gallery',
            color: Color(0xFFFF375F),
            what:
                'Photos and screenshots saved to the phone — some taken by the victim, some possibly not.',
            howTo:
                'Tap a photo to examine it closely. Read the description carefully — timestamps, locations, and content in images are often the most direct evidence.',
          ),
          _AppGuideCard(
            emoji: '📝',
            name: 'Notes',
            color: Color(0xFFFFD60A),
            what:
                'Private notes — plans, passwords, logs, thoughts. Some may be locked.',
            howTo:
                'Tap to read. Some notes are password-protected — the unlock code is always somewhere else on the phone. Hold a note to mark it as evidence.',
          ),
          _AppGuideCard(
            emoji: '📧',
            name: 'Mail',
            color: Color(0xFF007AFF),
            what: 'Emails including inbox, sent, and drafts.',
            howTo:
                'Check every folder — the Drafts folder often holds the most important things. Hold a suspicious email to mark it. Attachments listed in an email are clues in themselves.',
          ),
          _AppGuideCard(
            emoji: '📓',
            name: 'Detective Journal',
            color: AppColors.clue,
            what:
                'Your personal case file — evidence board, suspects list, timeline, and notes.',
            howTo:
                'Open this to review what you\'ve collected. Use the Notes tab to write your theories. When you\'re ready, tap MAKE YOUR ACCUSATION.',
          ),
          _AppGuideCard(
            emoji: '💡',
            name: 'Hints',
            color: Color(0xFFBF5AF2),
            what: 'Progressive hints for specific pieces of evidence.',
            howTo:
                'If you\'re stuck on a locked note or a specific clue, hints will nudge you in the right direction — from vague to direct. Using hints affects your final score.',
          ),

          SizedBox(height: 8),
          _SectionHeader('TIPS'),
          _TipCard(
            text:
                'Read everything — not just the suspicious parts. Context is everything in a real investigation.',
          ),
          _TipCard(
            text:
                'Passwords are always findable on the phone. If something is locked, look harder in messages, notes, and emails.',
          ),
          _TipCard(
            text:
                'Red herrings exist. Not every suspicious thing is connected to the crime. Think critically.',
          ),
          _TipCard(
            text:
                'You don\'t need to find every piece of evidence before accusing. You need enough to be sure.',
          ),
          _TipCard(
            text:
                'The battery is draining. Prioritize the apps most likely to hold the truth.',
          ),
        ],
      ),
    );
  }
}

// ─── Section Header ───────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String text;
  const _SectionHeader(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 12),
      child: Text(
        text,
        style: GoogleFonts.robotoMono(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: AppColors.textTertiary,
          letterSpacing: 2,
        ),
      ),
    );
  }
}

// ─── Guide Card (mechanic explanation) ───────────────────────────────────────

class _GuideCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String body;

  const _GuideCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.surfaceDark),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  body,
                  style: GoogleFonts.roboto(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── App Guide Card ───────────────────────────────────────────────────────────

class _AppGuideCard extends StatelessWidget {
  final String emoji;
  final String name;
  final Color color;
  final String what;
  final String howTo;

  const _AppGuideCard({
    required this.emoji,
    required this.name,
    required this.color,
    required this.what,
    required this.howTo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // App header
          Container(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.08),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(13)),
            ),
            child: Row(
              children: [
                Text(emoji, style: const TextStyle(fontSize: 20)),
                const SizedBox(width: 10),
                Text(
                  name,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Row(label: 'CONTAINS', text: what),
                const SizedBox(height: 8),
                _Row(label: 'HOW TO USE', text: howTo),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String text;
  const _Row({required this.label, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.robotoMono(
            fontSize: 9,
            fontWeight: FontWeight.w700,
            color: AppColors.textTertiary,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          text,
          style: GoogleFonts.roboto(
            fontSize: 13,
            color: AppColors.textSecondary,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

// ─── Tip Card ─────────────────────────────────────────────────────────────────

class _TipCard extends StatelessWidget {
  final String text;
  const _TipCard({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Icon(
              Icons.arrow_right,
              color: AppColors.textTertiary,
              size: 16,
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.roboto(
                fontSize: 13,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
