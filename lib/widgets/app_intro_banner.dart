// Phone Detective - App Intro Banner
// Shows once per app the first time a player enters it, Case 1 only.
// Explains what the app contains and how to interact with it.

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/game_state_provider.dart';
import '../utils/constants.dart';

class AppIntroBanner extends StatefulWidget {
  final String appId;
  final String emoji;
  final String appName;
  final String description;
  final String howTo;
  final Color color;

  const AppIntroBanner({
    super.key,
    required this.appId,
    required this.emoji,
    required this.appName,
    required this.description,
    required this.howTo,
    this.color = AppColors.primary,
  });

  @override
  State<AppIntroBanner> createState() => _AppIntroBannerState();
}

class _AppIntroBannerState extends State<AppIntroBanner>
    with SingleTickerProviderStateMixin {
  // Static set — survives navigation within a session.
  // Reset when the app restarts, which is correct (new session = fresh tutorial).
  static final Set<String> _dismissed = {};

  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      duration: const Duration(milliseconds: 350),
      vsync: this,
    );
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    if (!_dismissed.contains(widget.appId)) {
      // Small delay so the screen renders before the banner slides in
      Future.delayed(const Duration(milliseconds: 120), () {
        if (mounted) _ctrl.forward();
      });
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _dismiss() {
    _dismissed.add(widget.appId);
    _ctrl.reverse();
  }

  @override
  Widget build(BuildContext context) {
    // Only show for Case 1
    final caseNumber =
        Provider.of<GameStateProvider>(context, listen: false).currentCase.caseNumber;
    if (caseNumber != 1) return const SizedBox.shrink();
    if (_dismissed.contains(widget.appId)) return const SizedBox.shrink();

    return SizeTransition(
      sizeFactor: _anim,
      axisAlignment: -1,
      child: Container(
        margin: const EdgeInsets.fromLTRB(14, 10, 14, 4),
        decoration: BoxDecoration(
          color: AppColors.backgroundSecondary,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: widget.color.withValues(alpha: 0.3),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──────────────────────────────────────
            Container(
              padding: const EdgeInsets.fromLTRB(14, 11, 10, 11),
              decoration: BoxDecoration(
                color: widget.color.withValues(alpha: 0.1),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(13)),
              ),
              child: Row(
                children: [
                  Text(widget.emoji,
                      style: const TextStyle(fontSize: 18)),
                  const SizedBox(width: 9),
                  Expanded(
                    child: Text(
                      widget.appName,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: _dismiss,
                    behavior: HitTestBehavior.opaque,
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Icon(
                        Icons.close,
                        color: AppColors.textTertiary,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Body ────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.description,
                    style: GoogleFonts.roboto(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // How-to tip
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 7),
                    decoration: BoxDecoration(
                      color: widget.color.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.touch_app,
                            color: widget.color, size: 14),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            widget.howTo,
                            style: GoogleFonts.roboto(
                              fontSize: 12,
                              color: widget.color,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Dismiss button
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: _dismiss,
                      style: TextButton.styleFrom(
                        backgroundColor:
                            widget.color.withValues(alpha: 0.12),
                        foregroundColor: widget.color,
                        padding:
                            const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Got it',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
