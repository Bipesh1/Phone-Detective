// Phone Detective - Clue Hint Banner Widget
// Shows contextual guidance specific to each investigation screen.
// Auto-hides once player has 2+ clues (they've learned the mechanic).

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/constants.dart';

enum InvestigationContext {
  messages,
  conversation,
  email,
  notes,
  callLog,
  gallery,
  contacts,
  general,
}

class ClueHintBanner extends StatefulWidget {
  final int clueCount;
  final InvestigationContext context;

  const ClueHintBanner({
    super.key,
    required this.clueCount,
    this.context = InvestigationContext.general,
  });

  @override
  State<ClueHintBanner> createState() => _ClueHintBannerState();
}

class _ClueHintBannerState extends State<ClueHintBanner>
    with SingleTickerProviderStateMixin {
  bool _dismissed = false;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _shouldShow => !_dismissed && widget.clueCount < 2;

  void _dismiss() {
    _controller.reverse().then((_) {
      if (mounted) setState(() => _dismissed = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_shouldShow) return const SizedBox.shrink();

    final (icon, message) = _getContextualHint();

    return SizeTransition(
      sizeFactor: _animation,
      child: Container(
        margin: const EdgeInsets.fromLTRB(12, 8, 12, 4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.clue.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: AppColors.clue.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.clue, size: 18),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: GoogleFonts.roboto(
                  color: AppColors.clue,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            GestureDetector(
              onTap: _dismiss,
              child: Icon(
                Icons.close,
                color: AppColors.clue.withValues(alpha: 0.6),
                size: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  (IconData, String) _getContextualHint() {
    switch (widget.context) {
      case InvestigationContext.messages:
        return (Icons.chat_bubble_outline, 'Tap a conversation to read messages. Look for suspicious details.');
      case InvestigationContext.conversation:
        return (Icons.touch_app, 'Long-press any message to mark it as evidence.');
      case InvestigationContext.email:
        return (Icons.touch_app, 'Tap an email to read it. Long-press to mark as evidence.');
      case InvestigationContext.notes:
        return (Icons.sticky_note_2, 'Tap a note to read. Long-press to mark as evidence.');
      case InvestigationContext.callLog:
        return (Icons.touch_app, 'Long-press a call to mark as evidence. Check voicemails too.');
      case InvestigationContext.gallery:
        return (Icons.photo_camera, 'Tap a photo to view details. Look for anything suspicious.');
      case InvestigationContext.contacts:
        return (Icons.person_search, 'Tap a contact for details. Long-press to mark as suspect.');
      case InvestigationContext.general:
        return (Icons.touch_app, 'Long-press any item to mark as evidence.');
    }
  }
}
