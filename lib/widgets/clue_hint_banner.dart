// Phone Detective - Clue Hint Banner Widget
// Shows a dismissible hint about long-pressing items to mark as clues
// Auto-hides once player has 2+ clues

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/constants.dart';

class ClueHintBanner extends StatefulWidget {
  final int clueCount;

  const ClueHintBanner({super.key, required this.clueCount});

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
            Icon(Icons.touch_app, color: AppColors.clue, size: 18),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Long-press any item to mark as evidence',
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
}
